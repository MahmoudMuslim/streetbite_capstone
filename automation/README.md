# StreetBite — Appium + Java Automation Suite

End-to-end automation for the **StreetBite** Flutter app, targeting the release
APK distributed through Firebase App Distribution.

Built with **Appium 3 · Java 17 · TestNG · UiAutomator2**.

---

## Contents

```
automation/
├── pom.xml
├── testng.xml
├── .gitignore
├── README.md
└── src/test/
    ├── java/
    │   ├── base/
    │   │   ├── BaseTest.java     # shared driver setup, session lifecycle, evidence
    │   │   └── Waits.java        # condition polling helpers
    │   ├── config/
    │   │   └── Config.java       # system property -> env var -> file
    │   ├── pages/
    │   │   ├── LoginPage.java    # page object for the Login screen
    │   │   └── HomePage.java     # page object for the Home feed
    │   ├── tests/
    │   │   ├── LoginTest.java    # 3 login scenarios
    │   │   ├── HomeScrollTest.java # grid scroll + Hot Offers
    │   │   └── AddToCartTest.java  # card -> add to cart -> SnackBar
    │   └── utils/
    │       └── SuiteListener.java # flat report for Jira
    └── resources/
        └── automation.properties
```

**One test class per feature.** `LoginTest` knows nothing about the cart,
`AddToCartTest` knows nothing about scrolling; they share setup through
`BaseTest` and locators through page objects.

---

## Prerequisites

| Tool | Version | Check |
|---|---|---|
| JDK | 17+ | `java -version` |
| Maven | 3.9+ | `mvn -v` |
| Node.js | 18+ | `node -v` |
| Appium | 3.x | `appium -v` |
| Appium uiautomator2 driver | 8.x | `appium driver list --installed` |
| Android SDK + adb | 35+ | `adb version` |
| A device or AVD | Android 9+ | `adb devices` |

```bash
npm install -g appium
appium driver install uiautomator2
appium driver install uiautomator2   # idempotent; safe to re-run
```

---

## Configuration

All tunables live in `src/test/resources/automation.properties`, resolved in
this order (first match wins):

1. `-D<key>=<value>` — a Maven system property
2. `<KEY>` — the environment variable (upper-cased, dots → underscores)
3. `automation.properties`

| Key | Default | Meaning |
|---|---|---|
| `app.package` | `com.example.streetbite_capstone` | Android package under test |
| `app.activity` | `.MainActivity` | Launcher activity |
| `app.apk` | `../flutter_app/build/app/outputs/flutter-apk/app-release.apk` | APK to install |
| `appium.server` | `http://127.0.0.1:4723/wd/hub` | Appium endpoint (base path matters) |
| `appium.device` | `Android Emulator` | AVD name **or** a physical serial |
| `appium.reset` | `true` | Clear app data between classes |
| `appium.grantPermissions` | `true` | Auto-grant camera / media / location |
| `appium.explicitWait` | `15` | Seconds for every explicit wait |
| `appium.launchWait` | `60` | Budget for a cold start (Firebase init + seeding) |
| `user.email` | `yasmine@streetbite.app` | QA account |
| `user.password` | `StreetBite123` | QA password |
| `evidence.dir` | `target/screenshots` | Where failure PNGs land |

### Running on a physical device

```bash
adb devices                                   # e.g. R5CT30ABCDE
mvn test -Dappium.device=R5CT30ABCDE
```

Nothing in the code changes — the same suite runs on hardware and on an
emulator, which is exactly what the manual QA report compares.

---

## Running the suite

**Terminal 1 — start Appium**

```bash
appium --base-path /wd/hub
# Appium prints: "Appium REST http://127.0.0.1:4723/wd/hub is listening"
```

The base path matters: with the default (`/`) the suite must be pointed at
`http://127.0.0.1:4723`, and with `--base-path /wd/hub` it must be pointed at
`http://127.0.0.1:4723/wd/hub`. Mismatching them fails at session creation.

**Terminal 2 — build the app and run the tests**

```bash
# 1. Build the APK the suite installs
cd ../flutter_app
flutter build apk --release

# 2. Run the automation suite
cd ../automation
mvn clean test
```

Useful variants:

```bash
mvn test -Dtest=LoginTest                        # a single class
mvn test -Dtest=LoginTest#testLoginWithEmptyFields  # a single method
mvn test -Dappium.device=R5CT30ABCDE             # a physical handset
mvn test -Dappium.explicitWait=30                # a slow device
```

### Output

| Artefact | Path |
|---|---|
| Surefire HTML report | `automation/target/surefire-reports/` |
| Flat suite report | `automation/target/suite-report.txt` |
| Screenshots | `automation/target/screenshots/<Case>.png` |
| Failure accessibility tree | `automation/target/screenshots/<Class>_<method>.xml` |

```
PASS  | tests.LoginTest  | testLoginWithValidCredentials
FAIL  | tests.LoginTest  | testLoginWithInvalidCredentials
PASS  | tests.AddToCartTest | testAddToCartFromMealCard
```

Two kinds of evidence are written automatically:

- On any failure, `@AfterMethod` saves a **PNG plus the accessibility tree**.
  The PNG shows what the user saw; the XML shows what the driver could see. When
  a locator fails those two differ, and the XML is what makes the difference
  obvious.
- On a `@BeforeMethod` failure, `setupStep` saves the same pair — TestNG does
  *not* run `@AfterMethod` when a fixture throws, which otherwise leaves a
  broken fixture with no evidence at all.

---

## The tests

### `LoginTest` — the login feature

