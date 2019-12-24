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
    
    func testInitialState() {
        let operationID = "TikTok"
        let model = Model(operationIDs: [operationID])
        XCTAssertEqual(model.count, 1)
        
        let cellModel = model.cellModelAtIndex(0)
        XCTAssertEqual(cellModel.text, operationID)
        XCTAssertEqual(cellModel.progress, 0)
        XCTAssertNil(cellModel.detailText)
    }
    
    func testProgress() {
        let operationID = "TikTok"
        var model = Model(operationIDs: [operationID])
        model.updateWith(Message(
            id: operationID,
            content: .inProgress(progress: 75)))
        
        let cellModel = model.cellModelAtIndex(0)
        XCTAssertEqual(cellModel.text, operationID)
        XCTAssertEqual(cellModel.progress, 0.75)
        XCTAssertNil(cellModel.detailText)
    }
}
