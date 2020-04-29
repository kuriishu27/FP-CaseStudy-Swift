//
//  10-Event-Sourcing-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 29/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class EventSourcingTests: XCTestCase {

    func testExample() throws {
        CommandHandlerClient().drawTriangle()
    }

    func testDrawThreeLines() {
        CommandHandlerClient().drawThreeLines() // Doesn't go back home
    }

    func testDrawPolygon() {
        
    }

}
