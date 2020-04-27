//
//  6-DependencyInjection-Interface-1-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class DependencyInjectionInterface1Tests: XCTestCase {

    func testNormalSize() {

        let iTurtle = TurtleImplementationOO().normalSize()  // an ITurtle type
        let api = TurtleApiLayerOO.TurtleApi(iTurtle: iTurtle)
        TurtleApiClientOO().drawTriangle(api)

    }

    func testHalfSize() {
        let iTurtle = TurtleImplementationOO().halfSize()
        let api = TurtleApiLayerOO.TurtleApi(iTurtle: iTurtle)
        TurtleApiClientOO().drawTriangle(api)
    }

}
