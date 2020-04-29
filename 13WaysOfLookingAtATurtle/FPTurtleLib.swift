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

extension TurtleState: CustomStringConvertible {
    var description: String {
        return "\n\nTURTLE STATE ---------\n\nPosition: \(position)\nAngle: \(angle)\ncolor: \(color)\nPenState: \(penState)\n\n"
    }
}

enum FPTurtle {

    struct TurtleState: Equatable {
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

    static func move(_ log: @escaping (String) -> Void) -> (Distance) -> (TurtleState) -> TurtleState {
        // calculate new position

        return { distance in
            return { state in
                log("Move \(distance)")
                let newPosition = calcNewPosition(distance: distance,
                                                  angle: state.angle,
                                                  currentPos: state.position)
                // draw line if needed
                if state.penState == .down {
                    dummyDrawLine(log, state.position, newPosition, state.color)
                }
                // update the state

                let newState = TurtleState(position: newPosition,
                                           angle: state.angle,
                                           color: state.color,
                                           penState: state.penState)

                print(newState)

                return newState
            }
        }

    }

    static func checkPosition(_ position: Position) -> (MoveResponse, Position) {

        let isOutOfBounds: (Float) -> Bool = { p in p > 100.0 || p < 0.0 }

        let bringInsideBounds: (Float) -> Float = { p in
            Float.maximum(Float.minimum(p, 100), 0)
        }

        if isOutOfBounds(position.x) || isOutOfBounds(position.y) {

            let newPos: () -> Position = {
                   let x = bringInsideBounds(position.x)
                   let y = bringInsideBounds(position.y)
                return Position(x: x, y: y)
            }
            return (MoveResponse.hitABarrier, newPos())

        } else {
            return (MoveResponse.moveOk, position)
        }
    }

    static func moveR(_ log: @escaping (String) -> Void) -> (Distance) -> (TurtleState) -> (MoveResponse, TurtleState) {
        // calculate new position

        return { distance in
            return { state in
                log("Move \(distance)")
                let (moveResponse, newPosition) = checkPosition(state.position)
                // draw line if needed
                if state.penState == .down {
                    dummyDrawLine(log, state.position, newPosition, state.color)
                }
                // update the state

                let newState = TurtleState(position: newPosition,
                                           angle: state.angle,
                                           color: state.color,
                                           penState: state.penState)

                print(newState)

                return (moveResponse, newState)
            }
        }

    }

    static func turn(_ log: @escaping (String) -> Void) -> (Angle) -> (TurtleState) -> TurtleState {
        // calculate new angle
        return { angle in
            return { state in
                log("Turn \(angle)")
                let newAngle = (state.angle + angle).truncatingRemainder(dividingBy: 360)
                // update the state
                return TurtleState(position: state.position,
                                   angle: newAngle,
                                   color: state.color,
                                   penState: state.penState)
            }
        }
    }

    static func penUp(_ log: (String) -> Void) -> (TurtleState) -> TurtleState {
        log("Pen up")
        return { state in
            return TurtleState(position: state.position,
                               angle: state.angle,
                               color: state.color,
                               penState: .up)
        }
    }

    static func penDown(_ log: (String) -> Void) -> (TurtleState) -> TurtleState {
        log("Pen down")
        return { state in
            return TurtleState(position: state.position,
                               angle: state.angle,
                               color: state.color,
                               penState: .down)
        }
    }

    static func setColor(_ log: @escaping (String) -> Void) -> (PenColor) -> (TurtleState) -> TurtleState {
        return { color in
            return { state in
                log("SetColor %A \(color)")
                return TurtleState(position: state.position,
                                   angle: state.angle,
                                   color: color,
                                   penState: state.penState)
            }
        }
    }

    static func setColorR(_ log: @escaping (String) -> Void) -> (PenColor) -> (TurtleState) -> (SetColorResponse, TurtleState) {
        return { color in
            return { state in

                let colorResult: SetColorResponse = color == .red ? .outOfInk : .colorOk
                log("SetColor \(color.rawValue)")
                // return the new state and the SetColor result

                let newState = TurtleState(position: state.position,
                                           angle: state.angle,
                                           color: color,
                                           penState: state.penState)
                return (colorResult,newState)
            }
        }
    }
}
