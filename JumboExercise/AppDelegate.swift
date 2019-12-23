//
//  AppDelegate.swift
//  JumboExercise
//
//  Created by Tom Brow on 12/20/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var operationRunner: OperationRunner?
    
    // MARK: UIApplicationDelegate
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        let operationIDs = ["Facebook", "Google Maps", "Twitter", "\"Dark Web\""]
        var state = State(operationIDs: operationIDs)
        let viewController = ViewController(rows: state.orderedOperations)
        
        func didReceiveMessage(_ message: Result<Message, Error>) {
            switch message {
            case .success(let message):
                state.updateWith(message)
                viewController.updateRowsTo(state.orderedOperations)
            case .failure(let error):
                // TODO: A message serialization issue could cause errors
                // to pile up rapidly. A UI that handles that gracefully
                // would be better than alert views.
                viewController.present(
                    UIAlertController(error: error),
                    animated: true,
                    completion: nil)
            }
        }
        
        let scriptURL = URL(
            string: "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js")!
        URLSession.shared
            .dataTask(with: scriptURL) { [weak self] data, _, error in
                DispatchQueue.main.async {
                    do {
                        if let error = error { throw error }
                        guard
                            let bodyData = data,
                            let bodyString = String(data: bodyData, encoding: .utf8)
                            else {
                                struct ResponseBodyError: Error {}
                                throw ResponseBodyError()
                        }
                        self?.operationRunner = OperationRunner(
                            runnerScript: bodyString,
                            operationIDs: operationIDs,
                            handleEvent: didReceiveMessage)
                    } catch {
                        didReceiveMessage(.failure(error))
                    }
                }
            }
            .resume()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
}

private extension UIAlertController {
    convenience init(error: Error) {
        self.init(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
        addAction(UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil))
    }
}
