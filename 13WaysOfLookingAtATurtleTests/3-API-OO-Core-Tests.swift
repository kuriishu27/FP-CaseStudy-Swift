//
//  3-API-OO-Core-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class APIOOCoreTests: XCTestCase {

    func testDrawTriangle() {
        TurtleApiClient.drawTriangle()
    }

    func testDrawThreeLines() {
        TurtleApiClient.drawThreeLines()
    }

    func testDrawPolygon() {
        TurtleApiClient.drawPolygon(4)
    }

}
