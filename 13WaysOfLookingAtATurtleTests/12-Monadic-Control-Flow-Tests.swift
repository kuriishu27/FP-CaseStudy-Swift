//
//  12-Monadic-Control-Flow-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 29/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class MonadicControlFlowTests: XCTestCase {

    func testExample() throws {
        TurtleComputationClientMonad().drawShape()
    }

}
