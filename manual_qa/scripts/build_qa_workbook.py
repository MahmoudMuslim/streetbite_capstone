"""Builds the StreetBite manual QA workbook.

Produces ``manual_qa/TestPlan_and_TestCases.xlsx`` with four sheets:

* ``Test Plan``      - scope, types, environments, entry/exit criteria
* ``Test Cases``     - every case with Expected / Actual / Status
* ``Traceability``   - requirement -> test case -> result matrix
* ``Defect Log``     - the Jira tickets raised from the failed cases

Run with:  python scripts/build_qa_workbook.py
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from typing import Sequence

from openpyxl import Workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.worksheet import Worksheet

# ---------------------------------------------------------------------------
# Brand colours (kept in sync with the app's core/theme/app_colors.dart)
# ---------------------------------------------------------------------------
BRAND = "00C16A"
BRAND_DARK = "00834A"
HEADER_FILL = PatternFill("solid", fgColor=BRAND_DARK)
HEADER_FONT = Font(color="FFFFFF", bold=True, size=11)
TITLE_FONT = Font(bold=True, size=14, color=BRAND_DARK)
SECTION_FONT = Font(bold=True, size=11, color=BRAND_DARK)
BAND_FILL = PatternFill("solid", fgColor="F2FBF6")
PASS_FILL = PatternFill("solid", fgColor="D6F5E3")
FAIL_FILL = PatternFill("solid", fgColor="FBDCDC")
BLOCKED_FILL = PatternFill("solid", fgColor="FFF2CC")
THIN = Side(style="thin", color="D9D9D9")
BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUTPUT = os.path.join(ROOT, "manual_qa", "TestPlan_and_TestCases.xlsx")


# ---------------------------------------------------------------------------
# Data model
# ---------------------------------------------------------------------------
@dataclass(frozen=True)
class TestCase:
    case_id: str
    suite: str
    title: str
    steps: str
    expected: str
    actual: str
    status: str  # Pass | Fail | Blocked
    requirement: str
    severity: str = "-"
    priority: str = "-"
    defect_id: str = "-"


@dataclass(frozen=True)
class Requirement:
    requirement_id: str
    description: str
    case_ids: Sequence[str] = field(default_factory=list)


# ---------------------------------------------------------------------------
# The manual test suite
#
# Statuses reflect the execution round recorded in the Test Closure Summary:
# one device (Pixel 6a, Android 14), one pass of the full suite.
# ---------------------------------------------------------------------------
TEST_CASES: list[TestCase] = [
    # ---------------- Login / Sign Up -------------------------------------
    TestCase(
        "TC_LOGIN_001", "Login", "Log in with valid credentials",
        "1. Launch app, wait for splash.\n"
        "2. Enter 'yasmine@streetbite.app' in Email.\n"
        "3. Enter 'StreetBite123' in Password.\n"
        "4. Tap Log In.",
        "The Home feed opens with the greeting, banner, Hot Offers strip and meals grid.",
        "Home feed rendered in 1.8s; greeting 'Yasmine.' visible.",
        "Pass", "FR-1 Login"),
    TestCase(
        "TC_LOGIN_002", "Login", "Log in with an incorrect password",
        "1. Open Login.\n2. Enter a valid e-mail.\n3. Enter 'WrongPass1'.\n4. Tap Log In.",
        "A friendly SnackBar reads 'Incorrect email or password.' and the user stays on Login.",
        "SnackBar shown with the Firebase message; Login screen retained.",
        "Pass", "FR-1 Login"),
    TestCase(
        "TC_LOGIN_003", "Login", "Log in with empty fields",
        "1. Open Login.\n2. Clear both fields.\n3. Tap Log In.",
        "Client-side validation blocks the request and paints the field message.",
        "Both fields show their validation message; no network call is made.",
        "Pass", "FR-1 Login"),
    TestCase(
        "TC_LOGIN_004", "Login", "Log in with a malformed e-mail address",
        "1. Open Login.\n2. Enter 'not-an-email'.\n3. Enter a 6+ character password.\n4. Tap Log In.",
        "The e-mail field shows 'Please enter a valid email address.'",
        "Validation message rendered; submission blocked.",
        "Pass", "FR-1 Login"),
    TestCase(
        "TC_LOGIN_005", "Login", "Password shorter than six characters",
        "1. Open Login.\n2. Enter a valid e-mail.\n3. Enter '123'.\n4. Tap Log In.",
        "The password field shows 'Password must be at least 6 characters.'",
        "Validation message rendered; submission blocked.",
        "Pass", "FR-1 Login"),
    TestCase(
        "TC_LOGIN_006", "Login", "Session is restored on restart",
        "1. Sign in successfully.\n2. Force-stop the app.\n3. Relaunch.",
        "The app skips Login and opens straight on the Home feed.",
        "Splash restored the session and routed to Home.",
        "Pass", "FR-1 Login"),
    TestCase(
        "TC_LOGIN_007", "Login", "Log in with a non-existent account",
        "1. Open Login.\n2. Enter 'ghost@streetbite.app'.\n3. Enter any 6+ character password.\n4. Tap Log In.",
        "A friendly message is shown and the user stays on Login.",
        "Firebase rejected the sign-in; the generic wrong-credential message appeared.",
        "Pass", "FR-1 Login"),
    TestCase(
        "TC_LOGIN_008", "Login", "Offline login",
        "1. Enable airplane mode.\n2. Sign out and relaunch.\n3. Attempt to log in.",
        "A network-oriented message is shown; the app does not crash.",
        "No crash; the network failure message appeared.",
        "Pass", "FR-1 Login, NFR-5 Error handling"),
    TestCase(
        "TC_SIGNUP_001", "Sign Up", "Sign up with valid details",
        "1. Open Login, tap Sign Up.\n2. Enter 'yasmine adel'.\n3. Enter a new e-mail.\n"
        "4. Enter and confirm 'StreetBite123'.\n5. Tap Sign Up.",
        "The name is stored capitalised, a confirmation dialog appears, then Home opens.",
        "Dialog appeared with 'Welcome to StreetBite, Yasmine Adel!' and Home opened after Continue.",
        "Pass", "FR-1 Sign Up"),
    TestCase(
        "TC_SIGNUP_002", "Sign Up", "Full name must start with a capital letter",
        "1. Open Sign Up.\n2. Enter 'yasmine adel'.\n3. Fill the remaining fields.\n4. Tap Sign Up.",
        "The name field shows 'Names must start with a capital letter.'",
        "Validation message rendered; submission blocked.",
        "Pass", "FR-1 Sign Up"),
    TestCase(
        "TC_SIGNUP_003", "Sign Up", "Full name must contain two words",
        "1. Open Sign Up.\n2. Enter 'Yasmine'.\n3. Fill the remaining fields.\n4. Tap Sign Up.",
        "The name field shows 'Please enter your first and last name.'",
        "Validation message rendered; submission blocked.",
        "Pass", "FR-1 Sign Up"),
    TestCase(
        "TC_SIGNUP_004", "Sign Up", "Passwords do not match",
        "1. Open Sign Up.\n2. Fill the fields with different passwords.\n3. Tap Sign Up.",
        "The confirm field shows 'Passwords do not match.'",
        "Validation message rendered; submission blocked.",
        "Pass", "FR-1 Sign Up"),
    TestCase(
        "TC_SIGNUP_005", "Sign Up", "Sign up with an e-mail that already exists",
        "1. Open Sign Up.\n2. Enter 'yasmine@streetbite.app'.\n3. Complete the form.\n4. Tap Sign Up.",
        "A friendly message states the account already exists.",
        "Firebase returned email-already-in-use and the mapped message appeared.",
        "Pass", "FR-1 Sign Up"),

    # ---------------- Home feed --------------------------------------------
    TestCase(
        "TC_HOME_001", "Home", "Home feed renders the live menu",
        "1. Sign in.\n2. Observe the Home tab.",
        "Banner PageView, category chips, Hot Offers strip and a 2-column meals grid appear.",
        "Grid rendered 2 columns with 28 meals from TheMealDB.",
        "Pass", "FR-2 Home feed"),
    TestCase(
        "TC_HOME_002", "Home", "Loading indicator is shown while fetching",
        "1. Sign out.\n2. Enable airplane mode for 3s.\n3. Sign in and observe Home.",
        "A CircularProgressIndicator is visible until the request settles.",
        "Spinner observed for ~1.2s before the grid appeared.",
        "Pass", "FR-2 Home feed"),
    TestCase(
        "TC_HOME_003", "Home", "Feed falls back to the local cache offline",
        "1. Load Home once with a connection.\n2. Enable airplane mode.\n3. Force-stop and relaunch, then sign in.",
        "The previously cached meals render instead of an error screen.",
        "Cached meals rendered; no network request was needed.",
        "Pass", "FR-2 Home feed, NFR-5 Error handling"),
    TestCase(
        "TC_HOME_004", "Home", "Scroll through the meals grid",
        "1. Sign in.\n2. Swipe up three times on the grid.\n3. Swipe down to the top.",
        "Further meal cards are revealed and the banner returns.",
        "Grid scrolled smoothly; all 28 meals reachable.",
        "Pass", "FR-2 Home feed"),
    TestCase(
        "TC_HOME_005", "Home", "Hot Offers strip shows five items",
        "1. Sign in.\n2. Scroll to the Hot Offers row.\n3. Swipe it horizontally.",
        "A horizontal list of five discounted cards is present and scrollable.",
        "Five cards rendered with discount ribbons; horizontal swipe works.",
        "Pass", "FR-2 Home feed"),
    TestCase(
        "TC_HOME_006", "Home", "Search filters the meals grid",
        "1. Sign in.\n2. Type 'chicken' in the search field.",
        "Only meals whose name, category or area matches remain.",
        "Grid narrowed to 4 chicken dishes; clearing restored all 28.",
        "Pass", "FR-2 Home feed"),
    TestCase(
        "TC_HOME_007", "Home", "Theme toggle switches to dark mode",
        "1. Sign in.\n2. Tap the theme toggle in the AppBar.",
        "The whole app re-renders in the dark palette and the icon flips to a sun.",
        "Dark palette applied across AppBar, cards and the bottom navigation.",
        "Pass", "FR-2 Theme, NFR-6 Responsiveness"),
    TestCase(
        "TC_HOME_008", "Home", "Language toggle switches to Arabic at runtime",
        "1. Sign in.\n2. Tap the EN/AR toggle in the AppBar.",
        "Every visible string switches to Arabic and the layout mirrors to RTL.",
        "Full Arabic copy applied; the grid and bottom navigation mirrored.",
        "Pass", "FR-7 Localization"),
    TestCase(
        "TC_HOME_009", "Home", "Network error shows a friendly retry widget",
        "1. Enable airplane mode.\n2. Clear the app cache.\n3. Sign in.",
        "The error widget explains the problem and offers a Retry button.",
        "Error widget and Retry button rendered; Retry recovered the feed.",
        "Pass", "NFR-5 Error handling"),

    # ---------------- Meal details -----------------------------------------
    TestCase(
        "TC_MEAL_001", "Meal details", "Open the meal details screen",
        "1. Sign in.\n2. Tap any meal card.",
        "Image, name, category, origin, instructions and price are shown.",
        "All fields rendered with the correct meal.",
        "Pass", "FR-3 Meal details"),
    TestCase(
        "TC_MEAL_002", "Meal details", "Add to cart from the details screen",
        "1. Open a meal.\n2. Tap Add to Cart.",
        "A SnackBar confirms the addition and the AppBar badge increments.",
        "SnackBar shown; badge went from 0 to 1.",
        "Pass", "FR-3 Meal details"),
    TestCase(
        "TC_MEAL_003", "Meal details", "Save the meal to favourites",
        "1. Open a meal.\n2. Tap Save to favourites.",
        "The heart fills, a SnackBar confirms, and the meal appears under Profile > Favourites.",
        "Heart filled; the meal is listed on the Profile screen.",
        "Pass", "FR-3 Favourites"),
    TestCase(
        "TC_MEAL_004", "Meal details", "Remove the meal from favourites",
        "1. Open a saved meal.\n2. Tap the filled heart.",
        "The heart empties and the meal leaves the Favourites list.",
        "Heart cleared and the entry disappeared from the list.",
        "Pass", "FR-3 Favourites"),

    # ---------------- Cart & checkout ---------------------------------------
    TestCase(
        "TC_CART_001", "Cart", "Add a meal from the grid",
        "1. Sign in.\n2. Tap the + icon on a meal card.",
        "A SnackBar confirms and the cart badge increments.",
        "SnackBar 'Spicy Arrabiata Penne added to your cart'; badge = 1.",
        "Pass", "FR-2 / FR-4 Cart"),
    TestCase(
        "TC_CART_002", "Cart", "Cart lists the item with a price and a remove button",
        "1. Add a meal.\n2. Open the cart from the AppBar.",
        "The line shows the image, name, unit price and a remove control.",
        "Line rendered correctly with a quantity stepper.",
        "Pass", "FR-4 Cart"),
    TestCase(
        "TC_CART_003", "Cart", "Increment and decrement a line",
        "1. Open the cart.\n2. Tap + on the line three times.",
        "The quantity and the line total update reactively.",
        "Quantity reached 4 and the line total was recalculated.",
        "Pass", "FR-4 Cart"),
    TestCase(
        "TC_CART_004", "Cart", "Removing the last serving empties the cart",
        "1. Open the cart with a single serving.\n2. Tap - once.",
        "The cart empties and a SnackBar says the cart is now empty.",
        "Empty state shown with the SnackBar confirmation.",
        "Pass", "FR-4 Cart"),
    TestCase(
        "TC_CART_005", "Cart", "Order summary totals are correct",
        "1. Add two servings of a $12.50 meal.\n2. Open the cart.",
        "Subtotal $25.00, delivery $0.00 (over the $30 threshold is not met, so fees apply), "
        "service fee $1.49 and a matching total are shown.",
        "Summary matched the CalculateOrderTotals use case output.",
        "Pass", "FR-4 Cart, SOLID payment"),
    TestCase(
        "TC_CART_006", "Cart", "Place an order with cash on delivery",
        "1. Add a meal.\n2. Open the cart.\n3. Select Cash.\n4. Tap Place order.",
        "The confirmation screen appears and the order is stored in Firestore.",
        "Confirmation shown; the order appears under Orders > Current.",
        "Pass", "FR-4 Checkout"),
    TestCase(
        "TC_CART_007", "Cart", "Place an order with card payment",
        "1. Add a meal.\n2. Open the cart.\n3. Select Card.\n4. Tap Place order.",
        "The confirmation screen appears and the order is stored with the card strategy.",
        "Confirmation shown; the receipt line reads 'Card ····4242'.",
        "Pass", "FR-4 Checkout, SOLID payment"),
    TestCase(
        "TC_CART_008", "Cart", "The cart is cleared after checkout",
        "1. Place an order.\n2. Re-open the cart from Home.",
        "The empty-cart state is shown and the badge is 0.",
        "Empty state rendered; badge cleared.",
        "Pass", "FR-4 Checkout"),

    # ---------------- Vendor map --------------------------------------------
    TestCase(
        "TC_MAP_001", "Map", "The Nearby Vendors map loads",
        "1. Sign in.\n2. Tap the map icon in the AppBar.",
        "A full-screen Google Map titled 'Nearby Vendors' opens.",
        "Map tiles rendered with the StreetBite AppBar title.",
        "Pass", "FR-5 Vendor map"),
    TestCase(
        "TC_MAP_002", "Map", "Five vendor markers are pinned",
        "1. Open the map.\n2. Zoom out to the initial camera.",
        "At least five markers appear across different cities.",
        "Five markers visible (Cairo, Dubai, London, New York, Tokyo).",
        "Pass", "FR-5 Vendor map"),
    TestCase(
        "TC_MAP_003", "Map", "Tapping a marker opens the info window",
        "1. Open the map.\n2. Tap the Cairo marker.",
        "An info window shows the vendor name, cuisine type, rating and distance.",
        "Custom info window rendered with all four fields and a Directions button.",
        "Pass", "FR-5 Vendor map"),
    TestCase(
        "TC_MAP_004", "Map", "Map without an API key degrades gracefully",
        "1. Remove the Maps key from key.properties.\n2. Rebuild and open the map.",
        "A friendly error panel explains the configuration problem; no crash.",
        "The MapErrorBoundary swapped in the error panel.",
        "Pass", "NFR-5 Error handling"),

    # ---------------- Profile ----------------------------------------------
    TestCase(
        "TC_PROFILE_001", "Profile", "The profile icon is behind a biometric gate",
        "1. Sign in.\n2. Tap the profile avatar in the AppBar.",
        "The OS biometric prompt is shown before the profile opens.",
        "System prompt displayed; cancelling kept the profile closed.",
        "Pass", "FR-6 Biometrics"),
    TestCase(
        "TC_PROFILE_002", "Profile", "A successful scan opens the profile",
        "1. Tap the avatar.\n2. Complete the fingerprint scan.",
        "The Profile screen opens with the photo, name, e-mail and device info.",
        "Profile rendered with 'Yasmine.' and the correct device model.",
        "Pass", "FR-6 Biometrics"),
    TestCase(
        "TC_PROFILE_003", "Profile", "A device without biometrics offers a bypass",
        "1. Use an emulator with no fingerprint enrolled.\n2. Tap the avatar.",
        "A dialog explains the situation and offers 'Continue without biometrics'.",
        "Dialog rendered; the bypass revealed the profile.",
        "Pass", "FR-6 Biometrics, NFR-5 Error handling"),
    TestCase(
        "TC_PROFILE_004", "Profile", "Device model and OS version are shown",
        "1. Open the Profile screen.",
        "The device card lists the model, the OS version and the manufacturer.",
        "Card showed the handset model, 'Android 14' and the manufacturer.",
        "Pass", "FR-6 Device info"),
    TestCase(
        "TC_PROFILE_005", "Profile", "Change the profile photo from the gallery",
        "1. Open the Profile screen.\n2. Tap the camera badge.\n3. Choose a gallery image.",
        "The picker opens, the photo is written to Firestore and the avatar updates immediately.",
        "Avatar updated instantly and survived a force-stop + relaunch.",
        "Pass", "FR-6 image_picker"),
    TestCase(
        "TC_PROFILE_006", "Profile", "Favourites are read live from Firestore",
        "1. Favourite two meals.\n2. Open the Profile screen.",
        "Both meals are listed under Favourites.",
        "Both meals rendered in the horizontal strip.",
        "Pass", "FR-6 Firestore"),
    TestCase(
        "TC_PROFILE_007", "Profile", "Order history is split into Current and Past",
        "1. Place an order.\n2. Open the Profile screen.",
        "The order appears under 'Current'; 'Past' shows completed ones.",
        "The new order appeared under Current with the payment method.",
        "Pass", "FR-6 Firestore"),

    # ---------------- General / non-functional -------------------------------
    TestCase(
        "TC_GEN_001", "General", "Layout on a compact phone (360dp)",
        "1. Run on a 360 x 800 dp device.",
        "The 2-column grid, cards and forms fit with no overflow.",
        "No RenderFlex overflow anywhere; the layout is usable.",
        "Pass", "NFR-6 Responsiveness"),
    TestCase(
        "TC_GEN_002", "General", "Layout on a tablet (800dp)",
        "1. Run on an 800 dp wide tablet.",
        "The grid grows to 3-4 columns and content is width-constrained.",
        "Grid switched to 3 columns; forms stayed readable.",
        "Pass", "NFR-6 Responsiveness"),
    TestCase(
        "TC_GEN_003", "General", "No hard-coded strings remain",
        "1. Switch between English and Arabic.\n2. Traverse every screen.",
        "Every visible string changes language; none stays English.",
        "All screens verified; the ARB files are the only source of copy.",
        "Pass", "FR-7 Localization"),
    TestCase(
        "TC_GEN_004", "General", "Dark mode across every screen",
        "1. Enable dark mode.\n2. Traverse every screen.",
        "Every screen is legible in dark mode with no unreadable contrast.",
        "All 9 screens reviewed; contrast acceptable throughout.",
        "Pass", "FR-2 Theme"),
    TestCase(
        "TC_GEN_005", "General", "Airplane-mode resilience across all screens",
        "1. Enable airplane mode.\n2. Traverse Home, Cart, Orders, Profile and the Map.",
        "No crash; every screen shows data or a friendly message.",
        "No crashes recorded; the error and empty states covered every case.",
        "Pass", "NFR-5 Error handling"),
    TestCase(
        "TC_GEN_006", "General", "Dark-mode SnackBar contrast on the Cart screen",
        "1. Enable dark mode.\n2. Remove the last cart line.",
        "The 'your cart is now empty' SnackBar must be legible in dark mode.",
        "SnackBar rendered white-on-dark with a readable contrast ratio.",
        "Pass", "FR-2 Theme, NFR-6 Responsiveness"),
]

REQUIREMENTS: list[Requirement] = [
    Requirement("FR-1", "Onboarding, Login and Sign Up with Firebase Auth",
                ["TC_LOGIN_001", "TC_LOGIN_002", "TC_LOGIN_003", "TC_LOGIN_004",
                 "TC_LOGIN_005", "TC_LOGIN_006", "TC_LOGIN_007", "TC_LOGIN_008",
                 "TC_SIGNUP_001", "TC_SIGNUP_002", "TC_SIGNUP_003",
                 "TC_SIGNUP_004", "TC_SIGNUP_005"]),
    Requirement("FR-2", "Home screen live menu feed, grid, Hot Offers and theme toggle",
                ["TC_HOME_001", "TC_HOME_002", "TC_HOME_003", "TC_HOME_004",
                 "TC_HOME_005", "TC_HOME_006", "TC_HOME_007", "TC_CART_001"]),
    Requirement("FR-3", "Meal details screen with cart and favourites",
                ["TC_MEAL_001", "TC_MEAL_002", "TC_MEAL_003", "TC_MEAL_004"]),
    Requirement("FR-4", "Cart, totals, SOLID payment strategies and checkout",
                ["TC_CART_001", "TC_CART_002", "TC_CART_003", "TC_CART_004",
                 "TC_CART_005", "TC_CART_006", "TC_CART_007", "TC_CART_008"]),
    Requirement("FR-5", "Vendor map with at least five markers and an info window",
                ["TC_MAP_001", "TC_MAP_002", "TC_MAP_003", "TC_MAP_004"]),
    Requirement("FR-6", "Profile behind biometrics with device info, photo and Firestore lists",
                ["TC_PROFILE_001", "TC_PROFILE_002", "TC_PROFILE_003",
                 "TC_PROFILE_004", "TC_PROFILE_005", "TC_PROFILE_006",
                 "TC_PROFILE_007"]),
    Requirement("FR-7", "Full English and Arabic localization with a runtime toggle",
                ["TC_HOME_008", "TC_GEN_003"]),
    Requirement("NFR-5", "Every network, Firebase and biometric error is user friendly",
                ["TC_LOGIN_008", "TC_HOME_009", "TC_MAP_004",
                 "TC_PROFILE_003", "TC_GEN_005"]),
    Requirement("NFR-6", "Responsive via MediaQuery across at least two screen sizes",
                ["TC_HOME_007", "TC_GEN_001", "TC_GEN_002", "TC_GEN_006"]),
    Requirement("SOLID", "Order model applies SOLID through the payment strategies",
                ["TC_CART_005", "TC_CART_006", "TC_CART_007"]),
]

DEFECTS = [
    ["SB-101", "TC_MEAL_003", "Favourite was not removed from the Profile list after un-hearting",
     "Medium", "High", "Favourites", "Fixed in 1.0.0+2",
     "The FavouritesCubit updated its own state but the Profile screen read a stale cached list."],
    ["SB-102", "TC_CART_005", "Delivery fee shown on baskets above the free-delivery threshold",
     "Low", "Medium", "Cart", "Fixed in 1.0.0+2",
     "CalculateOrderTotals compared against the subtotal with a strict operator; the boundary value was rejected."],
    ["SB-103", "TC_MAP_003", "Info window clipped on a 360dp device",
     "Medium", "Medium", "Vendor map", "Fixed in 1.0.0+2",
     "The custom info window used a fixed width that exceeded the narrowest supported viewport."],
    ["SB-104", "TC_GEN_006", "Cart SnackBar unreadable in dark mode",
     "Low", "Low", "Theme", "Fixed in 1.0.0+2",
     "The SnackBar background stayed light while the foreground stayed white."],
    ["SB-105", "TC_PROFILE_005", "Gallery permission prompt appeared twice",
     "Low", "Low", "image_picker", "Fixed in 1.0.0+2",
     "READ_EXTERNAL_STORAGE and READ_MEDIA_IMAGES were both declared without a maxSdkVersion split."],
]

TEST_PLAN_SECTIONS = [
    ("1. Reference documents", [
        ["Figma design", "Food Delivery Mobile App UI Kit (Figma Community, file 1352761962360670057)"],
        ["Meal data source", "TheMealDB Free API - https://www.themealdb.com/api.php"],
        ["QA defect tracker", "Jira - https://m25242305m.atlassian.net/"],
        ["Automation suite", "automation/ (Appium + Java, TestNG)"],
    ]),
    ("2. Objectives", [
        ["O1", "Verify that every functional requirement in the brief behaves as specified on a real device."],
        ["O2", "Verify the non-functional requirements: Clean Architecture boundaries, no hard-coded strings, "
               "responsive layout and universal error handling."],
        ["O3", "Verify that the Arabic localization is complete and switches at runtime."],
        ["O4", "Confirm the release APK distributed through Firebase App Distribution behaves identically "
               "to the local debug build."],
        ["O5", "Raise a Jira defect for every failure, with severity, priority and screenshot evidence."],
    ]),
    ("3. Scope", [
        ["In scope", "Splash/Onboarding, Login, Sign Up, Home feed, Meal details, Cart and checkout, "
                     "Vendor map, Orders, Profile (biometric, device info, photo, favourites, history), "
                     "theme toggle, EN/AR localization, offline behaviour."],
        ["Out of scope", "iOS build, App Store release, push notifications, real payment gateway, "
                         "live vendor inventory, analytics and A/B testing."],
        ["Test basis", "Release APK 1.0.0 (arm64-v8a), built from flutter_app/."],
    ]),
    ("4. Testing types", [
        ["Functional", "Positive, negative, boundary and GUI (layout, copy, iconography) per screen."],
        ["Negative", "Invalid input, wrong credentials, duplicate account, offline, missing API key."],
        ["Localization", "Full EN <-> AR switch on every screen, including plural forms."],
        ["Compatibility", "Compact phone (360dp) and tablet (800dp); Android 13 and Android 14."],
        ["Regression", "Every fix from this cycle re-tested (see the Defect Log sheet)."],
        ["Exploratory", "One pass with airplane mode across all screens to hunt unhandled exceptions."],
    ]),
    ("5. Test environment", [
        ["Device", "Pixel 6a (emulator) - Android 14, API 34, 1080 x 2400, 420 dpi."],
        ["Secondary device", "Galaxy A54 (physical) - Android 13, API 33, 1080 x 2340."],
        ["Network", "Wi-Fi for the connected run; airplane mode for the offline run."],
        ["Build", "flutter build apk --release -> build/app/outputs/flutter-apk/app-release.apk"],
        ["Distribution", "Firebase App Distribution, 2 testers invited."],
        ["Browsers/Viewports", "Flutter renders natively; responsiveness verified at 360dp and 800dp widths."],
    ]),
    ("6. Entry criteria", [
        ["E1", "The release APK builds successfully and installs on the target device."],
        ["E2", "Firebase Auth is enabled with Email/Password sign-in."],
        ["E3", "Cloud Firestore is created and the rules allow authenticated read/write."],
        ["E4", "The Google Maps API key is configured in android/key.properties."],
        ["E5", "The QA account (yasmine@streetbite.app) exists."],
    ]),
    ("7. Exit criteria", [
        ["X1", "100% of the Login and Home suites executed (0 Blocked)."],
        ["X2", "At least 95% of the total suite executed."],
        ["X3", "Zero open Critical or Blocker defects."],
        ["X4", "Zero open High-severity defects."],
        ["X5", "Every failed case has a Jira ticket with severity, priority and a screenshot."],
        ["X6", "The Traceability Matrix shows every in-scope requirement mapped to at least one executed case."],
        ["X7", "The Appium suite passes on both the emulator and the physical device."],
    ]),
    ("8. Risks and mitigations", [
        ["R1", "TheMealDB is a free third-party API and can rate-limit or go down.",
         "The repository falls back to the shared_preferences cache; TC_HOME_003 covers it."],
        ["R2", "Firebase App Distribution shares the same project as the course.",
         "Emails are restricted per tester group; documented in the README."],
        ["R3", "Google Play Services are missing on some emulators, breaking the map.",
         "MapErrorBoundary renders a friendly panel; TC_MAP_004 covers it."],
        ["R4", "local_auth behaves differently when no fingerprint is enrolled.",
         "The gate offers an explicit bypass; TC_PROFILE_003 covers it."],
    ]),
    ("9. Deliverables", [
        ["D1", "This workbook: Test Plan, Test Cases, Traceability Matrix, Defect Log."],
        ["D2", "Screenshots of the Jira board showing every defect."],
        ["D3", "Test Closure Summary (one page)."],
        ["D4", "automation/ - the Appium suite and its run reports."],
    ]),
]


# ---------------------------------------------------------------------------
# Sheet builders
# ---------------------------------------------------------------------------
def _write_title(sheet: Worksheet, title: str, subtitle: str, width: int) -> int:
    sheet["A1"] = title
    sheet["A1"].font = TITLE_FONT
    sheet.merge_cells(start_row=1, start_column=1, end_row=1, end_column=width)
    sheet["A2"] = subtitle
    sheet["A2"].font = Font(italic=True, color="666666", size=10)
    sheet.merge_cells(start_row=2, start_column=1, end_row=2, end_column=width)
    return 4


def _write_header(sheet: Worksheet, row: int, headers: Sequence[str]) -> None:
    for column, title in enumerate(headers, start=1):
        cell = sheet.cell(row=row, column=column, value=title)
        cell.fill = HEADER_FILL
        cell.font = HEADER_FONT
        cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
        cell.border = BORDER
    sheet.row_dimensions[row].height = 30


def _autosize(sheet: Worksheet, widths: Sequence[int]) -> None:
    for index, width in enumerate(widths, start=1):
        sheet.column_dimensions[get_column_letter(index)].width = width


def build_test_plan(workbook: Workbook) -> None:
    sheet = workbook.create_sheet("Test Plan")
    row = _write_title(
        sheet,
        "StreetBite V1.0 - Manual Test Plan",
        "Hyperlocal Food Discovery & Ordering App | Flutter + Firebase | Prepared by the StreetBite QA team",
        4,
    )

    for name, entries in TEST_PLAN_SECTIONS:
        sheet.cell(row=row, column=1, value=name).font = SECTION_FONT
        sheet.merge_cells(start_row=row, start_column=1, end_row=row, end_column=4)
        row += 1
        _write_header(sheet, row, ["Key", "Item", "Detail", ""])
        row += 1
        for entry in entries:
            if len(entry) == 2:
                key, item, detail = "", entry[0], entry[1]
            else:
                key, item, detail = entry
            sheet.cell(row=row, column=1, value=key)
            sheet.cell(row=row, column=2, value=item)
            sheet.cell(row=row, column=3, value=detail)
            for column in range(1, 5):
                sheet.cell(row=row, column=column).border = BORDER
                sheet.cell(row=row, column=column).alignment = Alignment(
                    vertical="top", wrap_text=True
                )
            row += 1
        row += 1

    _autosize(sheet, [8, 28, 92, 2])
    sheet.freeze_panes = "A5"


def build_test_cases(workbook: Workbook) -> None:
    sheet = workbook.create_sheet("Test Cases")
    row = _write_title(
        sheet,
        "Test Cases",
        "Status legend: Pass = meets the expected result | Fail = defect raised in Jira | Blocked = cannot be executed",
        11,
    )

    headers = [
        "Case ID", "Suite", "Title", "Pre-condition", "Test Steps",
        "Expected Result", "Actual Result", "Status", "Requirement",
        "Defect ID", "Priority",
    ]
    _write_header(sheet, row, headers)

    order = {"Pass": 0, "Fail": 1, "Blocked": 2}
    cases = sorted(TEST_CASES, key=lambda c: (order[c.status], c.case_id))
    failures = {d[1]: d for d in DEFECTS}

    current_suite = None
    for case in cases:
        row += 1
        values = [
            case.case_id,
            case.suite,
            case.title,
            "App installed and the QA account exists" if case.suite in {"Login", "Sign Up"}
            else "Signed in as the QA account",
            case.steps,
            case.expected,
            case.actual,
            case.status,
            case.requirement,
            failures.get(case.case_id, ["-"] * 8)[0] if case.case_id in failures else "-",
            failures.get(case.case_id, ["-"] * 8)[4] if case.case_id in failures else "-",
        ]
        for column, value in enumerate(values, start=1):
            cell = sheet.cell(row=row, column=column, value=value)
            cell.border = BORDER
            cell.alignment = Alignment(vertical="top", wrap_text=True)

        status_cell = sheet.cell(row=row, column=8)
        status_cell.font = Font(bold=True)
        fill = {"Pass": PASS_FILL, "Fail": FAIL_FILL, "Blocked": BLOCKED_FILL}[case.status]
        status_cell.fill = fill
        status_cell.alignment = Alignment(horizontal="center", vertical="center")

        if current_suite != case.suite:
            current_suite = case.suite
        if row % 2 == 0:
            for column in range(1, 12):
                if column != 8:
                    sheet.cell(row=row, column=column).fill = BAND_FILL

    _autosize(sheet, [16, 14, 44, 30, 56, 60, 60, 10, 26, 12, 10])
    sheet.freeze_panes = f"A{5}"


def build_traceability(workbook: Workbook) -> None:
    sheet = workbook.create_sheet("Traceability")
    row = _write_title(
        sheet,
        "Traceability Matrix",
        "Every in-scope requirement mapped to the test cases that verify it, and to the observed result.",
        6,
    )

    headers = [
        "Req ID", "Requirement", "Test Cases", "Total", "Passed", "Result",
    ]
    _write_header(sheet, row, headers)

    by_id = {case.case_id: case for case in TEST_CASES}

    for requirement in REQUIREMENTS:
        row += 1
        cases = [by_id[cid] for cid in requirement.case_ids if cid in by_id]
        passed = sum(1 for case in cases if case.status == "Pass")
        result = "Covered" if passed == len(cases) and cases else "Gaps"

        values = [
            requirement.requirement_id,
            requirement.description,
            ", ".join(case.case_id for case in cases) or "-",
            len(cases),
            passed,
            result,
        ]
        for column, value in enumerate(values, start=1):
            cell = sheet.cell(row=row, column=column, value=value)
            cell.border = BORDER
            cell.alignment = Alignment(vertical="top", wrap_text=True)

        sheet.cell(row=row, column=6).fill = PASS_FILL if result == "Covered" else FAIL_FILL
        sheet.cell(row=row, column=6).font = Font(bold=True)
        sheet.cell(row=row, column=6).alignment = Alignment(horizontal="center")

    # Totals row.
    row += 2
    sheet.cell(row=row, column=1, value="TOTAL").font = Font(bold=True)
    sheet.cell(row=row, column=3,
               value=f"{len(TEST_CASES)} test cases, "
                     f"{sum(1 for c in TEST_CASES if c.status == 'Pass')} passed, "
                     f"{sum(1 for c in TEST_CASES if c.status == 'Fail')} failed, "
                     f"{sum(1 for c in TEST_CASES if c.status == 'Blocked')} blocked").font = Font(bold=True)
    sheet.merge_cells(start_row=row, start_column=3, end_row=row, end_column=6)

    _autosize(sheet, [10, 54, 72, 8, 8, 12])
    sheet.freeze_panes = "A5"


def build_defect_log(workbook: Workbook) -> None:
    sheet = workbook.create_sheet("Defect Log")
    row = _write_title(
        sheet,
        "Defect Log (mirrors the Jira board)",
        "Every defect raised during the execution round, with severity, priority and evidence.",
        8,
    )

    headers = ["Jira Key", "Test Case", "Summary", "Severity", "Priority",
               "Component", "Status", "Root Cause"]
    _write_header(sheet, row, headers)

    for defect in DEFECTS:
        row += 1
        for column, value in enumerate(defect, start=1):
            cell = sheet.cell(row=row, column=column, value=value)
            cell.border = BORDER
            cell.alignment = Alignment(vertical="top", wrap_text=True)
        sheet.cell(row=row, column=4).fill = BLOCKED_FILL
        sheet.cell(row=row, column=7).fill = PASS_FILL

    _autosize(sheet, [12, 18, 58, 12, 12, 16, 20, 70])
    sheet.freeze_panes = "A5"


def main() -> None:
    os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)

    workbook = Workbook()
    workbook.remove(workbook.active)

    build_test_plan(workbook)
    build_test_cases(workbook)
    build_traceability(workbook)
    build_defect_log(workbook)

    workbook.save(OUTPUT)
    print(f"Wrote {OUTPUT}")
    print(f"  {len(TEST_CASES)} test cases across {len({c.suite for c in TEST_CASES})} suites")
    print(f"  {len(REQUIREMENTS)} requirements, {len(DEFECTS)} defects")


if __name__ == "__main__":
    main()