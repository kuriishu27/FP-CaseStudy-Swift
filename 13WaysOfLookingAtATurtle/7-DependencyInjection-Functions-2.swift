//
//  7-DependencyInjection-Functions-2.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    07-DependencyInjection_Functions-2.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #7: Dependency injection using functions (v2: pass in a single function)

//    In this design, an API layer communicates via one or more functions that are passed in as parameters to the API call.
//    These functions are typically partially applied so that the call site is decoupled from the "injection"
//
//    No interface is passed to the constructor.
//
//
//
//    ======================================

// ======================================
// Turtle Api -- Pass in a single function
// ======================================

final class TurtleApiPassInSingleFunctions {

    enum TurtleCommand {
        case move(_ distance: Distance)
        case turn(_ angle: Angle)
        case penUp
        case penDown
        case setColor(_ color: PenColor)
    }

    // No functions in constructor
    final class TurtleApi {

        private var state = FPTurtle.initialTurtleState

        /// Update the mutable state value
        private func updateState(newState: FPTurtle.TurtleState) {
            self.state = newState
        }

        /// Execute the command string, and return a Result
        /// Exec : commandStr:string -> Result<unit,ErrorMessage>
        func exec(_ turtleFn: @escaping (TurtleCommand) -> (TurtleState) -> TurtleState)
                        -> (String) -> Result<Unit, ErrorMessage> {

            return { commandStr in

                let tokens = commandStr
                    .split(separator: " ")
                    .map({ [String($0)] })
                    .flatMap({ $0 })

                let command = tokens.count > 0 ? tokens[0] : ""
                let commandValue = tokens.count == 1 ? "" : tokens[1]

                switch command {

                case TurtleCommands.move.rawValue:

                    let distance = try! TurtleApiLayerFP.validateDistance(commandValue).get()

                    let command = TurtleCommand.move(distance)
                    let newState = turtleFn(command)(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.turn.rawValue:

                    let angle = try! TurtleApiLayerFP.validateAngle(commandValue).get()

                    let command = TurtleCommand.turn(angle)
                    let newState = turtleFn(command)(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.penUp.rawValue:

                    let command = TurtleCommand.penUp
                    let newState = turtleFn(command)(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.penDown.rawValue:

                    let command = TurtleCommand.penDown
                    let newState = turtleFn(command)(self.state)

                    return Result.success(self.updateState(newState: newState))

                case TurtleCommands.setColor.rawValue:

                    let color = try! TurtleApiLayerFP.validateColor(commandValue).get()

                    let command = TurtleCommand.setColor(color)
                    let newState = turtleFn(command)(self.state)

                    return Result.success(self.updateState(newState: newState))

                default:
                    return Result<Unit, ErrorMessage>
                        .failure(ErrorMessage.InvalidCommand("Invalid command: \(commandStr)"))
                }

            }

        }
    }
}

// -----------------------------
// -MARK: Turtle Implementations for "Pass in a single function" design
// -----------------------------

private typealias TurtleApi = TurtleApiPassInSingleFunctions.TurtleApi

struct ImplementationPassInSingleFunctions {

    static let log: (String) -> Void = { message in
        print(message)
    }

    static let move = FPTurtle.move(log)
    static let turn = FPTurtle.turn(log)
    static let penUp = FPTurtle.penUp(log)
    static let penDown = FPTurtle.penDown(log)
    static let setColor = FPTurtle.setColor(log)

    let normalSize: () -> (String) -> Result<Unit, ErrorMessage> = {

        let api = TurtleApi()

        let turtleFn: (TurtleApiPassInSingleFunctions.TurtleCommand) -> (TurtleState) -> TurtleState = { command in
            switch command {
            case .move(let dist): return move(dist)
            case .turn(let angle): return turn(angle)
            case .penUp: return penUp
            case .penDown: return penDown
            case .setColor(let color): return setColor(color)
            }
        }

        return api.exec(turtleFn)

    }

    let halfSize: () -> (String) -> Result<Unit, ErrorMessage> = {

        let api = TurtleApi()

        let moveHalf: (Distance) -> ((TurtleState) -> TurtleState) = { distance in
            return move(distance / 2)
        }

        let turtleFn: (TurtleApiPassInSingleFunctions.TurtleCommand) -> (TurtleState) -> TurtleState = { command in
            switch command {
            case .move(let dist): return move(dist)
            case .turn(let angle): return turn(angle)
            case .penUp: return penUp
            case .penDown: return penDown
            case .setColor(let color): return setColor(color)
            }
        }

        return api.exec(turtleFn)

    }

}

// -----------------------------
// - MARK: Turtle API Client for "Pass in a single function" design
// -----------------------------

struct TurtleApiClientPassInSingleFunctions {

    typealias ApiFunction = (String) -> Result<Unit, ErrorMessage>

    static func drawTriangle(api: ApiFunction) {

        do {
            try api("PenUp").get()
            try api("SetColor Blue").get()
            try api("Move 100").get()
            try api("Turn 120").get()
            try api("Move 100").get()
            try api("Turn 120").get()
            try api("Move 100").get()
            try api("Turn 120").get()
            try api("SetColor Red").get()
            try api("PenDown").get()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
