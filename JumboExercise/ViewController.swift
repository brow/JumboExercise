//
//  ViewController.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemBackground
        
        let webView = WKWebView(
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
                    source: "startOperation(\"testing\");",
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: false))
                
                let configuration = WKWebViewConfiguration()
                configuration.userContentController = userContentController
                return configuration
            }())
        view.addSubview(webView)
        
        webView.loadHTMLString(
            "<script src=\"https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js\"></script>",
            baseURL: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
