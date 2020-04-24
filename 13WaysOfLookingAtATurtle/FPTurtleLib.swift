//
//  FPTurtleLib.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    FPTurtleLib.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Common code for FP-style immutable turtle functions.
//
//    ======================================

// ======================================
// Turtle module
// ======================================

enum FPTurtle {

    struct TurtleState {
        let position: Position
        let angle: Degrees
        let color: PenColor
        let penState: PenState
    }

    static let initialTurtleState: TurtleState = TurtleState(position: Position(x: 0, y: 0),
                                                             angle: 0,
                                                             color: .black,
                                                             penState: .up)

    // note that state is LAST param in all these functions

    static func move(_ log: (String) -> ()) -> (Distance) -> (TurtleState) -> TurtleState {
        // calculate new position

        return { distance in
            return { state in
//                log("Move %0.1f \(distance)")
                let newPosition = calcNewPosition(distance: distance, angle: state.angle, currentPos: state.position)
                // draw line if needed
                if state.penState == .down {
//                    dummyDrawLine(log, state.position, newPosition, state.color)
                }
                // update the state
                return TurtleState(position: newPosition,
                                   angle: state.angle,
                                   color: state.color,
                                   penState: state.penState)
            }
        }

    }

    static func turn(_ log: (String) -> ()) -> (Angle) -> (TurtleState) -> TurtleState {
        // calculate new angle
        return { angle in
            return { state in
//                log("Turn %0.1f \(angle)")
                let newAngle = (state.angle + angle).truncatingRemainder(dividingBy: 360)
                // update the state
                return TurtleState(position: state.position, angle: newAngle, color: state.color, penState: state.penState)
            }
        }
    }

    static func penUp(_ log: (String) -> ()) -> (TurtleState) -> TurtleState {
        log("Pen up")
        return { state in
            return TurtleState(position: state.position,
                               angle: state.angle,
                               color: state.color,
                               penState: .up)
        }
    }

    static func penDown(_ log: (String) -> ()) -> (TurtleState) -> TurtleState {
        log("Pen up")
        return { state in
            return TurtleState(position: state.position,
                               angle: state.angle,
                               color: state.color,
                               penState: .down)
        }
    }

    static func setColor(_ log: (String) -> ()) -> (PenColor) -> (TurtleState) -> TurtleState {
        return { color in
            return { state in
//                log("SetColor %A \(color)")
                return TurtleState(position: state.position,
                                   angle: state.angle,
                                   color: color,
                                   penState: state.penState)
            }
        }
    }
}

