# iOS Running Javascript Operations

This iOS app implements the "iOS Running Javascript Operations" exercise. It uses a `WKWebView` to execute JavaScript and a table view to display the operations' progress.

## Behavior

The app assumes that a script is available at [the URL](https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js) given on [the exercise page](https://join.jumboprivacy.com/20191218ios.html) and has the behavior documented on that page.

However, the app bubbles up any error that occurs in downloading or running the script or deserializing its messages.

The app does not rely on behavior that is documented in the script itself. For example, it does not assume that a `progress` message will never be received after a `completed` message for a given operation, that progress strictly increases, or that a message will never be received concerning an operation that was not started. 

As a result, the app cannot know when the final message has been received, and it never terminates the script or disposes of the web view.

## Testing

Unit tests are included for the model and view model (in the MVVM sense) layers. They particularly document and test the handling of the edge cases mentioned above.

They deliberately avoid testing networking, JavaScript execution, the script itself, and UIKit subclasses.

Deserialization of `Message` could be tested straightforwardly but is not.

## Notes

This implementation differs in some ways from production code I typically write:

* Inputs are deliberately hardcoded in the `AppDelegate` rather then supplied by the user.
* I typically use a reactive programming framework (e.g., ReactiveSwift or Combine) to represent values that change over time, bind views to values, sequence failable asynchronous operations (such as `WKWebView.evaluateJavaScript`), and dispatch to appropriate queues. In this case it seems better not to introduce a dependency.
* I typically use a React-like pattern (e.g., ReactiveLists or SwiftUI) to propagate data changes to the UI. However, the benefits of that approach weren't relevant in this scope.
