//
//  6-DependencyInjection-Interface-2.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    06-DependencyInjection_Interface.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #6: Dependency injection (using interfaces) - v2: records of functions
//
//    In this design, an API layer communicates with a Turtle Interface (OO style) or a record of TurtleFunctions (FP style)
//    rather than directly with a turtle.
//    The client injects a specific turtle implementation via the API's constructor.
//
//    ======================================

// ============================================================================
// Dependency Injection (records of functions)
// ============================================================================

// ----------------------------
// Turtle Interface
// ----------------------------

// a quick alias for readability
typealias TurtleState = FPTurtle.TurtleState

struct TurtleFunctions {
    let move: (Distance) -> (TurtleState) -> TurtleState
    let turn: (Angle) -> (TurtleState) -> TurtleState
    let penUp: (TurtleState) -> TurtleState
    let penDown: (TurtleState) -> TurtleState
    let setColor: (PenColor) -> (TurtleState) -> TurtleState
}
// Note that there are NO "units" in these functions, unlike the OO version.

// ----------------------------
// Turtle Api Layer
// ----------------------------

enum ErrorMessage: Error {
    case InvalidDistance(_: String)
    case InvalidAngle(_: String)
    case InvalidColor(_: String)
    case InvalidCommand(_: String)
}

extension ErrorMessage: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .InvalidDistance(let message):
            return "Invalid distance: \(message)"
        case .InvalidAngle(let message):
            return "Invalid angle: \(message)"
        case .InvalidColor(let message):
            return "Invalid color: \(message)"
        case .InvalidCommand(let message):
            return "Invalid command: \(message)"
        }
    }

    var errorDescription: String? {
        switch self {
        case .InvalidDistance(let message):
            return "Invalid distance: \(message)"
        case .InvalidAngle(let message):
            return "Invalid angle: \(message)"
        case .InvalidColor(let message):
            return "Invalid color: \(message)"
        case .InvalidCommand(let message):
            return "Invalid command: \(message)"
        }
    }
}

final class TurtleApiLayerFP {

    /// Function to log a message
    let log: (String) -> Void = { message in
        print(message)
    }

    static let initialTurtleState = FPTurtle.initialTurtleState

    // convert the distance parameter to a float, or throw an exception
    static let validateDistance: (String) -> Result<Distance, Error> = { distanceStr in

        guard let number = Int(distanceStr) else {
            return Result.failure(ErrorMessage.InvalidDistance(distanceStr))
        }

        return Result.success(Float(number))

    }

    // convert the angle parameter to a float, or throw an exception
    static let validateAngle: (String) -> Result<Angle, Error> = { angleStr in

        guard let number = Int(angleStr) else {
            return Result.failure(ErrorMessage.InvalidAngle(angleStr))
        }

        return Result.success(Float(number))

    }

    // convert the color parameter to a PenColor, or throw an exception
    static let validateColor: (String) -> Result<PenColor, Error> = { colorStr in

        switch colorStr {
        case "Black": return Result.success(PenColor.black)
        case "Blue": return Result.success(PenColor.blue)
        case "Red": return Result.success(PenColor.red)
        default: return Result.failure(ErrorMessage.InvalidColor(colorStr))
        }

    }

    final class TurtleApi {

        let turtleFunctions: TurtleFunctions

        init(_ turtleFunctions: TurtleFunctions) {
            self.turtleFunctions = turtleFunctions
        }

        private var state = initialTurtleState

        /// Update the mutable state value
        private func updateState(newState: TurtleState) {
            state = newState
        }

        /// Execute the command string, and return a Result
        /// exec: (commandStr: String) -> (state: TurtleState) -> Result<Unit, ErrorMessage>
        func exec() -> (String) -> Result<Unit, ErrorMessage> {

            return { commandStr in

                let tokens = commandStr
                    .split(separator: " ")
                    .map({ String($0) })

                let command = tokens.count > 0 ? tokens[0] : ""
                let commandValue = tokens.count == 1 ? "" : tokens[1]

                switch command {

                case TurtleCommands.move.rawValue:

                    let distance = try! validateDistance(commandValue).get()
                    let newState = self.turtleFunctions.move(distance)(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.turn.rawValue:

                    let angle = try! validateAngle(commandValue).get()
                    let newState = self.turtleFunctions.turn(angle)(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.penUp.rawValue:

                    let newState = self.turtleFunctions.penUp(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.penDown.rawValue:

                    let newState = self.turtleFunctions.penDown(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.setColor.rawValue:

                    let color = try! validateColor(commandValue).get()
                    let newState = self.turtleFunctions.setColor(color)(self.state)

                    return Result.success(self.updateState(newState: newState))

                default:
                    return Result<Unit, ErrorMessage>
                        .failure(ErrorMessage.InvalidCommand(commandStr))

                }
            }
        }
    }

}

// ----------------------------
// Multiple Turtle Implementations
// ----------------------------

final class TurtleImplementationFP {

    static let log: (String) -> Void = { message in
        print(message)
    }

    static let normalSize: () -> TurtleFunctions = {

        return TurtleFunctions(move: FPTurtle.move(log),
                               turn: FPTurtle.turn(log),
                               penUp: FPTurtle.penUp(log),
                               penDown: FPTurtle.penDown(log),
                               setColor: FPTurtle.setColor(log))
    }

    static let halfSize: () -> TurtleFunctions = {

        let normalSize = TurtleImplementationFP.normalSize()

        let moveHalf: (Distance) -> (TurtleState) -> TurtleState = { distance in
            return normalSize.move(distance / 2)
        }

        return TurtleFunctions(move: moveHalf,
                               turn: normalSize.turn,
                               penUp: normalSize.penUp,
                               penDown: normalSize.penDown,
                               setColor: normalSize.setColor)

    }

}

// ----------------------------
// Turtle Api Client
// ----------------------------

struct TurtleApiClientFP {

    let drawTriangle: (TurtleApiLayerFP.TurtleApi) -> Void = { api in
        _ = api.exec()("PenDown")
        _ = api.exec()("SetColor Blue")
        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 120")
        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 120")
        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 120")
        _ = api.exec()("PenUp")
    }

}
