//
//  12-BranchingOnResponse.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    12-BranchingOnResponse.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #12: Monadic control flow -- Making decisions in the turtle computation expression
//
//    In this design, the turtle can reply to certain commands with errors.
//
//    The code demonstrates how the client can make decisions inside the turtle computation expression
//    while the state is being passed around behind the scenes.
//
//    ======================================

enum MoveResponse {
    case moveOk
    case hitABarrier
}

enum SetColorResponse {
    case colorOk
    case outOfInk
}

// ======================================
// MARK: TurtleComputationClient
// ======================================

final class TurtleComputationClientMonad {

    let turtleBuilder = TurtleStateComputationClass.turtle

    /// Function to log a message
    static let log: (String) -> Void = { message in
        print(message)
    }

    let initialTurtleState = FPTurtle.initialTurtleState

    // ----------------------------------------
    // monadic versions of the Turtle functions
    // ----------------------------------------

    let move: (Distance) -> TurtleStateComputation<MoveResponse> = { dist in
        TurtleStateComputationClass.toComputation(FPTurtle.moveR(log)(dist))
    }

    let turn: (Angle) -> TurtleStateComputation<Unit> = { angle in
        TurtleStateComputationClass.toUnitComputation(FPTurtle.turn(log)(angle))
    }

    let penDown: () -> TurtleStateComputation<Unit> = {
        TurtleStateComputationClass.toUnitComputation(FPTurtle.penDown(log))
    }

    let penUp: () -> TurtleStateComputation<Unit> = {
        TurtleStateComputationClass.toUnitComputation(FPTurtle.penUp(log))
    }

    let setColor: (PenColor) -> TurtleStateComputation<SetColorResponse> = { color in
        TurtleStateComputationClass.toComputation(FPTurtle.setColorR(log)(color))
    }

    // ----------------------------------------
    // draw various things
    // ----------------------------------------

    // ----------------------------------------
       // draw various things
       // ----------------------------------------

    func handleMoveResponse(_ moveResponse: MoveResponse) -> TurtleStateComputation<Unit> {
        switch moveResponse {
        case .moveOk:
            return TurtleStateComputationClass.returnT(())
        case .hitABarrier:

            print("Oops -- hit a barrier -- turning")

            return turtleBuilder.turtle {
                bind(turn, 90)
            }

        }
    }

    func drawShapeWithoutResponding() -> (Unit, TurtleState) {
        // define a set of instructions
        let t = turtleBuilder.turtle {
            move(60)
            move(60)
            move(60)
            move(60)
        }

        // finally, run the monad using the initial state
        return TurtleStateComputationClass.runT(t, FPTurtle.initialTurtleState)

    }

    func drawShape() -> (Unit, TurtleState) {

        let response1 = bind(move, 60)
        let response2 = bind(move, 60)
        let response3 = bind(move, 60)

        // define a set of instructions
        let t = turtleBuilder.turtle {
            handleMoveResponse(response1)
            handleMoveResponse(response2)
            handleMoveResponse(response3)
        }

        // finally, run the monad using the initial state
        return TurtleStateComputationClass.runT(t, FPTurtle.initialTurtleState)

    }

    private func bind<T, U>(_ f: @escaping (T) -> TurtleStateComputation<U>,
                            _ value: T) -> U {
        return f(value)(FPTurtle.initialTurtleState).0
    }

    private func bind<T>(_ f: @escaping (T) -> TurtleStateComputation<Unit>,
                         _ value: T) -> TurtleStateComputation<Unit> {

        TurtleStateComputationClass.bindT(f, TurtleStateComputationClass.returnT(value))

    }

//    func drawThreeLines() -> (Unit, TurtleState) {
//
//        // define a set of instructions
//        let t = turtleBuilder.turtle {
//            // draw black line
//            bind(penDown, ())
//            bind(setColor, PenColor.black)
//            bind(move, Distance(100))
//            // move without drawing
//            bind(penUp, ())
//            bind(turn, Angle(90.0))
//            bind(move, Distance(100))
//            bind(turn, Angle(90.0))
//            // draw red line
//            bind(penDown, ())
//            bind(setColor, PenColor.red)
//            bind(move, Distance(100))
//            // move without drawing
//            bind(penUp, ())
//            bind(turn, 90.0)
//            bind(move, 100.0)
//            bind(turn, 90.0)
//            // back home at (0,0) with angle 0
//            // draw diagonal blue line
//            bind(penDown, ())
//            bind(setColor, PenColor.blue)
//            bind(turn, Angle(45))
//            bind(move, Distance(100))
//            }
//
//        // finally, run them using the initial state
//            return TurtleStateComputationClass.runT(t, FPTurtle.initialTurtleState)
//
//    }

//    func drawPolygon(n: Float) -> (Unit, TurtleState) {
//
//        let angle = 180.0 - (360.0 / n)
//        let angleDegrees = angle * 1
//
//        // define a function that draws one side
//        let oneSide: TurtleStateComputation<Unit> = turtleBuilder.turtle {
//            bind(penDown, ())
//            bind(move, 100.0)
//            bind(turn, angleDegrees)
//            bind(penUp, ())
//        }
//
//        // chain two turtle operations in sequence
//        func chain(_ f: @escaping TurtleStateComputation<Unit>,
//                   _ g: @escaping TurtleStateComputation<Unit>) -> TurtleStateComputation<Unit> {
//
//            let t: TurtleStateComputation<Unit> = turtleBuilder.turtle {
//                f
//                g
//            }
//
//            return t
//        }
//
//        // create a list of operations, one for each side
//        let sides = Array(repeating: oneSide, count: Int(n))
//
//        // chain all the sides into one operation
//        let all: TurtleStateComputation<Unit> = sides
//            .reduce(TurtleStateComputationClass.toUnitComputation({ _ in
//                FPTurtle.initialTurtleState
//            }), chain)
//
//        // finally, run them using the initial state
//        return TurtleStateComputationClass.runT(all, FPTurtle.initialTurtleState)
//
//    }

}
