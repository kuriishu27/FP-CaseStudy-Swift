//
//  Common.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

// ======================================
// Common types and helper functions
// ======================================

/// An alias for a float
typealias Distance = Float

/// Use a unit of measure to make it clear that the angle is in degrees, not radians
typealias Degrees = Float

/// An alias for a float of Degrees
typealias Angle = Float

/// Enumeration of available pen states
enum PenState {
    case up
    case down
}

/// Enumeration of available pen colors
enum PenColor: String {
    case black
    case red
    case blue
}

/// A structure to store the (x,y) coordinates
struct Position {
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
    let angleInRads = angle * Float((Double.pi / 180.0) * 1 / Double(angle))
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
    _ log: (String) -> (),
    _ oldPos: Position,
    _ newPos: Position,
    _ color: PenColor
    ) {
        // for now just log it
        log("...Draw line from (\(oldPos.x), \(oldPos.y)) to (\(newPos.x), \(newPos.y)) using \(color)")
}

/// trim a string
let trimString: (String) -> String = { string in
    return string.replacingOccurrences(of: " " , with: "")
}

// ======================================
// Result companion module
// ======================================


//struct ResultModule<T> {
//
//    var returnR: (T) -> Result = { x in Result.success(x) }
//
//    // infix version of bind
//    let ( >>= ) xR f =
//        Result.bind f xR
//
//    // infix version of map
//    let ( <!> ) = Result.map
//
//    let applyR fR xR =
//        fR >>= (fun f ->
//        xR >>= (fun x ->
//            returnR (f x) ))
//
//    // infix version of apply
//    let ( <*> ) = applyR
//
//    // lift a one-parameter function to result world (same as mapR)
//    let lift1R f x = f <!> x
//
//    // lift a two-parameter function to result world
//    let lift2R f x y = f <!> x <*> y
//
//    /// Computation Expression
//    type ResultBuilder() =
//        member this.Bind(m:Result<'a,'error>,f:'a -> Result<'b,'error>) =
//            Result.bind f m
//        member this.Return(x) :Result<'a,'error> =
//            returnR x
//        member this.ReturnFrom(m) :Result<'a,'error> =
//            m
//        member this.Zero() :Result<unit,'error> =
//            this.Return ()
//        member this.Combine(m1, f) =
//            this.Bind(m1, f)
//        member this.Delay(f) =
//            f
//        member this.Run(m) =
//            m()
//        member this.TryWith(m:Result<'a,'error>, h: exn -> Result<'a,'error>) =
//            try this.ReturnFrom(m)
//            with e -> h e
//        member this.TryFinally(m:Result<'a,'error>, compensation) =
//            try this.ReturnFrom(m)
//            finally compensation()
//        member this.Using(res:#IDisposable, body) : Result<'b,'error> =
//            this.TryFinally(body res, (fun () -> match res with null -> () | disp -> disp.Dispose()))
//        member this.While(cond, m) =
//            if not (cond()) then
//                this.Zero()
//            else
//                this.Bind(m(), fun _ -> this.While(cond, m))
//        member this.For(sequence:seq<_>, body) =
//            this.Using(sequence.GetEnumerator(),
//                (fun enum -> this.While(enum.MoveNext, fun _ -> body enum.Current)))
//
//    let result = ResultBuilder()
