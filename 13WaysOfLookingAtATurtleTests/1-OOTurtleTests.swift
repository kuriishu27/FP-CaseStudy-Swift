//
//  1-OOTurtleTests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class OOTurtleTests: XCTestCase {

    func testDrawTriangle() {
        OOTurtleClient().drawTriangle()
    }

    func testDrawThreeLines() {
        OOTurtleClient().drawThreeLines()
    }

    func testDrawPolygon() {
        OOTurtleClient().drawPolygon(4)
    }

}
