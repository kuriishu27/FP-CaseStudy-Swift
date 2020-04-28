//
//  9-BatchCommands-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 28/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class BatchCommandsTests: XCTestCase {

    func testDrawTriangle() throws {
        TurtleCommmandClient().drawTriangle()
    }

    func testDrawThreeLines() {
        TurtleCommmandClient().drawThreeLines()
    }

    func testDrawPolygon() {
        TurtleCommmandClient().drawPolygon(4)
    }

}
