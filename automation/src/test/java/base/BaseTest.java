package base;

import config.Config;

import java.io.File;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;

import io.appium.java_client.android.AndroidDriver;

import org.testng.ITestResult;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeMethod;

/**
 * Shared driver setup for every test class.
 *
 * <p>Why a BaseTest at all
 * -----------------------
 * <ul>
 *   <li>Driver creation (capabilities, APK install, permissions) is identical
 *       for all suites; duplicating it per class is exactly the kind of
 *       copy-paste that drifts and then produces "works on my class" bugs.</li>
 *   <li>Quitting the session in {@code @AfterClass} (not {@code @AfterMethod})
 *       keeps the suite fast: one Appium session per class.</li>
 *   <li>Failure screenshots are captured centrally, so every Jira ticket gets
 *       evidence without a single test class remembering to take it.</li>
 * </ul>
 *
 * <p>Each concrete test class targets exactly one feature
 * ({@code LoginTest}, {@code HomeScrollTest}, {@code AddToCartTest}) and
 * contributes nothing but its own steps and assertions.
 */
public abstract class BaseTest {

    /** Shared driver, exposed to the page objects and the test classes. */
    protected AndroidDriver driver;

    /** Explicit waits only — implicit waits break Appium's element caching. */
    protected WebDriverWait wait;

    // =======================================================================
    // Session lifecycle
    // =======================================================================

    /**
     * Builds the driver, installs the release APK and applies the permission
     * grants StreetBite needs (camera for the profile photo, media for the
     * gallery, location for the vendor map).
     */
    @BeforeClass(alwaysRun = true)
    public void setUpDriver() {
        installApkIfPresent();

        driver = new AndroidDriver(
                createUrl(),
                androidCapabilities()
        );

        // Flutter renders into a single platform view, so every element is a
        // native Android view. An implicit wait only hides real timing bugs
        // here, so the suite uses explicit waits instead.
        driver.manage().timeouts().implicitlyWait(
                java.time.Duration.ofSeconds(Config.implicitWaitSeconds()));

        wait = new WebDriverWait(driver,
                java.time.Duration.ofSeconds(Config.explicitWaitSeconds()));
    }

/**
     * Puts the app back into a known state before every test method.
     *
     * <p>{@code noReset=false} only resets when the <i>session</i> is created,
     * i.e. once per class. Without this hook the methods of a class share one
     * live app: the first {@code testLoginWithValidCredentials} leaves the user
     * signed in, and the next method - which expects the Login form - fails
     * with a confusing "form never appeared".
     *
     * <p>StreetBite persists the Firebase session, so a plain restart is not
     * enough; the sandbox must be wiped. {@code pm clear} is issued through
     * {@code mobile: shell} (UiAutomator2 executes it on the device itself),
     * then the app is relaunched.
     */
    @BeforeMethod(alwaysRun = true)
    public void resetAppStateBeforeEachTest() {
        if (driver == null) {
            return;
        }

        clearAppData();
        driver.activateApp(Config.appPackage());
    }

    /**
     * Wipes the app sandbox so the next launch starts signed out.
     *
     * <p>Uses {@code mobile: clearApp} rather than {@code mobile: shell} with
     * {@code pm clear}: Appium 3 gates arbitrary shell access behind the
     * {@code adb_shell} "insecure" feature, so the shell route fails by default
     * and silently degrades to a mere process restart — which is useless here
     * because Firebase persists the session across process death.
     *
     * <p>Falls back to a terminate/relaunch if the command is unsupported, and
     * says so loudly, because a restart alone leaves the session in place.
     */
    private void clearAppData() {
        try {
            driver.executeScript("mobile: clearApp",
                    Map.of("appId", Config.appPackage()));
            return;
        } catch (Exception e) {
            System.err.println("[StreetBite] mobile: clearApp failed ("
                    + e.getMessage() + "); trying pm clear via the device shell.");
        }

        try {
            driver.executeScript("mobile: shell", Map.of(
                    "command", "pm",
                    "args", List.of("clear", Config.appPackage()),
                    "timeout", 30000));
            return;
        } catch (Exception e) {
            System.err.println("[StreetBite] `pm clear` is unavailable ("
                    + e.getMessage() + ").");
        }

        System.err.println(
                "[StreetBite] WARNING: app data could not be wiped. StreetBite "
                        + "persists its Firebase session, so any test that "
                        + "expects the Login screen will fail.");
        try {
            driver.terminateApp(Config.appPackage());
        } catch (Exception ignored) {
            // Already gone.
        }
    }

