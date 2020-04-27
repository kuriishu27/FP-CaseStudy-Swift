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

    func testNormalSize() {

        let api = ImplementationPassInSingleFunctions().normalSize()
        TurtleApiClientPassInSingleFunctions.drawTriangle(api: api)

    }

    func testHalfSize() {

        let api = ImplementationPassInSingleFunctions().halfSize()
        TurtleApiClientPassInSingleFunctions.drawTriangle(api: api)

    }

}
