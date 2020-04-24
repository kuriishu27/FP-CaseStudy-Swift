//
//  OOTurtleLib.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    OOTurtleLib.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Common code for OO-style mutable turtle class
//
//    ======================================

//    ======================================
//    Turtle class
//    ======================================

// inject a logging function
class Turtle {

    var log: (String) -> ()

    init(_ log: @escaping (String) -> ()) {
        self.log = log
    }

    var currentPosition: Position = Position(x: 0, y: 0)
    var currentAngle: Angle = 0
    var currentColor: PenColor = .red
    var currentPenState: PenState = .up

    func move(_ distance: Distance) {
        log("Move \(distance)")
        // calculate new position
        let newPosition = calcNewPosition(distance: distance,
                                          angle: currentAngle,
                                          currentPos: currentPosition)
        // draw line if needed
        if currentPenState == .up {
            dummyDrawLine(log, currentPosition, newPosition, currentColor)
        }
        // update the state
        currentPosition = newPosition
    }

    func turn(_ angle: Float) {
        print("Turn \(angle)")
        // calculate new angle
        let newAngle = (currentAngle + angle).truncatingRemainder(dividingBy: 360)
        // update the state
        currentAngle = newAngle
    }

    func penUp() {
        print("Pen up")
        currentPenState = .up
    }

    func penDown() {
        print("Pen down")
        currentPenState = .down
    }

    func setColor(_ color: PenColor) {
        print("SetColor \(color)")
        currentColor = color
    }

}