    /** Quits the session once, after the last test in the class. */
    @AfterClass(alwaysRun = true)
    public void tearDownDriver() {
        if (driver != null) {
            driver.quit();
            driver = null;
        }
    }

/**
     * Captures a screenshot whenever a test fails.
     *
     * <p>The file name carries the class and method so the evidence can be
     * dropped straight onto a Jira ticket without renaming.
     */
    @AfterMethod(alwaysRun = true)
    public void captureEvidenceOnFailure(ITestResult result) {
        if (result.getStatus() != ITestResult.FAILURE || driver == null) {
            return;
        }

        String name = result.getTestClass().getRealClass().getSimpleName()
                + "_" + result.getMethod().getMethodName();

        captureEvidence(name);
    }

    /**
     * Runs a {@code @BeforeMethod} body, capturing evidence if it fails.
     *
     * <p>TestNG does <b>not</b> invoke {@code @AfterMethod} when
     * {@code @BeforeMethod} throws, so a broken fixture otherwise leaves
     * nothing on disk — and a fixture failure is exactly the situation where
     * seeing the screen matters most.
     *
     * @param testName name used in the evidence file, normally the fixture's
     *                 own method name
     */
    protected void setupStep(String testName, Runnable body) {
        requireDriver();
        try {
            body.run();
        } catch (Throwable t) {
            captureEvidence(getClass().getSimpleName() + "_" + testName);
            throw t;
        }
    }

    /**
     * Fails fast with an actionable message when there is no live session.
     *
     * <p>TestNG still runs a fixture after {@code @BeforeClass} has failed, so
     * without this guard the suite reports a cascade of
     * {@code NullPointerException: ... this.driver is null} and buries the one
     * error that matters - usually "device not connected" or "could not start a
     * session".
     */
    protected void requireDriver() {
        if (driver == null) {
            throw new IllegalStateException(
                    "No Appium session: @BeforeClass failed to create one. "
                            + "Look at the setUpDriver failure above for the real "
                            + "cause (is the device connected and authorised?)");
        }
    }

    /** Writes both the PNG and the accessibility tree for {@code name}. */
    private void captureEvidence(String name) {
        takeScreenshot(name);
        dumpPageSource(name);
    }

    /**
     * Writes the accessibility tree next to the screenshot.
     *
     * <p>A PNG shows <em>what</em> the user saw; the page source shows
     * <em>what the driver could see</em>. When a locator fails those differ,
     * and the source file is what turns a 20-minute "why can't it find the
     * button" into a one-line answer.
     */
    private void dumpPageSource(String name) {
        try {
            Path dir = Config.screenshotDir();
            Files.createDirectories(dir);
            Files.writeString(dir.resolve(sanitize(name) + ".xml"),
                    driver.getPageSource());
        } catch (Exception e) {
            System.err.println("Could not write the page source: " + e.getMessage());
        }
    }

    // =======================================================================
    // Driver construction
    // =======================================================================

    private URL createUrl() {
        try {
            return new URL(Config.serverUrl());
        } catch (Exception e) {
            throw new IllegalStateException(
                    "Appium server is not reachable at " + Config.serverUrl()
                            + ". Start it with: appium", e);
        }
    }

    /**
     * Builds the UiAutomator2 capability set.
     *
     * <p>Kept in its own method (rather than inline in {@code setUpDriver}) so a
     * real-device run can override {@code appium.device} without changing the
     * code — the suite is identical on an emulator and on hardware.
     */
    protected org.openqa.selenium.remote.DesiredCapabilities androidCapabilities() {
        org.openqa.selenium.remote.DesiredCapabilities caps =
                new org.openqa.selenium.remote.DesiredCapabilities();

        caps.setCapability("platformName", Config.platformName());
        caps.setCapability("appium:automationName", "UiAutomator2");
        caps.setCapability("appium:deviceName", Config.deviceName());
        caps.setCapability("appium:app", Config.apkPath());
        caps.setCapability("appium:appPackage", Config.appPackage());
        caps.setCapability("appium:appActivity", Config.appActivity());

        // StreetBite persists the session, so every test starts signed out
        // regardless of what the previous one did.
        caps.setCapability("appium:noReset", !Config.resetAppState());
        caps.setCapability("appium:fullReset", false);
        caps.setCapability("appium:autoGrantPermissions", Config.autoGrantPermissions());
        caps.setCapability("appium:newCommandTimeout", 300);
        caps.setCapability("appium:skipDeviceInitialization", false);

        return caps;
    }

