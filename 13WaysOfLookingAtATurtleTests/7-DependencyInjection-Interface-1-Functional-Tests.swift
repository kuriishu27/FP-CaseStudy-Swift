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

    func testNormalSize() {
        let apiFn = TurtleImplementationPassInAllFunctions.normalSize()
        TurtleApiClientPassInAllFunctions.drawTriangle(api: apiFn)
    }

    func testHalfSize() {
        let apiFn = TurtleImplementationPassInAllFunctions.halfSize()
        TurtleApiClientPassInAllFunctions.drawTriangle(api: apiFn)
    }

}
