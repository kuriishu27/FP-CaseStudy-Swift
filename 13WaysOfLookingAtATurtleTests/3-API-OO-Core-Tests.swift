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
        let client = TurtleApiClient()
        client.drawTriangle()
    }

    func testDrawThreeLines() {
        let client = TurtleApiClient()
        client.drawThreeLines()
    }

    func testDrawPolygon() {
        let client = TurtleApiClient()
        client.drawPolygon(4)
    }

}
