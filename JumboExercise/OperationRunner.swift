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
    
    init(operationIDs: [Operation.ID]) {
        webView = WKWebView(
            frame: .zero,
            configuration: {
                class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
                    func userContentController(
                        _ userContentController: WKUserContentController,
                        didReceive message: WKScriptMessage)
                    {
                        do {
                            print(try Message(message))
                        } catch {
                            print(error)
                        }
                    }
                }
                
                let userContentController = WKUserContentController()
                userContentController.add(ScriptMessageHandler(), name: "jumbo")
                userContentController.addUserScript(WKUserScript(
                    source: operationIDs
                        .map { $0.replacingOccurrences(of: "\"", with: "\\\"") }
                        .map { "startOperation(\"\($0)\")" }
                        .joined(separator: ";"),
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: false))
                
                let configuration = WKWebViewConfiguration()
                configuration.userContentController = userContentController
                return configuration
            }())
        webView.loadHTMLString(
            "<script src=\"https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js\"></script>",
            baseURL: nil)
    }
}
