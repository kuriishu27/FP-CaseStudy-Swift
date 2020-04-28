//
//  5-Agent-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 28/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class AgentTests: XCTestCase {

    func testExample() throws {
        TurtleApiClientAgent().drawTriangle()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
