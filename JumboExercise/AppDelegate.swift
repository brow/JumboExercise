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
        let operationIDs = ["a", "b"]
        var state = State(operationIDs: operationIDs)
        
        let viewController = ViewController(rows: state.orderedOperations)
        
        operationRunner = OperationRunner(
            operationIDs: operationIDs,
            didReceiveMessage: { message in
                switch message {
                case .success(let message):
                    state.updateWith(message)
                    print(state.orderedOperations)
                case .failure(let error):
                    // TODO: A message serialization issue could cause errors
                    // to pile up rapidly. A UI that handles that gracefully
                    // would be better than alert views.
                    viewController.present(
                        UIAlertController(
                            title: "Error",
                            message: error.localizedDescription,
                            preferredStyle: .alert),
                        animated: true,
                        completion: nil)
                    
                }
            })
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
}
