//
//  1-OOTurtle.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//
//    01-OOTurtle.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #1: Simple OO -- a class with mutable state
//
//    In this design, a simple OO class represents the turtle,
//    and the client talks to the turtle directly.
//
//    ======================================

class OOTurtleClient {

    /// Function to log a message
    var log: (String) -> () = { message in
        print(String(format: "%s", message))
    }

    func drawTriangle() {
        let turtle = Turtle(log)
        turtle.move(100.0)
        turtle.turn(120.0)
        turtle.move(100.0)
        turtle.turn(120.0)
        turtle.move(100.0)
        turtle.turn(120.0)
    }
    // back home at (0,0) with angle 0

    func drawThreeLines() {
        let turtle = Turtle(log)
        // draw black line
        turtle.penDown()
        turtle.setColor(.black)
        turtle.move(100)
        // move without drawing
        turtle.penUp()
        turtle.turn(90)
        turtle.move(100)
        turtle.turn(90.0)
        // draw red line
        turtle.penDown()
        turtle.setColor(.red)
        turtle.move(100)
        // move without drawing
        turtle.penUp()
        turtle.turn(90)
        turtle.move(100)
        turtle.turn(90)
        // back home at (0,0) with angle 0
        // draw diagonal blue line
        turtle.penDown()
        turtle.setColor(.blue)
        turtle.turn(45)
        turtle.move(100)
    }

    func drawPolygon(_ n: Float) {
        let angle = 180.0 - (360.0 / n)
        let angleDegrees = angle * 1
        let turtle = Turtle(log)
        // define a function that draws one side
        func drawOneSide() {
            turtle.move(100)
            turtle.turn(angleDegrees)
        }

        // repeat for all sides
        for _ in [1..<n] {
            drawOneSide()
        }

    }

}

//    OOTurtleClient().drawTriangle()
//    OOTurtleClient().drawThreeLines()
//    OOTurtleClient().drawPolygon(4)

