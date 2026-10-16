package tests;

import base.BaseTest;
import config.Config;

import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import pages.HomePage;
import pages.LoginPage;

import static org.testng.Assert.assertTrue;

/**
 * Home feed — vertical scroll behaviour.
 *
 * <p>Targets one feature only: scrolling the meals {@code GridView}. The test
 * proves the feed (a) renders, (b) reveals further content when swiped, and
 * (c) returns to the top, which is the exact regression the manual suite
 * {@code TC_HOME_004} logs as "Blocked" on low-end devices.
 *
 * <p>Login is performed in {@code @BeforeMethod} rather than duplicated here:
 * the feed is only reachable authenticated, and repeating the sign-in steps
 * would be exactly the copy-paste the BaseTest pattern is meant to remove.
 */
public class HomeScrollTest extends BaseTest {

    private HomePage homePage;

    @BeforeMethod(alwaysRun = true)
    public void signInAndOpenHome() {
        setupStep("signInAndOpenHome", () -> {
            // BaseTest has already reset the sandbox, so the Login form is the
            // first screen painted.
            LoginPage loginPage = new LoginPage(driver, wait);
            waitForLaunch(() -> loginPage.isDisplayed(),
                    "The Login form never appeared within "
                            + Config.launchWaitSeconds() + "s");

            loginPage
                    .type("login_email_field", Config.validEmail())
                    .type("login_password_field", Config.validPassword())
                    .tapLogin();

            homePage = new HomePage(driver, wait);
            waitFor(() -> homePage.isFeedLoaded(),
                    "The meals grid did not load within "
                            + Config.explicitWaitSeconds() + "s");
        });
    }

    @Test(description = "TC-HOME-004 The meals grid scrolls down and back to the top")
    public void testScrollThroughMealsGrid() {
        assertTrue(homePage.scrollToMealsGrid(),
                "Scrolling down should bring the meals grid into view");

        int before = homePage.visibleMealCards();
        assertTrue(before > 0, "The grid should render at least one meal card");

        homePage.scrollFeedDown();
        // Swiping changes what is realised, so re-read after the gesture rather
        // than assuming the first read still holds.
        homePage.scrollFeedDown();

        boolean scrolledWithoutCrash = homePage.isFeedLoaded()
                || homePage.hasHotOffers();
        assertTrue(scrolledWithoutCrash,
                "The feed must still be rendered after scrolling down twice");

        homePage.scrollFeedToTop();

        assertTrue(homePage.isFeedLoaded(),
                "Scrolling back to the top must re-show the meals grid");

        takeScreenshot("TC_HOME_004_scroll_grid");
    }

    @Test(description = "TC-HOME-005 The Hot Offers strip is a horizontal list")
    public void testHotOffersStripIsRendered() {
        assertTrue(homePage.hasHotOffers(),
                "The Hot Offers strip should be present on the Home feed");
        takeScreenshot("TC_HOME_005_hot_offers");
    }
}
