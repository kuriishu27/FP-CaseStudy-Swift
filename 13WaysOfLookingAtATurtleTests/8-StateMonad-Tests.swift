//
//  8-StateMonad-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 27/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class StateMonadTests: XCTestCase {

    func testDrawTriangle() throws {
        let triangle = TurtleComputationClient().drawTriangle()
        print(triangle.1)
    }

    func testDrawLines() {
        let lines = TurtleComputationClient().drawThreeLines()
        print(lines.1)
    }

    func testDrawHexagon() {
        let hexagon = TurtleComputationClient().drawPolygon(n: 6)
        print(hexagon.1)
    }

    func testDrawHeptagon() {
        let heptagon = TurtleComputationClient().drawPolygon(n: 7)
        print(heptagon.1)
    }

    func testDrawPolygon() {
        let pentagon = TurtleComputationClient().drawPolygon(n: 5)
        print(pentagon.1)
    }
}
