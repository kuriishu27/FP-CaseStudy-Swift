//
//  8-StateMonads.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    08-StateMonad.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #8: Batch oriented -- Using a state monad (computation expression)
//
//    In this design, the client uses the FP Turtle functions directly.
//
//    As before, the client must keep track of the current state and pass it into the next function call,
//    but this time the state is kept out of sight by using a State monad (called `turtle` computation expression here)
//
//    As a result, there are no mutables anywhere.
//
//    ======================================

// ======================================
// TurtleStateComputation
// ======================================

/// Create a type to wrap a function like:
///    oldState -> (a,newState)

typealias TurtleStateComputation<T> = (TurtleState) -> (T, TurtleState)

/// Functions that work with TurtleStateComputation
struct TurtleStateComputationClass {

    static func runT<T>(_ turtle: TurtleStateComputation<T>, _ state: TurtleState) -> (T, TurtleState) {
        // pattern match against the turtle
        // to extract the inner function
        let innerFn = turtle
        return innerFn(state)

    }

    static func returnT<T>(_ x: T) -> TurtleStateComputation<T> {

        let innerFn: (TurtleState) -> (T, TurtleState) = { state in
            return (x, state)
        }
        return innerFn

    }

    static func bindT<T, U>(_ f: @escaping (T) -> TurtleStateComputation<U>,
                            _ xT: @escaping TurtleStateComputation<T>) -> TurtleStateComputation<U> {

        let innerFn: (TurtleState) -> (U, TurtleState) = { state in
            let (x, state2) = TurtleStateComputationClass.runT(xT, state)
            return self.runT(f(x), state2)
        }

        return innerFn
    }

//    static func bindCurriedT<T, U>(_ f: (T) -> TurtleStateComputation<U>) -> (TurtleStateComputation<T>) -> TurtleStateComputation<U> {
//
//        return { (xT) in
//            let innerFn: (TurtleState) -> (U, TurtleState) = { state in
//                let (x, state2) = TurtleStateComputationClass.runT(xT, state)
//                return self.runT(f(x), state2)
//            }
//
//            return innerFn
//        }
//
//    }

//    static func mapT<T, U>(_ f: @escaping (T) -> U) -> TurtleStateComputation<U> {
//        let x = f >-> returnT
//
//    }

    static func toComputation<T>(_ f: @escaping (TurtleState) -> (T, TurtleState)) -> TurtleStateComputation<T> {

        let innerFn: (TurtleState) -> (T, TurtleState) = { state in
            let (result, state2) = f(state)
            return (result, state2)
        }
        return innerFn

    }

    static func toUnitComputation(_ f: @escaping (TurtleState) -> TurtleState) -> TurtleStateComputation<Unit> {

        let f2: (TurtleState) -> (Unit, TurtleState) = { state in
            return ((), f(state))
        }
        return toComputation(f2)
    }

    // define a computation expression builder
    @_functionBuilder
    struct TurtleBuilder {

        static func buildBlock<T>(_ x: TurtleStateComputation<T>...) -> TurtleStateComputation<Unit> {

            let finalResult = x
                .reduce(into: FPTurtle.initialTurtleState) { (acc, val) in

                    let previousState = acc
                    let newState = val(previousState).1

                    acc = newState

            }

            return TurtleStateComputationClass.toUnitComputation({ _ in finalResult })

        }

        func turtle<T>(
            @TurtleBuilder child: () -> TurtleStateComputation<T>
        ) -> TurtleStateComputation<T> {
            return child()
        }

    }

    // create an instance of the computation expression builder
    static let turtle = TurtleBuilder()

}

// ======================================
// - MARK: TurtleComputationClient
// ======================================

final class TurtleComputationClient {

    let turtleBuilder = TurtleStateComputationClass.turtle

    /// Function to log a message
    static let log: (String) -> Void = { message in
        print(message)
    }

    let initialTurtleState = FPTurtle.initialTurtleState

    // ----------------------------------------
    // monadic versions of the Turtle functions
    // ----------------------------------------

    let move: (Distance) -> TurtleStateComputation<Unit> = { dist in
        TurtleStateComputationClass.toUnitComputation(FPTurtle.move(log)(dist))
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

    let setColor: (PenColor) -> TurtleStateComputation<Unit> = { color in
        TurtleStateComputationClass.toUnitComputation(FPTurtle.setColor(log)(color))
    }

    // ----------------------------------------
    // draw various things
    // ----------------------------------------

    func drawTriangle() -> (Unit, TurtleState) {

        // define a set of instructions
        let t: TurtleStateComputation<Unit> = turtleBuilder.turtle {
            bind(move, Distance(100))
            bind(turn, Angle(120))
            bind(move, Distance(100))
            bind(turn, Angle(120))
            bind(move, Distance(100))
            bind(turn, Angle(120))
        }

        // finally, run them using the initial state as input
        return TurtleStateComputationClass.runT(t, FPTurtle.initialTurtleState)

    }

    private func bind<T>(_ f: @escaping (T) -> TurtleStateComputation<Unit>, _ value: T) -> TurtleStateComputation<Unit> {

        TurtleStateComputationClass
            .bindT(f, TurtleStateComputationClass.returnT(value))

    }

    func drawThreeLines() -> (Unit, TurtleState) {

        // define a set of instructions
        let t = turtleBuilder.turtle {
            // draw black line
            bind(penDown, ())
            bind(setColor, PenColor.black)
            bind(move, Distance(100))
            // move without drawing
            bind(penUp, ())
            bind(turn, Angle(90.0))
            bind(move, Distance(100))
            bind(turn, Angle(90.0))
            // draw red line
            bind(penDown, ())
            bind(setColor, PenColor.red)
            bind(move, Distance(100))
            // move without drawing
            bind(penUp, ())
            bind(turn, 90.0)
            bind(move, 100.0)
            bind(turn, 90.0)
            // back home at (0,0) with angle 0
            // draw diagonal blue line
            bind(penDown, ())
            bind(setColor, PenColor.blue)
            bind(turn, Angle(45))
            bind(move, Distance(100))
            }

        // finally, run them using the initial state
            return TurtleStateComputationClass.runT(t, FPTurtle.initialTurtleState)

    }

    func drawPolygon(n: Float) -> (Unit, TurtleState) {

        let angle = 180.0 - (360.0 / n)
        let angleDegrees = angle * 1

        // define a function that draws one side
        let oneSide: TurtleStateComputation<Unit> = turtleBuilder.turtle {
            bind(penDown, ())
            bind(move, 100.0)
            bind(turn, angleDegrees)
            bind(penUp, ())
        }

        // chain two turtle operations in sequence
        func chain(_ f: @escaping TurtleStateComputation<Unit>,
                   _ g: @escaping TurtleStateComputation<Unit>) -> TurtleStateComputation<Unit> {

            let t: TurtleStateComputation<Unit> = turtleBuilder.turtle {
                f
                g
            }

            return t
        }

        // create a list of operations, one for each side
        let sides = Array(repeating: oneSide, count: Int(n))

        // chain all the sides into one operation
        let all: TurtleStateComputation<Unit> = sides
            .reduce(TurtleStateComputationClass.toUnitComputation({ _ in
                FPTurtle.initialTurtleState
            }), chain)

        // finally, run them using the initial state
        return TurtleStateComputationClass.runT(all, FPTurtle.initialTurtleState)

    }

}
