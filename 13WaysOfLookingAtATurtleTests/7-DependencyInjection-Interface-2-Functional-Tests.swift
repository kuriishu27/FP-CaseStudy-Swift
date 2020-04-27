//
//  7-DependencyInjection-Interface-2-Functional-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 27/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class DIInterfaceFP2Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormalSize() {

        let api = ImplementationPassInSingleFunctions().normalSize()
        TurtleApiClientPassInSingleFunctions.drawTriangle(api: api)

    }

    func testHalfSize() {

        let api = ImplementationPassInSingleFunctions().halfSize()
        TurtleApiClientPassInSingleFunctions.drawTriangle(api: api)

    }

}
