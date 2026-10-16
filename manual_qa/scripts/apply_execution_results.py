"""Rewrites the Test Cases sheet so Status / Actual Result reflect reality.

The 51-case catalogue is a *designed* suite. This script marks which cases were
actually executed on a device and records the real observed result, so the
workbook never claims coverage that did not happen.

Execution evidence (see manual_qa/screenshots/):
  * RedMI Note 13 (24117RN76G), Android 16, 1080x2400 @ 450 dpi
  * Release APK 1.0.0+2, Firebase project studio-3887960052-c09f5
"""

from __future__ import annotations

import os

from openpyxl import load_workbook
from openpyxl.styles import Alignment, Font, PatternFill

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
WORKBOOK = os.path.join(ROOT, "manual_qa", "TestPlan_and_TestCases.xlsx")

PASS_FILL = PatternFill("solid", fgColor="D6F5E3")
FAIL_FILL = PatternFill("solid", fgColor="FBDCDC")
BLOCKED_FILL = PatternFill("solid", fgColor="FFF2CC")

# ---------------------------------------------------------------------------
# Ground truth. Every entry here was observed on the device listed above.
#
#   executed=True  -> the case was run and its observed result is recorded
#   executed=False -> the case is designed but NOT yet executed; status
#                    "Blocked" with a note, never a silent "Pass".
# ---------------------------------------------------------------------------
EXECUTED: dict[str, tuple[str, str]] = {
    # case_id: (observed result, status)
    "TC_LOGIN_001": (
        "Logged in with the seeded Firebase account; the Home feed rendered in ~2s "
        "with the banner, category chips, Hot Offers strip and meals grid.",
        "Pass",
    ),
    "TC_LOGIN_002": (
        "Wrong password produced the SnackBar 'Incorrect email or password.' and the "
        "Login screen was retained. (Screenshot 02_login_error.png)",
        "Pass",
    ),
    "TC_LOGIN_003": (
        "Clearing both fields and submitting is blocked by client-side validation; "
        "no Firebase request is made.",
        "Pass",
    ),
    "TC_LOGIN_004": (
        "A malformed address is rejected by the e-mail validator before submission.",
        "Pass",
    ),
    "TC_LOGIN_005": (
        "A 3-character password is rejected with the localized minimum-length message.",
        "Pass",
    ),
    "TC_LOGIN_006": (
        "After a successful sign-in, force-stop + relaunch restored the session and "
        "opened the Home feed directly.",
        "Pass",
    ),
    "TC_LOGIN_007": (
        "An unknown e-mail is rejected with the wrong-credential message.",
        "Pass",
    ),
    "TC_LOGIN_008": (
        "Not executed - airplane-mode round pending.",
        "Blocked",
    ),
    "TC_HOME_001": (
        "Home rendered the live feed from TheMealDB: 5-item banner PageView with page "
        "indicators, 7 category chips, Hot Offers strip and the 2-column meals grid. "
        "(Screenshot 04_home_feed.png)",
        "Pass",
    ),
    "TC_HOME_002": (
        "A CircularProgressIndicator is shown while the feed request is in flight.",
        "Pass",
    ),
    "TC_HOME_003": (
        "Not executed - cache round pending.",
        "Blocked",
    ),
    "TC_HOME_004": (
        "The CustomScrollView scrolls and later cards are realised without a crash.",
        "Pass",
    ),
    "TC_HOME_005": (
        "The Hot Offers strip is present and horizontally scrollable, with discount "
        "ribbons on each tile.",
        "Pass",
    ),
    "TC_HOME_007": (
        "Dark mode applied to the AppBar, search field, chips, cards and the bottom "
        "navigation; the toggle icon flipped to a sun. (Screenshot 10_dark_mode.png)",
        "Pass",
    ),
    "TC_HOME_008": (
        "The EN/AR toggle switched every string to Arabic and the layout mirrored to "
        "RTL, including Arabic-Indic digits in the address. "
        "(Screenshot 05_home_arabic.png)",
        "Pass",
    ),
    "TC_MEAL_001": (
        "Tapping a meal card opened the details screen with the image, name, category, "
        "origin, price and full instructions from TheMealDB.",
        "Pass",
    ),
    "TC_CART_008": (
        "Opening the cart with no items shows the empty state with a 'Browse menu' CTA. "
        "(Screenshot 06_cart_empty.png)",
        "Pass",
    ),
    "TC_GEN_003": (
        "Home and Login verified in both languages with no English left on screen.",
        "Pass",
    ),
    "TC_GEN_004": (
        "Home feed and Login verified in dark mode; contrast acceptable.",
        "Pass",
    ),
}

NOT_EXECUTED_NOTE = "Not executed - case is designed and ready but this execution round did not reach it."


def main() -> None:
    workbook = load_workbook(WORKBOOK)
    sheet = workbook["Test Cases"]

    header_row = 4
    headers = {cell.value: cell.column for cell in sheet[header_row] if cell.value}
    col_id = headers["Case ID"]
    col_actual = headers["Actual Result"]
    col_status = headers["Status"]
    col_priority = headers["Priority"]

    counts = {"Pass": 0, "Fail": 0, "Blocked": 0}

    for row in range(header_row + 1, sheet.max_row + 1):
        case_id = sheet.cell(row=row, column=col_id).value
        if not case_id:
            continue

        observed, status = EXECUTED.get(case_id, (NOT_EXECUTED_NOTE, "Blocked"))

        actual = sheet.cell(row=row, column=col_actual, value=observed)
        actual.alignment = Alignment(vertical="top", wrap_text=True)

        status_cell = sheet.cell(row=row, column=col_status, value=status)
        status_cell.font = Font(bold=True)
        status_cell.fill = {
            "Pass": PASS_FILL,
            "Fail": FAIL_FILL,
            "Blocked": BLOCKED_FILL,
        }[status]
        status_cell.alignment = Alignment(horizontal="center", vertical="center")

        # Priority only applies to cases that actually ran.
        priority = sheet.cell(row=row, column=col_priority)
        priority.value = "P1" if status in {"Pass", "Fail"} else "-"

        counts[status] += 1

    workbook.save(WORKBOOK)

    total = sum(counts.values())
    print(f"{total} cases updated")
    for status, count in counts.items():
        print(f"  {status}: {count}")


if __name__ == "__main__":
    main()