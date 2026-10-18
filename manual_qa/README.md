<div align="center">

# StreetBite — Manual QA Pack

Test plan, execution record and evidence for the **StreetBite** Flutter app,
build `1.0.0+3`.

<img src="../streetbite_capstone/assets/icon/launcher_icon.png" width="96" alt="StreetBite logo" />

![Build](https://img.shields.io/badge/build-1.0.0%2B3-00C16A)
![Cases](https://img.shields.io/badge/cases-51-12141A)
![Executed](https://img.shields.io/badge/executed%20%26%20passed-17%2F51-informational)
![Blocked](https://img.shields.io/badge/blocked-34-yellow)
![Defects](https://img.shields.io/badge/defects-14%20raised%2C%201%20open-critical)
![Automated](https://img.shields.io/badge/appium-6%2F6-brightgreen)

</div>

> [!WARNING]
> **Status: NOT READY TO CLOSE.** 17 of 51 cases have been executed and passed;
> 34 are still recorded as **Blocked**. See
> [`TestClosureSummary.pdf`](TestClosureSummary.pdf) for the one-page version.

## On this page

- [Contents](#contents)
- [Current numbers](#current-numbers)
- [Screenshots](#screenshots)
- [Regenerating the pack](#regenerating-the-pack)
- [Defects found during the execution rounds](#defects-found-during-the-execution-rounds)
- [Device used for the manual round](#device-used-for-the-manual-round)

---

## Contents

| Artefact | Path | Format |
|---|---|---|
| Test plan + cases + traceability | [`TestPlan_and_TestCases.xlsx`](TestPlan_and_TestCases.xlsx) | Excel |
| Test closure summary (one page) | [`TestClosureSummary.pdf`](TestClosureSummary.pdf) | PDF |
| Screenshots | [`screenshots/`](screenshots/) | PNG |
| Generators | [`scripts/`](scripts/) | Python |

The workbook contains the case list, the per-suite results, the execution
record and the **Defect Log**, which mirrors the Jira board one-to-one.

---

## Current numbers

| Metric | Value |
|---|---|
| Total cases | 51 |
| Executed | 17 |
| Passed | 17 |
| Failed | 0 |
| Blocked | 34 |
| Defects raised | 14 (`SB-106` … `SB-119`) |
| Defects open | 1 (`SB-119`, Google Maps key) |
| Automated regression | **6/6 passing** (`../automation/`) |

**Nothing is marked "passed" on the strength of having written it.** A case is
marked executed only if the release APK was installed on a real device and the
behaviour was observed. The 34 remaining cases are marked *Blocked* rather than
assumed green — an honest 17/51 is worth more than a fabricated 51/51.

---

## Screenshots

| File | Shows |
|---|---|
| `01_splash.png` | Splash screen during session restore |
| `02_login_error.png` | Login SnackBar on a rejected sign-in |
| `03_signup.png` | Create-account form (name / email / password / confirm) |
| `04_home_feed.png` | Home feed with the live meals grid |
| `05_home_arabic.png` | Arabic (RTL) rendering, Arabic-Indic digits |
| `06_cart_empty.png` | Empty cart state |
| `07_meal_details.png` | Meal details with favourite + Add-to-cart |
| `08_vendor_map_info.png` | Nearby Vendors map with a selected vendor info window |
| `09_profile_device.png` | Profile behind the gate, showing device information |
| `10_dark_mode.png` | Dark theme |
| `11_biometric_prompt.png` | Fingerprint gate on the Profile tab |
| `12-cross-device-sync.png` | Cross-device Firestore continuity — same account on the physical handset and the emulator |

Screenshots are numbered to match the case IDs so evidence and test case line
up without guesswork. All were captured on the physical handset below from the
release APK.

---

## Regenerating the pack

```powershell
cd manual_qa
python scripts\build_qa_workbook.py      # 1. base plan, suites, traceability
python scripts\apply_execution_results.py # 2. real 17/51 execution record
python scripts\apply_defect_log.py        # 3. the 8 observed defects
python scripts\build_closure_summary.py   # 4. the one-page PDF
```

Run them **in that order**. Each script edits the workbook produced by the
previous one, so skipping step 2 or 3 leaves the workbook showing the initial
plan rather than what was actually observed.

---

## Defects found during the execution rounds

All fourteen were invisible to `flutter analyze` and `flutter test`, which stayed
green throughout. That is the entire argument for both the device round and the
automated round.

| Key | Found by | Summary |
|---|---|---|
| `SB-106` | device run | `FirestoreService` resolved before registration → launch crash |
| `SB-107` | device run | `AuthRepositoryImpl` resolved by concrete type → start-up crash |
| `SB-108` | device run | QA account existed only in the local fallback store, so Firebase login always failed |
| `SB-109` | device run | Home AppBar had no EN/AR toggle, unlike every other screen |
| `SB-110` | Appium | QA-account seed left the app permanently signed in, making Login unreachable |
| `SB-111` | Appium | Login form silently pre-filled the demo email **and password** |
| `SB-112` | Appium | Meal cards merged into one accessibility node, hiding Add to Cart |
| `SB-113` | Appium | Page objects inherited a null driver; reported as a UI timeout |
| `SB-114` | device round | Firestore had no rules file → `PERMISSION_DENIED` on every read and write |
| `SB-115` | device round | The seed signed real users **out** of their own session on every launch |
| `SB-116` | device round | "Zombie session": authenticated UI with no backend session |
| `SB-117` | device round | Profile gate had no bypass → permanently unreachable |
| `SB-118` | device round | Profile re-queried Firestore on every rebuild |
| `SB-119` | device round | **OPEN** — Google Maps key rejected; map blank, could freeze the app |

### The one that is still open

`SB-119` is a **credential** problem, not a code problem. The wiring is now
correct: `MAPS_API_KEY` is read from `android/local.properties`, injected into
the manifest placeholder, and confirmed present in the built APK
(`com.google.android.geo.API_KEY`). The map SDK initialises and the vendor
info-window renders.

What remains is that the shared Google demo key is quota / billing limited, so
tile requests are refused even though the key is accepted:

```
Google Maps Android API: Error requesting API token. StatusCode=INVALID_ARGUMENT
Google Android Maps SDK: Authorization failure.
```

The app degrades gracefully (startup deadline → readable error view with
Retry) instead of hanging. A billing-enabled **Maps SDK for Android** key in
`android/local.properties` makes tiles draw; that credential is intentionally
not committed to the repository.

---

## Device used for the manual round

| | |
|---|---|
| Model | Xiaomi Redmi 24117RN76G |
| Android | 16 (API 36) |
| Resolution | 1080 × 2400 |
| Density | 480 dpi |
| Release APK | `streetbite_capstone/build/app/outputs/flutter-apk/app-release.apk` |

The automated suite ran against the same handset, which is what makes the
manual and automated results comparable rather than anecdotal.