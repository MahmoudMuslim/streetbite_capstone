package config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

/**
 * Single source of truth for every tunable value in the suite.
 *
 * <p>Design notes
 * --------------
 * <ul>
 *   <li>Values resolve in three tiers — system property, environment variable,
 *       {@code automation.properties} — so CI can override anything without
 *       touching the code.</li>
 *   <li>Reading them through {@link #get(String)} instead of scattering
 *       {@code System.getProperty} calls means a typo fails loudly in one
 *       place ({@link #require}) rather than producing an empty
 *       {@code capability}.</li>
 * </ul>
 */
public final class Config {

    private static final String PROPERTIES_FILE = "automation.properties";
    private static final Properties PROPERTIES = new Properties();

    private Config() {
    }

    static {
        load();
    }

    private static void load() {
        // 1. Bundled defaults, packaged with the jar.
        try (InputStream stream = Config.class
                .getClassLoader()
                .getResourceAsStream(PROPERTIES_FILE)) {
            if (stream != null) {
                PROPERTIES.load(stream);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Cannot read " + PROPERTIES_FILE, e);
        }

        // 2. Optional external override, next to the project root.
        Path external = Path.of(PROPERTIES_FILE);
        if (Files.exists(external)) {
            try (InputStream stream = Files.newInputStream(external)) {
                PROPERTIES.load(stream);
            } catch (IOException e) {
                throw new IllegalStateException("Cannot read " + external, e);
            }
        }
    }

    /** Reads a value, returning {@code fallback} when nothing is configured. */
    public static String get(String key, String fallback) {
        String value = System.getProperty(key);
        if (isBlank(value)) {
            value = System.getenv(key.toUpperCase().replace('.', '_'));
        }
        if (isBlank(value)) {
            value = PROPERTIES.getProperty(key);
        }
        return isBlank(value) ? fallback : value;
    }

    /** Reads a mandatory value or fails with an actionable message. */
    public static String require(String key) {
        String value = get(key, null);
        if (isBlank(value)) {
            throw new IllegalStateException(
                    "Missing required configuration '" + key + "'. Add it to "
                            + PROPERTIES_FILE + ", as -D" + key + "=..., or as the "
                            + key.toUpperCase().replace('.', '_') + " environment variable.");
        }
        return value;
    }

    public static boolean flag(String key, boolean fallback) {
        return Boolean.parseBoolean(get(key, Boolean.toString(fallback)));
    }

    public static int number(String key, int fallback) {
        try {
            return Integer.parseInt(get(key, Integer.toString(fallback)));
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    // ---- Application identity -------------------------------------------

    /** Android package name, matching `applicationId` in build.gradle.kts. */
    public static String appPackage() {
        return get("app.package", "com.example.streetbite_capstone");
    }

    /** Main activity, matching the `AndroidManifest.xml` intent filter. */
    public static String appActivity() {
        return get("app.activity", ".MainActivity");
    }

    /**
     * Property key for the APK path. BaseTest writes the resolved absolute
     * path back under this exact key so {@link #apkPath()} and the
     * {@code appium:app} capability can never disagree.
     */
    public static final String APK_PROPERTY = "app.apk";

    /** The APK installed on the device under test. */
    public static String apkPath() {
        return get("app.apk", "../streetbite_capstone/build/app/outputs/flutter-apk/app-release.apk");
    }

    // ---- Appium ---------------------------------------------------------

    /**
     * Appium server endpoint.
     *
     * <p>The {@code /wd/hub} base path matches the running server. Appium 3 can
     * also be started with a root base path, so this stays configurable via
     * {@code appium.server}.\r\n     */
    public static String serverUrl() {
        return get("appium.server", "http://127.0.0.1:4723/wd/hub");
    }

    /** `Android` for a device or AVD, or the serial of a real handset. */
    public static String platformName() {
        return get("appium.platform", "Android");
    }

    /** Serial of the target device; blank lets Appium pick the only one. */
    public static String deviceName() {
        return get("appium.device", "Android Emulator");
    }

    public static boolean resetAppState() {
        return flag("appium.reset", true);
    }

    public static boolean autoGrantPermissions() {
        return flag("appium.grantPermissions", true);
    }

    public static int implicitWaitSeconds() {
        return number("appium.implicitWait", 0);
    }

    public static int explicitWaitSeconds() {
        return number("appium.explicitWait", 15);
    }

    /**
     * Budget for a <b>cold start</b>, which is deliberately far larger than the
     * normal element wait.
     *
     * <p>After {@code pm clear} the app must initialise Firebase, re-create the
     * QA account and restore the session before it paints anything. On a cold
     * mid-range handset that easily exceeds the 15 s element wait, which used to
     * be reported as "the Login form never appeared" even though the app was
     * simply still starting.
     */
    public static int launchWaitSeconds() {
        return number("appium.launchWait", 60);
    }

    // ---- Test data ------------------------------------------------------

    /** Account seeded by the app on first launch. */
    public static String validEmail() {
        return get("user.email", "yasmine@streetbite.app");
    }

    public static String validPassword() {
        return get("user.password", "StreetBite123");
    }

    /** Guaranteed not to exist in Firebase. */
    public static String unknownEmail() {
        return get("user.unknownEmail", "ghost@streetbite.app");
    }

    public static String wrongPassword() {
        return get("user.wrongPassword", "WrongPass1");
    }

    // ---- Evidence -------------------------------------------------------

    public static Path screenshotDir() {
        return Path.of(get("evidence.dir", "target/screenshots"));
    }
}