//
//  _3WaysOfLookingAtATurtleTests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class FPTurtleTests: XCTestCase {

    func testDrawTriangle() {
        _ = FPTurtleClient.drawTriangle
    }

    func testDrawThreeLines() {
        _ = FPTurtleClient.drawThreeLines
    }

    func testDrawPolygon() {
        FPTurtleClient.drawPolygon(4)
    }

}
