//
//  OperationRunner.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/22/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import WebKit

struct OperationRunner {
    private let webView: WKWebView
    
    init(
        runnerScript: String,
        operationIDs: [Operation.ID],
        handleEvent: @escaping (Result<Message, Error>) -> ())
    {
        webView = WKWebView(
            frame: .zero,
            configuration: WKWebViewConfiguration(
                handleEvent: handleEvent,
                handlerName: "jumbo"))
                
        webView.evaluateJavaScript(runnerScript) { [webView] _, error in
            if let error = error {
                handleEvent(.failure(error))
            } else {
                let startOperationsScript = operationIDs
                    .map { "startOperation(\"\($0.escapingQuotes)\")" }
                    .joined(separator: ";")
                webView.evaluateJavaScript(
                    startOperationsScript,
                    completionHandler: { _, error in
                        if let error = error {
                            handleEvent(.failure(error))
                        }
                    })
            }
        }
    }
}

private extension String {
    var escapingQuotes: String {
        return replacingOccurrences(of: "\"", with: "\\\"")
    }
}

private extension WKWebViewConfiguration {
    convenience init(
        handleEvent: @escaping (Result<Message, Error>) -> (),
        handlerName: String) {
        self.init()
        userContentController.add(
            ScriptMessageHandler(handleEvent: handleEvent),
            name: handlerName)
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
