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
        script: String,
        operationIDs: [Operation.ID],
        didReceiveMessage: @escaping (Result<Message, Error>) -> ())
    {
        webView = WKWebView(
            frame: .zero,
            configuration: {
                let userContentController = WKUserContentController()
                userContentController.add(
                    ScriptMessageHandler(didReceiveMessage: didReceiveMessage),
                    name: "jumbo")
                userContentController.addUserScript(WKUserScript(
                    source: operationIDs
                        .map { "startOperation(\"\($0.escapingQuotes)\")" }
                        .joined(separator: ";"),
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: true))
                
                let configuration = WKWebViewConfiguration()
                configuration.userContentController = userContentController
                return configuration
            }())
                
        webView.evaluateJavaScript(script) { [webView] _, error in
            if let error = error {
                didReceiveMessage(.failure(error))
            } else {
                webView.evaluateJavaScript(
                    operationIDs
                        .map { "startOperation(\"\($0.escapingQuotes)\")" }
                        .joined(separator: ";"),
                    completionHandler: { _, error in
                        if let error = error {
                            didReceiveMessage(.failure(error))
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

private class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private let didReceiveMessage: (Result<Message, Error>) -> ()
    private let decoder = JSONDecoder()
    
    private struct BodyFormatError: Error {}
    
    init(didReceiveMessage: @escaping (Result<Message, Error>) -> ()) {
        self.didReceiveMessage = didReceiveMessage
    }
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage)
    {
        didReceiveMessage({
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
