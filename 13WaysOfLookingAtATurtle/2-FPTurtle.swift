//
//  2-FPTurtle.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    02-FPTurtle.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #2: Simple FP - a module of functions with immutable state
//
//    In this design, the turtle state is immutable. A module contains functions that return a new turtle state,
//    and the client uses these turtle functions directly.
//
//    The client must keep track of the current state and pass it into the next function call.
//
//    ======================================

// ======================================
// FP Turtle
// ======================================

// ======================================
// FP Turtle Client
// ======================================

final class FPTurtleClient {

    /// Function to log a message
    static let log: (String) -> Void = { message in
        print(message)
    }

    // versions with log baked in (via partial application)
    static let move = FPTurtle.move(log)
    static let turn = FPTurtle.turn(log)
    static let penDown = FPTurtle.penDown(log)
    static let penUp = FPTurtle.penUp(log)
    static let setColor = FPTurtle.setColor(log)

    static let drawTriangle = FPTurtle.initialTurtleState
        |> move(100)
        |> turn(120)
        |> move(100)
        |> turn(120)
        |> move(100)
        |> turn(120)
    // back home at (0,0) with angle 0

    static let drawThreeLines = FPTurtle.initialTurtleState // draw black line
        |> penDown
        |> setColor(.black)
        |> move(100) // move without drawing
    //        |> penUp
    //        |> turn(90)
    //        |> move(100)
    //        |> turn(90) // draw red line
    //        |> penDown
    //        |> setColor(.red)
    //        |> move(100) // move without drawing
    //        |> penUp
    //        |> turn(90)
    //        |> move(100)
    //        |> turn(90) // back home at (0,0) with angle 0 and draw diagonal blue line
    //        |> penDown
    //        |> setColor(.blue)
    //        |> turn(45)
    //        |> move(100)

    static let drawPolygon: (Float) -> Void = { n in
        let angle = 180.0 - (360.0 / n)
        let angleDegrees = angle * 1

        // define a function that draws one side
        func oneSide(state: FPTurtle.TurtleState) -> FPTurtle.TurtleState {
            return state
                |> move(100)
                |> turn(angleDegrees)
        }

        // repeat for all sides
        [1, 2, 3, 4]
            |> reduce(FPTurtle.initialTurtleState, oneSide)

    }

    private static func reduce(
        _ initialResult: FPTurtle.TurtleState,
        _ nextPartialResult: @escaping (FPTurtle.TurtleState) -> FPTurtle.TurtleState)
        -> ([Int]) -> FPTurtle.TurtleState {

            return { times in
                return nextPartialResult(initialResult)
            }
    }

}

// ======================================
// FP Turtle tests
// ======================================

//FPTurtleClient.drawTriangle() |> ignore
//FPTurtleClient.drawThreeLines() |> ignore
//FPTurtleClient.drawPolygon 4 |> ignore
