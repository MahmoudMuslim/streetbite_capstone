<div align="center">

# StreetBite — Graduation Capstone

**Hyperlocal Food Discovery & Ordering App**

<img src="streetbite_capstone/assets/icon/launcher_icon.png" width="112" alt="StreetBite logo" />

![Flutter](https://img.shields.io/badge/Flutter-3.47-027DFB?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%2B%20Firestore-FFCA28?logo=firebase&logoColor=black)
![Architecture](https://img.shields.io/badge/Clean%20Architecture-layered-00C16A)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)
![Languages](https://img.shields.io/badge/i18n-EN%20%C2%B7%20AR%20(RTL)-12141A)
![Analyzer](https://img.shields.io/badge/flutter%20analyze-0%20issues-brightgreen)

</div>

> *"They built that during a course."*

StreetBite combines a live Google Map of street-food vendors, a menu feed pulled
from a real API, ordering with saved favourites, fingerprint sign-in and a
biometric profile — in English and Arabic, light and dark.

```
streetbite-capstone/
├── streetbite_capstone/      # Flutter 3.47 · Clean Architecture · Firebase
├── automation/       # Appium 3 + Java + TestNG end-to-end suite (6/6 green)
├── manual_qa/        # Test plan, 51 cases, traceability matrix, closure PDF
├── docs/             # Bilingual code-documentation site (18 sections) + report deck
├── _audit/           # Tooling that generates the docs site from the source tree
└── figma/            # reference design assets (PNG exports + Dart notes)
```

---

## Contents

1. [Quick start](#quick-start)
2. [What's inside](#whats-inside)
3. [Tooling — how the artefacts are built](#tooling--how-the-artefacts-are-built)
4. [Design patterns used, and where](#design-patterns-used-and-where)
5. [Engineering notes](#engineering-notes)
6. [Cross-device & cross-account continuity](#cross-device--cross-account-continuity)
7. [Deliverables checklist](#deliverables-checklist)
8. [Licence](#licence)

---

## Quick start

```bash
# 1. App
cd streetbite_capstone
flutter pub get && flutter gen-l10n
flutter run

# 2. Tests
flutter analyze     # No issues found!
flutter test        # 99 tests, all green

# 3. Automation (needs Appium running in another terminal)
cd ../automation && mvn test

# 4. QA artefacts
python manual_qa/scripts/build_qa_workbook.py
```

> [!TIP]
> The app runs **without any Firebase configuration** — the repositories degrade to
> on-device data sources, so sign-up, login, the feed, favourites and orders all
> work on a fresh clone. See [Resilience and the offline fallback](streetbite_capstone/README.md#resilience-and-the-offline-fallback).

---

## What's inside

### `streetbite_capstone/` — the product

| Area | Highlights |
|---|---|
| **Screens** | Splash/onboarding, Login, Sign Up, Biometric sign-in, Home feed, Meal details, Cart & checkout, Order confirmation, Browse, Orders, Order details, Vendor map, Profile, Settings |
| **State** | `flutter_bloc` — a full Bloc for the cart (event-driven), Cubits for auth, meals, favourites, orders, theme and locale |
| **Architecture** | Clean Architecture: `presentation → domain ← data`, with a pure-Dart domain layer |
| **Data** | Dio (TheMealDB), `shared_preferences` cache, Firebase Auth, Cloud Firestore |
| **Device** | `google_maps_flutter`, `image_picker`, `local_auth`, `device_info_plus` |
| **i18n** | Full EN + ARB localisation, runtime toggle, RTL, zero hard-coded strings |
| **DI** | GetIt, with every repository bound to its **interface** |

→ **[Full app README](streetbite_capstone/README.md)**

### `automation/` — the automated regression

Six Appium tests across three classes, one class per feature, all driver setup
shared through `BaseTest`. Elements are located by the `Semantics(identifier:)`
tags the app deliberately exposes as Android `resource-id`, so a restyled card
never breaks a test. The suite is green: **6/6 passing** on a physical device
running Android 16.

→ **[Automation README](automation/README.md)**

### `manual_qa/` — the QA engagement

A test plan with scope, types, environments and exit criteria; **51 cases across
8 suites** with Expected/Actual/Status columns, of which **17 were executed and
passed on a physical device** and 34 remain recorded as Blocked; a traceability
matrix mapping all 10 requirements to those cases; a defect log mirroring the
Jira board (14 raised, 1 open — the Google Maps key); and a one-page closure
summary that honestly reads **NOT READY TO CLOSE**. All of it is also published
as a browsable multi-page **QA dashboard** (`manual_qa/dashboard/index.html`),
generated from the workbook with the same honest 17/51 figures.

→ **[QA README](manual_qa/README.md)** · **[QA dashboard](manual_qa/dashboard/index.html)**

### `docs/` — the documentation

An 18-section code and app reference built as a static bilingual site — one page
per section, English and Arabic side by side, with an EN / AR / Both toggle that
is remembered across every page. Open `docs/code-doc/index.html` in a browser;
there is no build step and no server required. Alongside it,
`docs/StreetBite_Capstone_Report_EN-AR.pptx` is the matching presentation deck.

→ **[Code documentation](docs/code-doc/index.html)**

---

## Tooling — how the artefacts are built

Nothing is maintained by hand twice. The reference tables and the QA workbook are
*generated* from the source tree, so they cannot quietly drift from the code.

| Folder | What it produces |
|---|---|
| `_audit/` | Builds the `docs/code-doc/` site. `gen15.py` / `gen16.py` turn a machine-extracted inventory of `lib/` into the every-file and every-class tables; `build_site.py` assembles the 18 pages plus a single-file export from `_audit/docparts/`; `qa_scan.py`, `graph.mjs`, `find.mjs` and `dupes.mjs` scan the result for untranslated text, dependency edges and duplicate symbols. |
| `manual_qa/scripts/` | `build_qa_workbook.py` writes the four-sheet plan / cases / traceability / defect workbook; `apply_execution_results.py` and `apply_defect_log.py` overwrite the *designed* suite with what was actually observed on-device; `build_closure_summary.py` renders the one-page closure PDF. |
| `streetbite_capstone/scripts/` | `check_unused_arb.py` and `prune_arb.py` keep `app_en.arb` / `app_ar.arb` free of dead keys and in lockstep across the two locales; `make_launcher_icons.py` re-renders the launcher icon from the in-app logo. |

Raw on-device captures — screenshots and `uiautomator` dumps used as execution
evidence — sit under `streetbite_capstone/_audit/` and `manual_qa/screenshots/`; both are
scratch output, not part of the shipped app. Re-running any generator above is
optional — the committed outputs are already current.

---

## Design patterns used, and where

| Pattern | Location |
|---|---|
| **Singleton** | `data/datasources/firestore_service.dart` — one Firestore gateway for the whole app |
| **Builder** | `data/models/user_model.dart` — each caller sets only the fields it actually knows |
| **Factory** | `data/repositories/meal_repository_impl.dart` — chooses the remote API or the local cache |
| **Factory (strategy)** | `domain/entities/payment.dart` — rebuilds a payment strategy from its persisted type |
| **Factory Method (DI)** | `injection.dart` — repositories registered against their abstract interfaces |
| **SOLID** | `domain/entities/payment.dart` — cash and card as separate classes behind one interface |
| **Repository** | `domain/repositories/*` + `data/repositories/*` |
| **Use case** | `domain/usecases/*` — one `call()` each, no logic in the Bloc |

Every one is explained in the code at the point of use, and listed in the
[app README](streetbite_capstone/README.md#design-patterns-and-where-each-one-is-used).

---

## Engineering notes

**Errors cannot escape unhandled.** No repository throws. `DioClient` converts
every `DioException`; repositories convert those into a `Failure` carrying an
ARB key; the UI resolves the key through `context.trKey()`. Because the result
is a sealed `Either<Failure, T>`, the compiler forces the caller to handle the
failure branch — the guarantee is structural, not aspirational.

**Zero hard-coded strings.** `app_en.arb` / `app_ar.arb` are the only source of
copy. `L10nX.trKey()` is an exhaustive `switch`, so adding a string without
wiring it is a compile-time error.

**A stored status is a snapshot, not a live claim.** The cart writes every order
as `active` and nothing ever rewrites it, because no client can observe the
kitchen. `OrderEntity.statusAt(now)` resolves that snapshot against the clock at
read time instead, which is why the Orders screen's Past section can fill.

**Tests found two real bugs.** `AppTextField` was rendering raw ARB keys instead
of localized sentences, and the locale toggle did not propagate to the screen.
Both are covered by regression tests now.

**One class, one file.** Every screen, Cubit/Bloc, use case, repository, model,
service and reusable widget has its own file — including the tiny ones — so
reuse is always a one-line import.

---

## Cross-device & cross-account continuity

User state that matters lives in Cloud Firestore, not on the handset — so the
same account picks up where it left off on any device, while one account can
never see another's.

<p align="center">
  <img src="manual_qa/screenshots/12-cross-device-sync.png" width="360" alt="Same StreetBite account on the physical handset and the emulator — favourites and orders persist through Firestore" />
</p>

**Continuity (same account, two devices).** Favourites, order history and the
profile (display name, photo) are written under the signed-in user's document,
so signing in on a second device — here a physical Xiaomi handset and an
emulator running the *same* release APK — restores them. Nothing device-local
has to be re-created; Firebase persists the session and Firestore persists the
data.

**Isolation (different accounts).** Every path is owner-scoped:

```
users/{uid}                      profile document (displayName, photoUrl)
users/{uid}/favourites/{mealId}  a saved meal
orders/{uid}/items/{orderId}     a placed order
```

`firestore.rules` allows `read, write` only when `request.auth.uid == uid`, with
no `list()`, no public read and no wildcard — and it **fails closed**, so a new
collection added without a rule cannot leak. Orders are deliberately *not* a
shared collection: the uid is part of the path, because a query for all orders
would need a rule that cannot distinguish rows. This is the fix behind the
owner-scoped rules raised as `SB-114`.

> [!NOTE]
> Continuity is verified by the cross-device capture above (both sides showing
> the same account's favourites/orders). Isolation is a property of the rules,
> not the client — an unauthenticated or mismatched-uid request is denied by
> Firestore before it reaches the app.

---

## Deliverables checklist

| Deliverable | Status |
|---|---|
| Public GitHub repo with the complete Flutter project | ✅ this repository |
| Professional `README.md` (app, architecture, setup, permissions) | ✅ [`streetbite_capstone/README.md`](streetbite_capstone/README.md) |
| Screenshots of every screen + App Distribution dashboard | ⚠️ partial — 6 screens captured; distribution dashboard pending |
| Strict Clean Architecture folder structure | ✅ `data` / `domain` / `presentation` |
| One file per screen, Cubit/Bloc, use case, repository, model, service, widget | ✅ 130+ Dart files |
| `fromJson` / `toJson` on every Firestore and API model | ✅ |
| Comments explaining every design-pattern application point | ✅ at each site |
| Every error caught and shown as a friendly message | ✅ sealed `Either` + `Failure` |
| Responsive via `MediaQuery` on ≥ 2 screen sizes | ✅ 360 dp and 800 dp verified |
| No duplicated code, no hard-coded strings | ✅ `flutter analyze` clean |
| `dart format .` applied, unused code removed | ✅ |
| Appium suite with a shared `BaseTest`, one feature per class | ✅ **6/6 passing** on a physical device (Android 16) — [`automation/README.md`](automation/README.md) |
| Test plan + suites + traceability matrix | ✅ [`manual_qa/`](manual_qa/) — 17/51 cases executed |
| Multi-page QA dashboard (generated from the workbook) | ✅ [`manual_qa/dashboard/`](manual_qa/dashboard/index.html) — honest 17/51, 0 broken links |
| Test closure summary (one page) | ✅ [`TestClosureSummary.pdf`](manual_qa/TestClosureSummary.pdf) — reads NOT READY TO CLOSE |
| Bilingual code documentation + capstone report deck | ✅ [`docs/code-doc/`](docs/code-doc/index.html) — 18 sections, EN + AR |
| Docs and QA artefacts generated from source, not hand-copied | ✅ `_audit/` + `*/scripts/` |

---

## Licence

Academic project — StreetBite Ventures capstone.