//
//  OperationRunner.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/22/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import WebKit

/// This class executes a provided script, which is expected to behave like
/// `interview_bundle.js` script described in the documentation. It then calls
/// `startOperation(id)` for each of the provided operation IDs and begins
/// listening for script messages, which it parses using `Message`'s `Decodable`
/// conformance.
class OperationRunner {
    private var webView: WKWebView?
    
    /// Initialize a runner. In order for the runner to continue executing the
    /// script and relaying messages, it must be retained.
    ///
    /// - Parameters:
    ///   - runnerScript: A JavaScript script the implements the behavior
    ///    specified in the documentation (`interview_bundle.js`).
    ///   - operationIDs: IDs for which to start operations.
    ///   - handleEvent: Function to be called each time a message is received
    ///    and successfully parse and each time an error is encountered. This
    ///    may be called any number of times. An error does not necessarily
    ///    indicate that execution or messages will stop.
    ///   - event: A message or an error.
    init(
        runnerScript: String,
        operationIDs: [Operation.ID],
        handleEvent: @escaping (_ event: Result<Message, Error>) -> ())
    {
        let handleScriptError = { [weak self] (error: Error) in
            handleEvent(.failure(error))
            
            // An error in the script means no operations will be started or
            // messages received, so we can discard the web view.
            self?.webView = nil
        }
        
        let webView = WKWebView()
        webView.configuration.userContentController.add(
            ScriptMessageHandler(handleEvent: handleEvent),
            name: "jumbo")
        webView.evaluateJavaScript(runnerScript) { _, error in
            if let error = error {
                handleScriptError(error)
                return
            }
            let startOperationsScript = operationIDs
                .map { "startOperation(\"\($0.escapingForDoubleQuoting)\")" }
                .joined(separator: ";")
            webView.evaluateJavaScript(
                startOperationsScript,
                completionHandler: { _, error in
                    if let error = error {
                        handleScriptError(error)
                    }
                })
        }
        self.webView = webView
    }
}

/// This class implements `WKScriptMessageHandler` by parsing incoming messages
/// as JSON strings decodable using `Message`'s `Decodable` conformance.
private class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private let handleEvent: (Result<Message, Error>) -> ()
    private let decoder = JSONDecoder()
    
    private struct BodyFormatError: Error {}
    
    init(handleEvent: @escaping (Result<Message, Error>) -> ()) {
        self.handleEvent = handleEvent
    }
    
    // MARK: WKScriptMessageHandler
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage)
    {
        handleEvent({
            do {
                guard
                    let string = message.body as? String,
                    let data = string.data(using: .utf8)
                    else { throw BodyFormatError() }
                return .success(
                    try decoder.decode(Message.self, from: data))
            } catch {
                return .failure(error)
            }
        }())
    }
}
