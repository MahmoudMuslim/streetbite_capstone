package base;

import java.util.function.BooleanSupplier;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 * Reusable wait helpers shared by the test classes.
 *
 * <p>Fixed {@code Thread.sleep} calls are the single biggest source of flaky
 * Appium suites: too short and the suite fails on a slow CI box, too long and
 * it wastes minutes. Every wait in this project polls a condition instead.
 */
public final class Waits {

    private Waits() {
    }

    /**
     * Polls {@code condition} until it is true or the explicit timeout expires.
     *
     * @return {@code true} when the condition became true
     * @throws AssertionError when the timeout expires, with the supplied
     *                         message so the Jira ticket is self-explanatory
     */
    public static boolean until(WebDriverWait wait,
                                BooleanSupplier condition,
                                String failureMessage) {
        // Fail loudly and specifically if the harness is wired up wrongly.
        // Swallowing this as a "timeout" once cost a full debugging session:
        // the real fault was a null driver inside a page object, and the report
        // claimed the UI never appeared.
        if (wait == null) {
            throw new IllegalStateException(
                    "Waits.until was called before the Appium session existed "
                            + "(the wait is null). Did @BeforeClass run?");
        }
        if (condition == null) {
            throw new IllegalStateException("Waits.until was called with a null condition");
        }

        try {
            wait.until((WebDriver driver) -> condition.getAsBoolean());
            return true;
        } catch (TimeoutException e) {
            // Only a genuine expiry becomes the friendly assertion message.
            // Any other RuntimeException is a bug in the test and keeps its own
            // stack trace instead of masquerading as a UI timeout.
            throw new AssertionError(failureMessage, e);
        }
    }
}