//
//  3-API-OO-Core-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class __API_OO_Core_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
