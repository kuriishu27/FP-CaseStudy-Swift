//
//  6-DependencyInjection-Interface-2-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class __DependencyInjection_Interface_2_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {

        let turtleFns = TurtleImplementation_FP.normalSize()   // a TurtleFunctions type
        let api = TurtleApiLayer_FP.TurtleApi(turtleFns)
//        TurtleApiClient_FP.drawTriangle(api)

    }

}
