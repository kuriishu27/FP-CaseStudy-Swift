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

    let log: (String) -> Void

    init(_ log: @escaping (String) -> Void) {
        self.log = log
    }

    var currentPosition: Position = Position(x: 0, y: 0)
    var currentAngle: Angle = 0
    var currentColor: PenColor = .red
    var currentPenState: PenState = .up

    lazy var move: (Distance) -> Unit = { distance in
        self.log("Move \(distance)")
        // calculate new position
        let newPosition = calcNewPosition(distance: distance,
                                          angle: self.currentAngle,
                                          currentPos: self.currentPosition)
        // draw line if needed
        if self.currentPenState == .up {
            dummyDrawLine(self.log, self.currentPosition, newPosition, self.currentColor)
        }
        // update the state
        self.currentPosition = newPosition
    }

    lazy var turn: (Angle) -> Unit = { angle in
        print("Turn \(angle)")
        // calculate new angle
        let newAngle = (self.currentAngle + angle).truncatingRemainder(dividingBy: 360)
        // update the state
        self.currentAngle = newAngle
    }

    lazy var penUp: () -> Unit = {
        print("Pen up")
        self.currentPenState = .up
    }

    lazy var penDown: () -> Unit = {
        print("Pen down")
        self.currentPenState = .down
    }

    lazy var setColor: (PenColor) -> Unit = { color in
        print("SetColor \(color)")
        self.currentColor = color
    }

}
