package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.util.List;

import io.appium.java_client.android.AndroidDriver;

/**
 * Page Object for the Login screen.
 *
 * <h2>How Flutter elements are found</h2>
 * A Flutter app paints into a single view, and a Dart {@code ValueKey} is
 * <b>invisible</b> to UiAutomator2. What the platform does see is the
 * accessibility tree, which Flutter builds from:
 * <ul>
 *   <li>{@code Semantics(identifier: ...)} &rarr; published as {@code resource-id}</li>
 *   <li>{@code Semantics(label: ...)} and visible text &rarr; {@code content-desc}</li>
 * </ul>
 * StreetBite therefore tags its interactive nodes with
 * {@code Semantics(identifier:)} (see
 * {@code flutter_app/lib/presentation/widgets/semantic_id.dart}) and this page
 * object addresses them by {@code resource-id}. That is what makes the suite
 * survive a redesign: a card can move, restyle or be reordered without
 * breaking a test, and nothing here depends on a label that changes when the
 * app switches between English and Arabic.
 * <p>The page object is built by <b>composition</b>: the test hands it the live
 * {@link AndroidDriver}. It deliberately does not extend the test base class —
 * a page object constructed with only a wait would read its inherited
 * {@code driver} field from its <i>own</i> uninitialised instance and throw a
 * {@link NullPointerException} that the wait helper would then report as
 * "the UI never appeared". Composition makes the dependency explicit and
 * impossible to forget.
 */
public final class LoginPage {

    // ---- Identifiers mirrored from the Dart source -------------------------
    private static final String EMAIL_FIELD = "login_email_field";
    private static final String PASSWORD_FIELD = "login_password_field";
    private static final String LOGIN_BUTTON = "login_button";
    private static final String SIGN_UP_BUTTON = "go_to_sign_up_button";

    // ---- Visible copy, used only where no identifier exists --------------
    private static final String WRONG_CREDENTIALS_EN =
            "Incorrect email or password.";
    private static final String REQUIRED_FIELD_EN =
            "Please enter your email address.";
    private static final String SHORT_PASSWORD_EN =
            "Password must be at least 6 characters.";

    private final AndroidDriver driver;
    private final WebDriverWait wait;

    public LoginPage(AndroidDriver driver, WebDriverWait wait) {
        this.driver = driver;
        this.wait = wait;
    }

    // =======================================================================
    // Locator strategy
    // =======================================================================

    /**
     * Locates a node by its semantic identifier (Android {@code resource-id}),
     * falling back to {@code content-desc} for older builds.
     *
     * <p>The match is a prefix so that per-meal identifiers such as
     * {@code add_to_cart_button_52771} can be addressed with a base name.
     */
    public static By id(String identifier) {
        return By.xpath(
                "//*[starts-with(@resource-id, '" + identifier + "')"
                        + " or starts-with(@content-desc, '" + identifier + "')]");
    }

    // =======================================================================
    // Actions
    // =======================================================================

    /**
     * Types into a field identified by its semantic identifier.
     *
     * <p>Empty values are supported so a test can submit a blank form. Note that
     * the field is only cleared when it actually holds text, and a failed clear
     * is tolerated: {@code WebElement.clear()} maps to a long
     * select-all-and-delete on a native {@code EditText}, which Flutter's
     * {@code TextFormField} does not always honour. Since StreetBite's Login
     * screen starts empty, skipping the clear is both safer and correct.
     */
    public LoginPage type(String fieldId, String value) {
        WebElement wrapper = wait.until(
                ExpectedConditions.presenceOfElementLocated(id(fieldId)));

        // `SemanticId` publishes the identifier on a wrapper node, and that
        // wrapper is a plain `android.view.View` - not an input. Only the
        // `EditText` underneath it takes focus and key events, so addressing the
        // wrapper made every keystroke vanish into a non-editable view.
        WebElement field = resolveEditable(wrapper);

        if (!field.getText().isEmpty()) {
            clearQuietly(field);
        }

        if (value.isEmpty()) {
            return this;
        }

        // Focus first: a Flutter `TextFormField` only receives synthesized key
        // events once it owns the input focus.
        try {
            field.click();
        } catch (Exception e) {
            System.err.println("[StreetBite] could not focus "
                    + fieldId + " (" + e.getMessage() + "); typing anyway.");
        }

        field.sendKeys(value);
        return this;
    }

