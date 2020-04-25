//
//  6-DependencyInjection-Interface-1-Tests.swift
//  13WaysOfLookingAtATurtleTests
//
//  Created by Christian Leovido on 25/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
@testable import _3WaysOfLookingAtATurtle

class __DependencyInjection_Interface_1_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {

        let iTurtle = TurtleImplementation_OO.normalSize()  // an ITurtle type
        let api = TurtleApiLayer_OO.TurtleApi(iTurtle: iTurtle)
        TurtleApiClient_OO.drawTriangle(api)

    }

    func testExample2() {
        let iTurtle = TurtleImplementation_OO.halfSize()
        let api = TurtleApiLayer_OO.TurtleApi(iTurtle: iTurtle)
        TurtleApiClient_OO.drawTriangle(api)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
