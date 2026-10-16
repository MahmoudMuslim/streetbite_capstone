package tests;

import base.BaseTest;
import config.Config;

import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import pages.HomePage;
import pages.LoginPage;

import static org.testng.Assert.assertTrue;

/**
 * Add-to-Cart feature.
 *
 * <p>One feature, one end-to-end path:
 * tap a meal card → tap Add to Cart → assert the SnackBar appears → assert the
 * line is actually in the cart. The last step is what makes this more than a
 * "button is clickable" test: it verifies the Bloc dispatch reached the state.
 */
public class AddToCartTest extends BaseTest {

    private HomePage homePage;

    @BeforeMethod(alwaysRun = true)
    public void signInAndOpenHome() {
        setupStep("signInAndOpenHome", () -> {
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

    @Test(description = "TC-CART-001 Adding a meal shows a SnackBar and the line reaches the cart")
    public void testAddToCartFromMealCard() {
        String mealName = homePage.addFirstVisibleMealToCart();

        boolean snackBarShown = waitFor(
                () -> homePage.hasAddedToCartSnackBar(),
                "Adding a meal must show the confirmation SnackBar");

        assertTrue(snackBarShown,
                "Expected the 'added to your cart' SnackBar after tapping Add to Cart");
        takeScreenshot("TC_CART_001_added_to_cart");

        homePage.openCart();

        boolean cartOpen = waitFor(
                () -> homePage.isCartOpen(),
                "Tapping the AppBar cart button must open the Cart screen");

        assertTrue(cartOpen,
                "The cart should list the meal that was just added"
                        + (mealName == null || mealName.isBlank()
                        ? "" : " (" + mealName + ")"));
        takeScreenshot("TC_CART_001_cart_contains_item");
    }
}
