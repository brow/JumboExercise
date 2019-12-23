//
//  OperationRunner.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/22/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import WebKit

class OperationRunner {
    private var webView: WKWebView?
    
    init(
        runnerScript: String,
        operationIDs: [Operation.ID],
        handleEvent: @escaping (Result<Message, Error>) -> ())
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

private extension String {
    var escapingForDoubleQuoting: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}

private class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private let handleEvent: (Result<Message, Error>) -> ()
    private let decoder = JSONDecoder()
    
    private struct BodyFormatError: Error {}
    
    init(handleEvent: @escaping (Result<Message, Error>) -> ()) {
        self.handleEvent = handleEvent
    }
    
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
