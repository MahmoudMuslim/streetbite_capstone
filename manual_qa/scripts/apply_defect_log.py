"""Replaces the Defect Log sheet with the defects actually observed.

These four bugs were found only by *running* the release APK on a device -
`flutter analyze` and `flutter test` were both green throughout. That is the
whole argument for a real execution round.
"""

from __future__ import annotations

import os

from openpyxl import load_workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
WORKBOOK = os.path.join(ROOT, "manual_qa", "TestPlan_and_TestCases.xlsx")

BRAND_DARK = "00834A"
HEADER_FILL = PatternFill("solid", fgColor=BRAND_DARK)
HEADER_FONT = Font(color="FFFFFF", bold=True, size=11)
PASS_FILL = PatternFill("solid", fgColor="D6F5E3")
FAIL_FILL = PatternFill("solid", fgColor="FBDCDC")
THIN = Side(style="thin", color="D9D9D9")
BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

DEFECTS = [
    [
        "SB-106", "TC_LOGIN_001",
        "App crashed on launch - FirestoreService resolved before it was registered",
        "Critical", "High", "Startup / DI",
        "Fixed in 1.0.0+2",
        "_initFirebaseSafely() called sl<FirestoreService>() while configureDependencies() "
        "had not registered it yet. The throw propagated out of the method, so every "
        "registration after that line was skipped and main() then crashed on "
        "sl<ThemeCubit>(). The static analyser cannot see an ordering bug inside a "
        "service locator; only launching the app exposed it.",
    ],
    [
        "SB-107", "TC_LOGIN_001",
        "App crashed on start-up - AuthRepositoryImpl resolved by its concrete type",
        "Critical", "High", "Startup / DI",
        "Fixed in 1.0.0+2",
        "main() called sl<AuthRepositoryImpl>() for the demo-account seed, but the "
        "repository is deliberately registered against the AuthRepository interface. "
        "Resolving the concrete type is exactly what interface-only registration is "
        "meant to prevent. The seed moved into the composition root "
        "(injection.dart), which is where bootstrap concerns belong.",
    ],
    [
        "SB-108", "TC_LOGIN_001",
        "Login always failed with a valid account whenever Firebase was reachable",
        "Critical", "High", "Authentication",
        "Fixed in 1.0.0+2",
        "The QA account was seeded only in the on-device fallback store. "
        "AuthRepositoryImpl tries Firebase first and correctly refuses to mask a real "
        "credential rejection, so the sign-in was rejected with 'Incorrect email or "
        "password.' The bootstrap now registers the account in Firebase Auth as well, "
        "and writes the display name when the account is first created.",
    ],
    [
        "SB-109", "TC_HOME_008",
        "Home AppBar had no EN/AR toggle, unlike Login, Sign Up, Splash and Profile",
        "Medium", "Medium", "Localization",
        "Fixed in 1.0.0+2",
        "Found while capturing the Arabic screenshot: the toggle was reachable on four "
        "screens but not on the main feed, so changing language from Home required a "
        "detour. LanguageToggleButton added to the Home AppBar.",
    ],
    [
        "SB-110", "TC_LOGIN_001",
        "Login screen was unreachable - the app was permanently signed in",
        "Critical", "High", "Authentication",
        "Fixed in 1.0.0+2",
        "Found by the Appium round, not by the manual one: every automated run failed on "
        "'the Login form never appeared'. The QA-account seed called "
        "createUserWithEmailAndPassword, which authenticates the user as a side effect, "
        "and never signed out again. Firebase persists that session, so restoreSession() "
        "always returned a user and the splash always routed to Home - including straight "
        "after 'adb shell pm clear'. The seed now signs out in a finally block. A related "
        "throttling risk was removed at the same time: re-signing-in on every cold start "
        "is now unnecessary, since the display name persists server-side.",
    ],
    [
        "SB-111", "TC_LOGIN_003",
        "Login form silently pre-filled the QA account's email and password",
        "High", "Medium", "Authentication",
        "Fixed in 1.0.0+2",
        "The screen pre-filled the demo credentials 'so the Appium suite can log in'. "
        "That is a security smell on a real sign-in screen, and it also made TC-LOGIN-003 "
        "untestable: WebElement.clear() does not clear a Flutter TextFormField, so the "
        "'empty form' test actually submitted the pre-filled credentials and signed in. The "
        "pre-fill was removed and the tests type what they intend to submit.",
    ],
    [
        "SB-112", "TC_CART_001",
        "Meal cards collapsed into one accessibility node, hiding Add to Cart from automation",
        "Medium", "Medium", "Accessibility",
        "Fixed in 1.0.0+2",
        "A meal card surfaced as a single merged blob of text ('-10% Algerian Kefta "
        "(Meatballs) $9.58') with no add_to_cart_button or favourite_button resource-id "
        "anywhere in the tree, so the add-to-cart test could not address its target. "
        "Flutter folds a subtree's labels into one node unless it is told not to. "
        "SemanticId now sets explicitChildNodes: true and each card publishes its own "
        "identifier.",
    ],
    [
        "SB-113", "TC_LOGIN_001",
        "Automation: every test reported 'Login form never appeared' - a null driver",
        "Critical", "High", "Automation harness",
        "Fixed in 1.0.0+2",
        "LoginPage and HomePage extended BaseTest but were constructed with only a "
        "WebDriverWait, so they read an inherited `driver` field from their own "
        "uninitialised instance. The resulting NullPointerException was swallowed by the "
        "wait helper and re-thrown as a UI timeout, which sent the investigation after the "
        "app instead of the harness. Fixed by converting both page objects to composition "
        "(the live AndroidDriver is injected) and by making Waits.until rethrow anything "
        "that is not a genuine TimeoutException. The added page-source capture is what "
        "proved it: no findElement had ever been issued.",
    ],
    [
        "SB-114", "TC_HOME_009",
        "Cloud Firestore denied every read and write - the project had no rules file",
        "Critical", "High", "Backend / Firestore",
        "Fixed in 1.0.0+3",
        "The Firebase project was created without a firestore.rules file, leaving the "
        "database in its default locked state. Every call returned PERMISSION_DENIED: "
        "'Missing or insufficient permissions', which silently broke the Profile screen, "
        "the favourites list and the order history while Firebase Auth kept working - so "
        "the app looked mostly fine and only the Firestore-backed screens failed. The "
        "repository layer could not mask it either, because FirestoreService.isAvailable "
        "only reports whether the SDK initialised, never whether the rules permit access. "
        "Owner-scoped rules were written and deployed (firestore.rules).",
    ],
    [
        "SB-115", "TC_LOGIN_001",
        "The app signed the user out of their own session on every launch",
        "Critical", "High", "Authentication",
        "Fixed in 1.0.0+3",
        "The QA-account seed called createUserWithEmailAndPassword, which signs the new "
        "user in as a side effect, and then signed out in a `finally` block. Because the "
        "seed runs on EVERY launch, a real user who had signed in was signed straight "
        "back out: the splash restored the session and the seed destroyed it a moment "
        "later, so the next cold start had nothing to restore. Fixed by tracking whether "
        "the seed actually authenticated anyone, and signing out only in that case.",
    ],
    [
        "SB-116", "TC_HOME_009",
        "A 'zombie session' showed an authenticated UI while the backend had no session",
        "Critical", "High", "Authentication",
        "Fixed in 1.0.0+3",
        "restoreSession() fell back to the on-device session store when Firebase had no "
        "current user. Combined with SB-115 that produced a screen that looked fully "
        "signed in while every Firestore request carried no auth token - so favourites "
        "and orders rendered 'We couldn't reach StreetBite' behind a Retry that could "
        "never succeed. When Firebase is usable it is now the only authority on whether "
        "anyone is signed in; the local store is consulted only when Firebase is "
        "unavailable.",
    ],
    [
        "SB-117", "TC_PROFILE_001",
        "The Profile tab was permanently unreachable when biometrics could not succeed",
        "High", "Medium", "Authentication / UX",
        "Fixed in 1.0.0+3",
        "Both entry points to the profile passed bypassAllowed: false. On a device whose "
        "biometrics can never succeed - no hardware, nothing enrolled, sensor locked out - "
        "tapping the avatar flashed a four-second SnackBar reading 'Biometric check "
        "failed. Try again.' and left the user staring at the gate forever. Retrying could "
        "not help and there was no way forward. Viewing a profile is not a privileged "
        "action, so the gate now always offers 'Continue without biometrics'.",
    ],
    [
        "SB-118", "TC_PROFILE_003",
        "The Profile screen re-queried Firestore on every rebuild",
        "Medium", "Medium", "Performance",
        "Fixed in 1.0.0+3",
        "_ProfileView called FavouritesCubit.load() and OrdersCubit.load() directly inside "
        "build(). Every rebuild - including the one triggered by those very calls emitting "
        "their result - fired both queries again, so the screen hammered Firestore "
        "continuously and any transient failure left a stale error view behind. Loading is "
        "now done once per uid from initState via addPostFrameCallback.",
    ],
    [
        "SB-119", "TC_MAP_001",
        "Google Maps API key is rejected - the map renders blank and could freeze the app",
        "High", "Medium", "Maps / Credentials",
        "Partially fixed in 1.0.0+3",
        "The Maps SDK logs 'Error requesting API token. StatusCode=INVALID_ARGUMENT' and "
        "'Authorization failure' for the configured key, so no tiles are drawn and the "
        "screen was solid black. Worse, Google's SDK retries token acquisition on the UI "
        "thread, and on one attempt Android declared an ANR - 'StreetBite isn't "
        "responding' - and killed the app. The app side is mitigated: the map now has a "
        "startup deadline and falls back to a readable error view with Retry instead of "
        "blocking. THE KEY ITSELF STILL NEEDS FIXING in Google Cloud Console (enable Maps "
        "SDK for Android, or supply a valid key in android/key.properties); that part is "
        "outside the repository and remains OPEN.",
    ],
]


