//
//  7-DependencyInjection-Interface-1-Functional-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class __DependencyInjection_Interface_1_Functional_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormalSize() {

        let apiFn = TurtleImplementation_PassInAllFunctions.normalSize()
        TurtleApiClient_PassInAllFunctions.drawTriangle(apiFn)

    }

    func testHalfSize() {

        let exp = XCTestExpectation()

        let apiFn = TurtleImplementation_PassInAllFunctions.halfSize()
        TurtleApiClient_PassInAllFunctions.drawTriangle(apiFn)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
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
