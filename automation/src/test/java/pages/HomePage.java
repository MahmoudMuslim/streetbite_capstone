package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.util.List;
import java.util.Map;

import io.appium.java_client.android.AndroidDriver;

/**
 * Page Object for the Home feed and the meals grid.
 *
 * <p>Shares {@link LoginPage#id(String)} with the Login page so the whole
 * suite uses one locator strategy: the semantic identifier published by
 * Flutter as Android {@code resource-id}.
 *
 * <p>Like {@link LoginPage} this uses composition rather than inheriting the
 * test base class, so the driver is always the live session's driver.
 */
public final class HomePage {

    private static final String MEALS_GRID = "meals_grid_view";
    private static final String HOT_OFFERS = "hot_offers_list";
    private static final String MEAL_CARD = "meal_card";
    private static final String ADD_TO_CART = "add_to_cart_button";
    private static final String CART_BUTTON = "open_cart_button";
    private static final String MAP_BUTTON = "open_map_button";

    private final AndroidDriver driver;
    private final WebDriverWait wait;

    public HomePage(AndroidDriver driver, WebDriverWait wait) {
        this.driver = driver;
        this.wait = wait;
    }

    // =======================================================================
    // Assertions
    // =======================================================================

    /**
     * {@code true} once the Home feed has rendered.
     *
     * <p>Accepts either the Hot Offers strip or a meal card as proof of a live
     * feed. The meals grid sits below the fold on a phone, and a
     * {@code SliverGrid} cannot carry a semantic identifier directly (its Dart
     * {@code ValueKey} is invisible to UiAutomator2), so the realised meal cards
     * are the reliable signal that the grid is on screen.
     */
    public boolean isFeedLoaded() {
        return !driver.findElements(LoginPage.id(HOT_OFFERS)).isEmpty()
                || visibleMealCards() > 0
                || !driver.findElements(LoginPage.id(MEALS_GRID)).isEmpty();
    }

    /** Number of meal cards currently realised (i.e. scrolled into view). */
    public int visibleMealCards() {
        return driver.findElements(LoginPage.id(MEAL_CARD)).size();
    }

    /** Number of Add-to-Cart buttons currently realised. */
    public int visibleAddToCartButtons() {
        return driver.findElements(LoginPage.id(ADD_TO_CART)).size();
    }

    /**
     * Scrolls until an Add-to-Cart button is realised.
     *
     * <p>Two things make this less trivial than it looks:
     * <ul>
     *   <li>The grid sits below the category chips and the Hot Offers strip, so
     *       a fresh Home screen has no card in the accessibility tree at all.</li>
     *   <li>The cards are tall (aspect ratio 0.78). A card enters the tree as
     *       soon as its <i>top</i> crosses the fold, while the Add-to-Cart
     *       button sits at the very bottom of the card - so waiting for a meal
     *       card is not enough, it must wait for the button itself.</li>
     * </ul>
     *
     * @return {@code true} once an Add-to-Cart button is on screen
     */
    public boolean scrollToMealsGrid() {
        for (int attempt = 0; attempt < 8; attempt++) {
            if (visibleAddToCartButtons() > 0) {
                return true;
            }
            scrollFeedDown();
        }
        return visibleAddToCartButtons() > 0;
    }

    /** {@code true} once at least one Hot Offer tile is on screen. */
    public boolean hasHotOffers() {
        return !driver.findElements(LoginPage.id(HOT_OFFERS)).isEmpty();
    }

    /** {@code true} when the Add-to-Cart SnackBar is visible. */
    public boolean hasAddedToCartSnackBar() {
        // The confirmation reads "<meal> added to your cart", so matching the
        // English suffix proves the *right* Bloc transition fired.
        return !driver.findElements(
                By.xpath("//*[contains(@content-desc,'added to your cart')]")).isEmpty();
    }

    // =======================================================================
    // Actions
    // =======================================================================

    /**
     * Scrolls the feed forward by roughly one screenful.
     *
     * <p>Uses Appium's {@code mobile: swipeGesture} rather than the legacy
     * {@code AndroidDriver.swipe} helper: the gesture is performed by
     * UiAutomator2 itself, so it behaves identically on an emulator and on a
     * physical device, and it survives the W3C-actions migration in Appium 3.
     *
     * <p>Note the direction: {@code up} drags the content upward, which is how
     * a user scrolls <i>down</i> the page towards later meals.
     */
    public HomePage scrollFeedDown() {
        swipe("up");
        return this;
    }

    /** Scrolls the feed back to the top. */
    public HomePage scrollFeedToTop() {
        for (int i = 0; i < 5; i++) {
            swipe("down");
        }
        return this;
    }

    /**
     * Raw UiAutomator2 swipe primitive.
     *
     * <p>Two non-obvious requirements of the current Appium 3 gesture API, both
     * of which fail loudly and unhelpfully:
     * <ul>
     *   <li>{@code direction} is required - the old {@code right}/{@code bottom}
     *       bounding-box form was removed.</li>
     *   <li>{@code left}/{@code top}/{@code width}/{@code height} must also be
     *       supplied, otherwise the driver answers
     *       {@code "The swipe area coordinates must be provided if element is
     *       not set"}.</li>
     * </ul>
     * The area below is a centred box covering half the viewport, so the swipe
     * never lands on the AppBar or the bottom navigation bar.
     */
    private void swipe(String direction) {
        Dimension viewport = viewportSize();
        int boxWidth = Math.max(1, viewport.getWidth() / 2);
        int boxHeight = Math.max(1, viewport.getHeight() / 2);

        driver.executeScript("mobile: swipeGesture", Map.of(
                "direction", direction,
                "left", (viewport.getWidth() - boxWidth) / 2,
                "top", (viewport.getHeight() - boxHeight) / 2,
                "width", boxWidth,
                "height", boxHeight,
                // Fraction of the swipe area, 0.0-1.0 - *not* a percentage.
                "percent", 0.5,
                // ms per step; slow enough to read as a drag.
                "speed", 1500));
    }

    /**
     * Taps the Add-to-Cart button of the first visible meal card.
     *
     * @return the semantic id of the tapped card (e.g.
     *         {@code add_to_cart_button_52771}), which the caller can log as
     *         evidence of <i>which</i> dish was added
     */
    public String addFirstVisibleMealToCart() {
        scrollToMealsGrid();

        WebElement button = wait.until(ExpectedConditions
                .presenceOfElementLocated(LoginPage.id(ADD_TO_CART)));
        String resourceId = button.getAttribute("resource-id");
        button.click();
        return resourceId == null ? "" : resourceId;
    }

    /** Opens the cart from the AppBar. */
    public HomePage openCart() {
        wait.until(ExpectedConditions.elementToBeClickable(LoginPage.id(CART_BUTTON))).click();
        return this;
    }

    /** Opens the Nearby Vendors map. */
    public HomePage openMap() {
        wait.until(ExpectedConditions.elementToBeClickable(LoginPage.id(MAP_BUTTON))).click();
        return this;
    }

    /** {@code true} once the cart screen is up. */
    public boolean isCartOpen() {
        return !driver.findElements(
                By.xpath("//*[contains(@content-desc,'Order summary')]")).isEmpty()
                || !driver.findElements(
                        By.xpath("//*[contains(@text,'Order summary')]")).isEmpty();
    }

    // =======================================================================
    // Internals
    // =======================================================================

    private Dimension viewportSize() {
        return driver.manage().window().getSize();
    }

    /** Exposed so a test can assert the cart badge incremented. */
    public List<WebElement> cartBadges() {
        return driver.findElements(LoginPage.id("cart_badge"));
    }
}