    /**
     * Descends from the identifier's wrapper node to the real editable input,
     * falling back to the node itself when it is already an {@code EditText}.
     */
    private WebElement resolveEditable(WebElement wrapper) {
        try {
            List<WebElement> edits = wrapper.findElements(
                    By.xpath(".//android.widget.EditText"));
            if (!edits.isEmpty()) {
                return edits.get(0);
            }
            if ("android.widget.EditText".equals(wrapper.getTagName())) {
                return wrapper;
            }
        } catch (Exception e) {
            System.err.println("[StreetBite] could not resolve the editable node: "
                    + e.getMessage());
        }
        return wrapper;
    }

    /** Best-effort clear that never masks the real test failure. */
    private void clearQuietly(WebElement field) {
        try {
            field.clear();
        } catch (Exception e) {
            System.err.println(
                    "[StreetBite] clear() on " + field.getAttribute("resource-id")
                            + " failed (" + e.getMessage() + "); typing over it instead.");
        }
    }

    /** Taps the primary action button. */
    public LoginPage tapLogin() {
        hideKeyboard();
        wait.until(ExpectedConditions.elementToBeClickable(id(LOGIN_BUTTON))).click();
        return this;
    }

    public LoginPage tapSignUp() {
        hideKeyboard();
        wait.until(ExpectedConditions.elementToBeClickable(id(SIGN_UP_BUTTON))).click();
        return this;
    }

    /**
     * Dismisses the soft keyboard.
     *
     * <p>Typing raises the keyboard, which on a phone covers the lower half of
     * the form - including the Log In button. Appium clicks an element at its
     * centre, so without this the tap lands on the keyboard and the form simply
     * never submits, which reads exactly like a broken app.
     */
    private void hideKeyboard() {
        try {
            if (driver.isKeyboardShown()) {
                driver.hideKeyboard();
            }
        } catch (Exception e) {
            // Not fatal: on an emulator with a hardware keyboard this is normal.
        }
    }

    // =======================================================================
    // Assertions
    // =======================================================================

    /** {@code true} once the Login form is on screen. */
    public boolean isDisplayed() {
        return !driver.findElements(id(EMAIL_FIELD)).isEmpty()
                && !driver.findElements(id(PASSWORD_FIELD)).isEmpty()
                && !driver.findElements(id(LOGIN_BUTTON)).isEmpty();
    }

    /** {@code true} once the app has left the Login screen. */
    public boolean isLoginFormGone() {
        return driver.findElements(id(LOGIN_BUTTON)).isEmpty();
    }

    /** {@code true} when a field-level validation message is painted. */
    public boolean hasFieldError(String message) {
        return !driver.findElements(By.xpath("//*[@text='" + message + "']")).isEmpty()
                || !driver.findElements(
                        By.xpath("//*[contains(@content-desc,'" + message + "')]")).isEmpty();
    }

    /** {@code true} when any SnackBar is on screen. */
    public boolean hasSnackBar() {
        // Flutter renders SnackBars inside the same view, so the message text
        // itself is the only reliable signal.
        return !driver.findElements(By.xpath(
                "//*[contains(@content-desc,'Incorrect') or contains(@text,'Incorrect')]"))
                .isEmpty();
    }

    /** {@code true} when the SnackBar shows the expected message. */
    public boolean snackBarContains(String message) {
        return !driver.findElements(
                By.xpath("//*[contains(@content-desc,'" + message + "')]")).isEmpty()
                || !driver.findElements(By.xpath("//*[@text='" + message + "']")).isEmpty();
    }

    public boolean showsWrongCredentialsMessage() {
        return snackBarContains(WRONG_CREDENTIALS_EN);
    }

    public boolean showsRequiredFieldMessage() {
        return hasFieldError(REQUIRED_FIELD_EN);
    }

    public boolean showsShortPasswordMessage() {
        return hasFieldError(SHORT_PASSWORD_EN);
    }
}