//
//  6-DependencyInjection-Interface-2-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class DependencyInjectionInterface2Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {

        let turtleFns = TurtleImplementationFP.normalSize()   // a TurtleFunctions type
        let api = TurtleApiLayerFP.TurtleApi(turtleFns)
//        TurtleApiClientFP.drawTriangle(api)

    }

}
