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

final class TurtleApiLayer_FP {
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

    /// Function to log a message
    let log: (String) -> Void = { message in
        print(message)
    }

    let initialTurtleState = FPTurtle.initialTurtleState

    // convert the distance parameter to a float, or throw an exception
    static func validateDistance(_ distanceStr: String) throws -> Result<Distance, ErrorMessage> {

        guard let number = Int(distanceStr) else {
            throw ErrorMessage.InvalidDistance(distanceStr)
        }

        return Result.success(Float(number))
    }


    // convert the angle parameter to a float, or throw an exception
    static func validateAngle(_ angleStr: String) throws -> Result<Angle, ErrorMessage> {

        guard let number = Int(angleStr) else {
            throw ErrorMessage.InvalidAngle(angleStr)
        }

        return Result.success(Float(number))
    }

    // convert the color parameter to a PenColor, or throw an exception
    static func validateColor(_ colorStr: String) throws -> PenColor {
        switch colorStr {
            case "Black": return .black
            case "Blue": return .blue
            case "Red": return .red
            default: throw ErrorMessage.InvalidColor(colorStr)
        }
    }

    final class TurtleApi {

        let turtleFunctions: TurtleFunctions

        init(_ turtleFunctions: TurtleFunctions) {
            self.turtleFunctions = turtleFunctions
        }

        var state = FPTurtle.initialTurtleState

        /// Update the mutable state value
        func updateState(newState: TurtleState) {
            state = newState
        }

        /// Execute the command string, and return a Result
        /// Exec : commandStr:string -> Result<unit,ErrorMessage>
        func exec(_ commandStr: String, _ state: TurtleState) throws -> Result<Unit, ErrorMessage> {

            let tokens = commandStr
                .split(separator: " ")
                .map({ String($0) })

            guard let command = tokens.first else {
                throw ErrorMessage.InvalidCommand(commandStr)
            }

            switch command {

                case "Move":

                    let distance = try tokens
                        .filter({ $0 == "Move" })
                        .map(TurtleApiLayer_FP.validateDistance)
                        .compactMap({ try! $0.get() })

                    let newState = turtleFunctions.move(distance.first!)(state)
                    updateState(newState: newState)

                return Result.success(())


                case "Turn":

                    let distance = try tokens
                        .filter({ $0 == "Move" })
                        .map(TurtleApiLayer_FP.validateDistance)
                        .compactMap({ try! $0.get() })

                    let newState = turtleFunctions.move(distance.first!)(state)
                    updateState(newState: newState)

                return Result.success(())


                case "PenUp":

                    let newState = turtleFunctions.penUp(state)
                    updateState(newState: newState)

                return Result.success(())


                case "PenDown":

                    let newState = turtleFunctions.penDown(state)
                    updateState(newState: newState)

                return Result.success(())


                case "SetColor":

                    let color = try tokens.filter({ $0 == "SetColor" })
                        .map(TurtleApiLayer_FP.validateColor)
                        .first!

                    let newState = turtleFunctions.setColor(color)(state)
                    updateState(newState: newState)

                    return Result.success(())

                default: throw ErrorMessage.InvalidCommand(commandStr)

            }


        }
    }

}

// ----------------------------
// Multiple Turtle Implementations
// ----------------------------

final class TurtleImplementation_FP {

    static let normalSize: () -> TurtleFunctions = {

        let log: (String) -> Void = { message in
            return message
        }

        return TurtleFunctions(move: FPTurtle.move(log),
                               turn: FPTurtle.turn(log),
                               penUp: FPTurtle.penUp(log),
                               penDown: FPTurtle.penDown(log),
                               setColor: FPTurtle.setColor(log))
    }

    //    let halfSize() =
    //        let normalSize = normalSize()
    //        // return a reduced turtle
    //        { normalSize with
    //            move = fun dist -> normalSize.move (dist/2.0)
    //        }

}

// ----------------------------
// Turtle Api Client
// ----------------------------

struct TurtleApiClient_FP {

    let drawTriangle: (TurtleApiLayer_FP.TurtleApi) -> Void = { api in
//        do {
//            try api.exec("Move 100")
//            try api.exec("Turn 120")
//            try api.exec("Move 100")
//            try api.exec("Turn 120")
//            try api.exec("Move 100")
//            try api.exec("Turn 120")
//        } catch let error {
//            // handle error
//        }
    }

}
//// ----------------------------
//// Turtle Api Tests  (FP style)
//// ----------------------------
//
//do

//
//do
//let turtleFns = TurtleImplementation_FP.halfSize()
//let api = TurtleApiLayer_FP.TurtleApi(turtleFns)
//TurtleApiClient_FP.drawTriangle(api)
//
//
