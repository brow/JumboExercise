//
//  ModelTests.swift
//  JumboExerciseTests
//
//  Created by Tom Brow on 12/23/19.
//  Copyright © 2019 Tom Brow. All rights reserved.
//

import XCTest
@testable import JumboExercise

class ModelTests: XCTestCase {
    func testEmpty() {
        let model = Model(operationIDs: [])
        XCTAssertEqual(model.count, 0)
    }
    
    func testProgressAndCompletion() {
        let operationID = "TikTok"
        var model = Model(operationIDs: [operationID])
        XCTAssertEqual(model.count, 1)
        
        let cellModel0 = model.cellModelAtIndex(0)
        XCTAssertEqual(cellModel0.text, operationID)
        XCTAssertEqual(cellModel0.progress, 0)
        XCTAssertNil(cellModel0.detailText)
        
        model.updateWith(Message(
            id: operationID,
            content: .inProgress(progress: 75)))
        let cellModel1 = model.cellModelAtIndex(0)
        XCTAssertEqual(cellModel1.text, operationID)
        XCTAssertEqual(cellModel1.progress, 0.75)
        XCTAssertNil(cellModel1.detailText)
        
        let completionState = "got tired"
        model.updateWith(Message(
            id: operationID,
            content: .completed(state: completionState)))
        let cellModel2 = model.cellModelAtIndex(0)
        XCTAssertEqual(cellModel2.text, operationID)
        XCTAssertNil(cellModel2.progress)
        XCTAssertEqual(cellModel2.detailText, completionState)
        
        model.updateWith(Message(
            id: "Some other operation",
            content: .inProgress(progress: 10)))
        XCTAssertEqual(
            cellModel2.detailText,
            completionState,
            "The operation is unaffected by a message concerning a different operation.")
        
        model.updateWith(Message(
            id: operationID,
            content: .inProgress(progress: 30)))
        XCTAssertEqual(
            model.cellModelAtIndex(0).progress,
            0.3,
            "The model does not enforce that progress strictly increases or that `completed` operations never go back to `inProgress`.")
    }
}
