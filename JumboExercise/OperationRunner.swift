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
                        .map { $0.replacingOccurrences(of: "\"", with: "\\\"") }
                        .map { "startOperation(\"\($0)\")" }
                        .joined(separator: ";"),
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: true))
                
                let configuration = WKWebViewConfiguration()
                configuration.userContentController = userContentController
                return configuration
            }())
        
        // If the following the script resource fails to load, then
        // didReceiveMessage will never be called, not even with an Error.
        webView.loadHTMLString(
            "<script src=\"https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js\"></script>",
            baseURL: nil)
    }
}

private class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private let didReceiveMessage: (Result<Message, Error>) -> ()
    private let decoder = JSONDecoder()
    
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
                    else {
                        struct BodyFormatError: Error {}
                        throw BodyFormatError()
                    }
               
                return .success(
                    try decoder.decode(Message.self, from: data))
            } catch {
                return .failure(error)
            }
        }())
    }
}
