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

    func testNormalSize() {

        let turtleFns = TurtleImplementationFP.normalSize()   // a TurtleFunctions type
        let api = TurtleApiLayerFP.TurtleApi(turtleFns)
        TurtleApiClientFP().drawTriangle(api)

    }

    func testHalfSize() {

        let turtleFns = TurtleImplementationFP.halfSize()
        let api = TurtleApiLayerFP.TurtleApi(turtleFns)
        TurtleApiClientFP().drawTriangle(api)
    }

}