    /**
     * Resolves the APK to an <b>absolute</b> path and hands it to Appium.
     *
     * <p>This method exists because of a genuinely nasty trap: Appium resolves a
     * relative {@code appium:app} against the <i>Appium server's</i> working
     * directory, not the JVM's. A relative path that is perfectly valid for the
     * test run therefore produces
     * <pre>"The application at ... does not exist or is not accessible"</pre>
     * even though the file is right there. Always passing an absolute path
     * removes the whole class of problem.
     *
     * <p>Candidate roots are tried in order (current directory, then the parent
     * project directory) so the suite runs from either the repository root or
     * from {@code automation/}.
     */
    private void installApkIfPresent() {
        String configured = Config.apkPath();
        if (!configured.toLowerCase().endsWith(".apk")) {
            // Not an APK path (a pre-installed package name, for example).
            return;
        }

        Path resolved = resolveApk(configured);
        if (resolved == null) {
            throw new IllegalStateException(
                    "Could not find the APK to install.\n"
                            + "Looked for '" + configured + "' relative to:\n"
                            + "  - " + Path.of("").toAbsolutePath() + "\n"
                            + "  - " + Path.of("").toAbsolutePath().getParent() + "\n"
                            + "Fix it with -Dapp.apk=<absolute path> or by editing "
                            + "app.apk in src/test/resources/automation.properties.");
        }

// Must be the SAME key `Config.apkPath()` reads, otherwise the
        // capability silently falls back to the relative default.
        System.setProperty(Config.APK_PROPERTY, resolved.toString());
        System.out.println("[StreetBite] APK: " + resolved);
    }

    /** Returns the first existing match for {@code candidate}, or null. */
    private Path resolveApk(String candidate) {
        Path direct = Path.of(candidate);
        if (Files.isRegularFile(direct)) {
            return direct.toAbsolutePath().normalize();
        }

        Path cwd = Path.of("").toAbsolutePath();
        for (Path root : List.of(cwd, cwd.getParent())) {
            if (root == null) {
                continue;
            }
            Path attempt = root.resolve(candidate).normalize();
            if (Files.isRegularFile(attempt)) {
                return attempt;
            }
        }
        return null;
    }

    // =======================================================================
    // Evidence
    // =======================================================================

    /** Writes a PNG to {@code target/screenshots} and returns its path. */
    public String takeScreenshot(String name) {
        try {
            Path dir = Config.screenshotDir();
            Files.createDirectories(dir);
            File target = dir.resolve(sanitize(name) + ".png").toFile();

            byte[] png = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            Files.write(target.toPath(), png);
            return target.getAbsolutePath();
        } catch (Exception e) {
            // Evidence is best-effort: never fail a test because a screenshot
            // could not be written.
            return null;
        }
    }

    private String sanitize(String name) {
        return name.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    // =======================================================================
    // Shared helpers
    // =======================================================================

    /** Aborts the test immediately with a readable message. */
    protected void fail(String message) {
        throw new AssertionError(message);
    }

/**
     * Polls a condition instead of sleeping a fixed amount of time.
     *
     * @param message shown when the wait expires; pass a launch-specific
     *                message and use {@link #waitForLaunch} for cold starts
     */
    protected boolean waitFor(java.util.function.BooleanSupplier condition, String message) {
        return Waits.until(wait, condition, message);
    }

    /**
     * Same as {@link #waitFor} but with the generous {@link
     * Config#launchWaitSeconds()} budget, for the first screen after a cold
     * start.
     */
    protected boolean waitForLaunch(java.util.function.BooleanSupplier condition,
                                    String message) {
        WebDriverWait launchWait = new WebDriverWait(
                driver, java.time.Duration.ofSeconds(Config.launchWaitSeconds()));
        return Waits.until(launchWait, condition, message);
    }

protected AndroidDriver getDriver() {
        return driver;
    }
}