| Method | Case | Asserts |
|---|---|---|
| `testLoginWithValidCredentials` | TC-LOGIN-001 | The Login form renders, valid credentials are accepted, and the app leaves the Login screen |
| `testLoginWithInvalidCredentials` | TC-LOGIN-002 | A SnackBar appears **with the Firebase message**, and the user stays on Login |
| `testLoginWithEmptyFields` | TC-LOGIN-003 | Validation blocks submission; no navigation occurs |

### `HomeScrollTest` — the home feed

| Method | Case | Asserts |
|---|---|---|
| `testScrollThroughMealsGrid` | TC-HOME-004 | Cards are rendered, two swipes keep the feed alive, and scrolling back re-shows the grid |
| `testHotOffersStripIsRendered` | TC-HOME-005 | The five-item Hot Offers strip is present |

### `AddToCartTest` — the add-to-cart flow

| Method | Case | Asserts |
|---|---|---|
| `testAddToCartFromMealCard` | TC-CART-001 | Tapping **+** shows the SnackBar, and opening the cart shows the line — i.e. the Bloc dispatch reached the state |

---

## Design decisions worth knowing

### Elements are located by `Semantics(identifier:)`, not by coordinates

Flutter renders into a single canvas, so pixel coordinates are brittle and any
layout tweak breaks the suite. A Dart `ValueKey` is **invisible** to
UiAutomator2 — the accessibility tree is built from `Semantics`, and
`Semantics(identifier:)` is what Android publishes as `resource-id`.

StreetBite therefore tags its interactive nodes through
`flutter_app/lib/presentation/widgets/semantic_id.dart`:

```dart
SemanticId(id: 'login_email_field', label: 'Email', child: TextFormField(...))
```

and the page object addresses them by that identifier:

```java
static By id(String identifier) {
    return By.xpath(
        "//*[starts-with(@resource-id, '" + identifier + "')"
                + " or starts-with(@content-desc, '" + identifier + "')]");
}
```

The match is a **prefix** so that per-meal identifiers such as
`add_to_cart_button_52771` can be addressed with the base name. A designer can
restyle a card without breaking a single test.

Two consequences worth knowing, both learned the hard way:

- **The identifier sits on a wrapper node.** `SemanticId` publishes itself as an
  `android.view.View`; the `android.widget.EditText` that accepts keystrokes is
  its child. `LoginPage.type()` therefore descends to the `EditText` — sending
  keys to the wrapper silently does nothing.
- **Flutter folds merged subtrees.** A meal card used to surface as one blob of
  text with the Add-to-Cart button (and its `resource-id`) missing entirely.
  `SemanticId` sets `explicitChildNodes: true` so each child keeps its own node.

### Verified run

```
StreetBite Appium suite - 2026-10-16 16:28:19 on 4lucqgjfssinxg95
PASS  | tests.LoginTest  | testLoginWithEmptyFields
PASS  | tests.LoginTest  | testLoginWithInvalidCredentials
PASS  | tests.LoginTest  | testLoginWithValidCredentials
PASS  | tests.HomeScrollTest | testHotOffersStripIsRendered
PASS  | tests.HomeScrollTest | testScrollThroughMealsGrid
PASS  | tests.AddToCartTest | testAddToCartFromMealCard

Tests run: 6, Failures: 0, Errors: 0, Skipped: 0 — BUILD SUCCESS
```

Physical device `24117RN76G`, Android 16, 1080×2400. `suite-report.txt` is
truncated at the start of each run, so it only ever describes the latest run.

### Test isolation wipes app data, not just the process

StreetBite persists its Firebase session, so restarting the process is not
enough to reach the Login screen again. `BaseTest` issues
`mobile: clearApp` before every test method.

`mobile: shell` (`pm clear`) would do the same job but Appium 3 gates arbitrary
shell access behind the `adb_shell` "insecure" feature, so it fails by default
and silently degrades to a plain restart — which is exactly the bug this
replaces. `mobile: clearApp` needs no special flags.

### No `Thread.sleep`

Every wait polls a condition through `WebDriverWait` (see `Waits.until`).
Implicit waits are deliberately `0`: with Appium they mask real timing bugs and
interact badly with element caching.

### Session reuse

`BaseTest` builds the driver in `@BeforeClass` and quits it in `@AfterClass` —
one Appium session per class, not per test. App data is still wiped between
test *methods* (`@BeforeMethod`), so each method starts signed out.

### No duplicated driver code

`BaseTest` owns capabilities, APK resolution, permission grants, teardown and
evidence. `LoginTest`, `HomeScrollTest` and `AddToCartTest` contain nothing but
their own steps and assertions — which is the "no repeated driver setup"
requirement expressed as a structure rather than a promise.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| `Appium server is not reachable` | Start Appium in another terminal; check `appium.server` |
| `NoSuchDriverError` | `appium driver install uiautomator2` |
| `Could not find a connected Android device` | `adb devices`; set `-Dappium.device=<serial>` |
| App launches then closes | Usually a Firebase/config crash — run `adb logcat -s flutter` |
| All elements "not found" | The app is likely still on the splash. Cold starts use `-Dappium.launchWait`; element waits use `-Dappium.explicitWait` |
| Test passes on the emulator, fails on hardware | `tapLogin` already dismisses the keyboard; if it still fails, raise `-Dappium.explicitWait` |
| `SessionNotCreatedException: app not installed` | Check `app.apk` path, or pre-install the APK by hand and set `appium.reset=false` |

---

## Licence

Academic project — StreetBite Ventures capstone.