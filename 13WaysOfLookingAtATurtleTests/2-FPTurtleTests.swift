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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDrawTriangle() {
        FPTurtleClient.drawTriangle
    }

    func testDrawThreeLines() {
        FPTurtleClient.drawThreeLines
    }

    func testDrawPolygon() {
        FPTurtleClient.drawPolygon(4)
    }

}
