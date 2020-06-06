//
//  Common.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation
import Runes
import RxSwift
import RxCocoa

precedencegroup PipeOperatorPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator |>: PipeOperatorPrecedence

func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

// (f |> g)(x) = f(g(x))
func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

// ======================================
// Common types and helper functions
// ======================================

enum TurtleCommands: String {
    case move = "Move"
    case turn = "Turn"
    case penUp = "PenUp"
    case penDown = "PenDown"
    case setColor = "SetColor"
}

/// An alias for a float
typealias Distance = Float

/// Use a unit of measure to make it clear that the angle is in degrees, not radians
typealias Degrees = Float

/// An alias for a float of Degrees
typealias Angle = Float

/// Enumeration of available pen states
enum PenState: Equatable {
    case up
    case down
}

/// Enumeration of available pen colors
enum PenColor: String, Equatable {
    case black
    case red
    case blue
}

/// A structure to store the (x,y) coordinates
struct Position: Equatable {
    let x: Float
    let y: Float
}

// ======================================
// Common helper functions
// ======================================

// round a float to two places to make it easier to read
//let round2 (flt:float) = Math.Round(flt,2)

/// calculate a new position from the current position given an angle and a distance
func calcNewPosition(distance: Distance,
                     angle: Angle,
                     currentPos: Position) -> Position {
    // Convert degrees to radians with 180.0 degrees = 1 pi radian
    let angleInRads = angle * Float((Double.pi / 180.0))
    // current pos
    let x0 = currentPos.x
    let y0 = currentPos.y
    // new pos
    let x1 = x0 + (distance * cos(angleInRads))
    let y1 = y0 + (distance * sin(angleInRads))
    // return a new Position
    return Position(x: x1, y: y1)
}

/// Default initial state
let initialPosition = Position(x: 0, y: 0)
let initialColor: PenColor = .black
let initialPenState: PenState = .down

/// Emulating a real implementation for drawing a line
func dummyDrawLine
    (
    _ log: (String) -> Void,
    _ oldPos: Position,
    _ newPos: Position,
    _ color: PenColor
) {
    // for now just log it
    log("...Draw line from (\(oldPos.x), \(oldPos.y)) to (\(newPos.x), \(newPos.y)) using \(color)")
}

/// trim a string
let trimString: (String) -> String = { string in
    return string.replacingOccurrences(of: " ", with: "")
}

// ======================================
// Result companion module
// ======================================

precedencegroup KleisliOperatorPrecedence {
    associativity: left
    higherThan: PipeOperatorPrecedence
}

infix operator >=>: KleisliOperatorPrecedence

struct ResultModule {

    static func returnR<T>(_ x: T) -> Result<T, Error> { Result.success(x) }

    //    let ( >>= ) xR f =
    //        Result.bind f xR

    // infix version of map
    //    let ( <!> ) = Result.map
    // USE RUNES <^>

    //    let applyR fR xR =
    //        fR >>= (fun f ->
    //        xR >>= (fun x ->
    //            returnR (f x) ))

    // infix version of apply
    //    let ( <*> ) = applyR

    // lift a one-parameter function to result world (same as mapR)
    static func lift1R<T, U>(_ f: (T) -> U,
                             _ x: Result<T, Error>) -> Result<U, Error> { f <^> x }

    // lift a two-parameter function to result world
    static func lift2R<T, U, V> (_ f: (T) -> (U) -> V,
                                 _ x: Result<T, Error>,
                                 _ y: Result<U, Error>) -> Result<V, Error> {
        return f <^> x <*> y
    }

    static func bind<T, U>(_ m: Result<T, Error>,
                           _ f: (T) -> Result<U, Error>) -> Result<U, Error> {
        f -<< m
    }

    /// Computation Expression
    @_functionBuilder
    struct ResultBuilder {

        static func buildBlock<T>(_ x: Result<T, Error>...) -> Result<T, Error> {
            Result.success(try! x.first!.get())
        }

        func bind<T, U>(_ m: Result<T, Error>,
                        _ f: (T) -> Result<U, Error>) -> Result<U, Error> {
            m >>- f
        }

        func `return`<T>(_ x: T) -> Result<T, Error> {
            Result.success(x)
        }

        func returnFrom<T>(_ m: Result<T, Error>) -> Result<T, Error> {
            m
        }

        func zero() -> Result<Unit, Error> {
            self.return(())
        }

        func combine<T, U>(_ m1: Result<T, Error>,
                           _ f: (T) -> Result<U, Error>) -> Result<U, Error> {
            return bind(m1, f)
        }

        func delay<T, U>(f: @escaping (T) -> U) -> (T) -> U {
            f
        }

        func run<T, U>(m: @escaping (T) -> U) -> (T) -> U {
            m
        }

        func tryWith<T>(m: Result<T, Error>,
                        h: () throws -> Result<T, Error>) -> Result<T, Error> {
            return returnFrom(m)
        }

        func tryFinally<T>(m: Result<T, Error>,
                           compensation: () -> Void) -> Result<T, Error> {
            compensation()
            return returnFrom(m)
        }

        func using<T, U>(res: T,
                         body: (T) -> Result<U, Error>) -> Result<U, Error> {

            let m = body(res)

            return tryFinally(m: m) {

            }

        }

        func `while`<T>(cond: (Unit) -> Bool,
                        m: (Unit) -> Result<T, Error>) -> Result<Unit, Error> {

            if !cond(()) {
                return zero()
            } else {

                func f (value: T) -> Result<Unit, Error> {
                    self.while(cond: cond, m: m)
                }

                return bind(m(()), f)
            }
        }

        func `for`<T, U>(seq: [T], body: (T) -> Result<U, Error>) -> Result<Unit, Error> {

            var iter = seq.makeIterator()

            guard let next = iter.next() else {
                fatalError()
            }

            return self.using(res: next) { val -> Result<Unit, Error> in

                let m: (Unit) -> Result<U, Error> = { _ in
                    body(val)
                }

                let cond: (Unit) -> Bool = { _ in
                    iter.next() == nil ? false : true
                }

                return self.while(cond: cond, m: m)

            }

        }

        //        member this.For(sequence:seq<_>, body) =
        //            this.Using(sequence.GetEnumerator(),
        //                (fun enum -> this.While(enum.MoveNext, fun _ -> body enum.Current)))

    }

//    let result = ResultBuilder()

    static func result<T>(
        @ResultBuilder child: () -> Result<T, Error>
    ) -> Result<T, Error> {
        return child()
    }

}
