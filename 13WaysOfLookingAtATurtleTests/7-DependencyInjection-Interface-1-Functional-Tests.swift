//
//  7-DependencyInjection-Interface-1-Functional-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class DIInterfaceFP1Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormalSize() {

        let exp = XCTestExpectation()

        let apiFn = TurtleImplementationPassInAllFunctions.normalSize()
        TurtleApiClientPassInAllFunctions.drawTriangle(api: apiFn) {
            exp.fulfill()
        }

    }

    func testHalfSize() {

        let exp = XCTestExpectation()

        let apiFn = TurtleImplementationPassInAllFunctions.halfSize()
        TurtleApiClientPassInAllFunctions.drawTriangle(api: apiFn) {
            exp.fulfill()
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
