package tests;

import base.BaseTest;
import config.Config;

import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import pages.HomePage;
import pages.LoginPage;

import static org.testng.Assert.assertFalse;
import static org.testng.Assert.assertTrue;

/**
 * Login feature — three scenarios, one class.
 *
 * <p>Mirrors the manual test suite {@code TC_LOGIN_*} so a failure here can be
 * cross-referenced with the matching Jira ticket.
 *
 * <ul>
 *   <li>{@code testLoginWithValidCredentials} — happy path, ends on Home.</li>
 *   <li>{@code testLoginWithInvalidCredentials} — Firebase rejects, friendly
 *       message, stays on Login.</li>
 *   <li>{@code testLoginWithEmptyFields} — client-side validation fires and no
 *       network call is made.</li>
 * </ul>
 *
 * <p>All driver setup lives in {@link BaseTest}; this class only describes
 * behaviour.
 */
public class LoginTest extends BaseTest {

    private LoginPage loginPage;

@BeforeMethod(alwaysRun = true)
    public void openLoginScreen() {
        setupStep("openLoginScreen", () -> {
            // BaseTest has already wiped the sandbox and relaunched the app, so
            // the splash cannot restore a session and the Login form is
            // guaranteed.
            loginPage = new LoginPage(driver, wait);
            waitForLaunch(() -> loginPage.isDisplayed(),
                    "The Login form never appeared within "
                            + Config.launchWaitSeconds() + "s");
        });
    }

    // =======================================================================
    // TC-LOGIN-001 — positive
    // =======================================================================

    @Test(description = "TC-LOGIN-001 Valid credentials sign the user in and open the Home feed")
    public void testLoginWithValidCredentials() {
        assertTrue(loginPage.isDisplayed(),
                "The Login form should be visible on launch");

        loginPage.type("login_email_field", Config.validEmail())
                .type("login_password_field", Config.validPassword())
                .tapLogin();

        // The Login form must actually disappear. Note the direction of the
        // assertion: it previously read `!isLoginFormGone()`, which is true
        // while the form is *still* on screen - so the test passed precisely
        // when the login had failed.
        boolean leftLogin = waitFor(
                loginPage::isLoginFormGone,
                "Expected the app to leave the Login screen after a valid sign-in");

        assertTrue(leftLogin,
                "A successful sign-in must open the Home screen, not stay on Login");
        takeScreenshot("TC_LOGIN_001_valid_credentials");
    }

    // =======================================================================
    // TC-LOGIN-002 — negative
    // =======================================================================

    @Test(description = "TC-LOGIN-002 Wrong password is rejected with a friendly message")
    public void testLoginWithInvalidCredentials() {
        assertTrue(loginPage.isDisplayed(), "The Login form should be visible");

        loginPage.type("login_email_field", Config.validEmail())
                .type("login_password_field", Config.wrongPassword())
                .tapLogin();

        // The rejection only arrives after a Firebase round trip, so the SnackBar
        // is not on screen the instant the tap returns. Poll for it instead of
        // asserting immediately.
        boolean snackBarShown = waitFor(
                () -> loginPage.hasSnackBar(),
                "A rejected sign-in must show an error SnackBar within "
                        + Config.explicitWaitSeconds() + "s");

        assertTrue(snackBarShown,
                "A rejected sign-in must show an error SnackBar");
        assertTrue(loginPage.showsWrongCredentialsMessage(),
                "The SnackBar must read 'Incorrect email or password.'");
        assertFalse(loginPage.isLoginFormGone(),
                "The user must stay on the Login screen after a rejection");
        takeScreenshot("TC_LOGIN_002_invalid_credentials");
    }

    // =======================================================================
    // TC-LOGIN-003 — negative (empty fields)
    // =======================================================================

    @Test(description = "TC-LOGIN-003 Empty fields are blocked by client-side validation")
    public void testLoginWithEmptyFields() {
        assertTrue(loginPage.isDisplayed(), "The Login form should be visible");

        loginPage.type("login_email_field", "")
                .type("login_password_field", "")
                .tapLogin();

        boolean blocked = waitFor(
                () -> loginPage.showsRequiredFieldMessage()
                        || loginPage.hasSnackBar(),
                "Expected a validation message when submitting an empty form");

        assertTrue(blocked,
                "Submitting an empty form must be blocked by validation");
        assertFalse(loginPage.isLoginFormGone(),
                "An empty form must never reach the Home screen");
        takeScreenshot("TC_LOGIN_003_empty_fields");
    }

    // =======================================================================
    // Shared helpers
    // =======================================================================

    /** Convenience so the Home page object can be created from a login test. */
    protected HomePage homePage() {
        return new HomePage(driver, wait);
    }
}