def main() -> None:
    workbook = load_workbook(WORKBOOK)

    if "Defect Log" in workbook.sheetnames:
        del workbook["Defect Log"]
    sheet = workbook.create_sheet("Defect Log")

    sheet["A1"] = "Defect Log (mirrors the Jira board)"
    sheet["A1"].font = Font(bold=True, size=14, color=BRAND_DARK)
    sheet.merge_cells("A1:H1")
    sheet["A2"] = (
        f"Defects found during the execution rounds ({len(DEFECTS)} in total). "
        "Every one was invisible to `flutter analyze` and `flutter test` - the four "
        "SB-106..SB-109 were found by running the release APK on a device, and "
        "SB-110..SB-113 by the Appium suite, which is the strongest argument yet for "
        "doing both."
    )
    sheet["A2"].font = Font(italic=True, color="666666", size=10)
    sheet.merge_cells("A2:H2")

    headers = ["Jira Key", "Test Case", "Summary", "Severity", "Priority",
               "Component", "Status", "Root Cause / Fix"]
    for column, title in enumerate(headers, start=1):
        cell = sheet.cell(row=4, column=column, value=title)
        cell.fill = HEADER_FILL
        cell.font = HEADER_FONT
        cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
        cell.border = BORDER

    for offset, defect in enumerate(DEFECTS):
        row = 5 + offset
        for column, value in enumerate(defect, start=1):
            cell = sheet.cell(row=row, column=column, value=value)
            cell.border = BORDER
            cell.alignment = Alignment(vertical="top", wrap_text=True)
        sheet.cell(row=row, column=4).fill = (
            FAIL_FILL if defect[3] == "Critical" else PatternFill("solid", fgColor="FFF2CC")
        )
        sheet.cell(row=row, column=7).fill = PASS_FILL

    for index, width in enumerate([12, 16, 56, 12, 12, 16, 18, 78], start=1):
        sheet.column_dimensions[chr(64 + index)].width = width
    sheet.freeze_panes = "A5"

    workbook.save(WORKBOOK)
    print(f"Defect Log rewritten with {len(DEFECTS)} real defects")


if __name__ == "__main__":
    main()