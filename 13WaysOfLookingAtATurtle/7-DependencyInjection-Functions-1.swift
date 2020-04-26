//
//  6-DependencyInjection-Functions-1.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    07-DependencyInjection_Functions-1.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #7: Dependency injection using functions (v1: pass in all functions)
//
//    In this design, an API layer communicates via one or more functions that are passed in as parameters to the API call.
//    These functions are typically partially applied so that the call site is decoupled from the "injection"
//
//    No interface is passed to the constructor.
//
//
//
//    ======================================

// ======================================
// TurtleApi - all Turtle functions are passed in as parameters
// ======================================

enum TurtleCommands: String {
    case move = "Move"
    case turn = "Turn"
    case penUp = "PenUp"
    case penDown = "PenDown"
    case setColor = "SetColor"
}

final class TurtleApiPassInAllFunctions {

    // No functions in constructor
    final class TurtleApi {

        var state = FPTurtle.initialTurtleState

        /// Update the mutable state value
        func updateState(newState: FPTurtle.TurtleState) {
            self.state = newState
        }

        /// Execute the command string, and return a Result
        /// Exec : commandStr:string -> Result<unit,ErrorMessage>
        func exec(move: @escaping (Distance) -> (TurtleState) -> TurtleState,
                  turn: @escaping (Angle) -> (TurtleState) -> TurtleState,
                  penUp: @escaping (TurtleState) -> TurtleState,
                  penDown: @escaping (TurtleState) -> TurtleState,
                  setColor: @escaping (PenColor) -> (TurtleState) -> TurtleState)

            throws -> (String) throws -> Result<Unit, ErrorMessage> {

                return { commandStr in

                    let tokens = commandStr
                        .split(separator: " ")
                        .map({ [String($0)] })
                        .flatMap({ $0 })

                    guard let command = tokens.first else {
                        throw ErrorMessage.InvalidCommand(commandStr)
                    }

                    switch command {

                    case TurtleCommands.move.rawValue:

                        let distance = try tokens
                            .filter({ $0 == TurtleCommands.move.rawValue })
                            .map(TurtleApiLayerFP.validateDistance)
                            .compactMap({ try $0.get() })
                            .first ?? 0

                        let newState = move(distance)(self.state)
                        self.updateState(newState: newState)

                        return Result.success(())

                    case TurtleCommands.turn.rawValue:

                        let distance = try tokens
                            .filter({ $0 == TurtleCommands.turn.rawValue })
                            .map(TurtleApiLayerFP.validateAngle)
                            .compactMap({ try $0.get() })
                            .first ?? 0

                        let newState = move(distance)(self.state)
                        self.updateState(newState: newState)

                        return Result.success(())

                    case TurtleCommands.penUp.rawValue:

                        let newState = penUp(self.state)
                        self.updateState(newState: newState)

                        return Result.success(())

                    case TurtleCommands.penDown.rawValue:

                        let newState = penDown(self.state)
                        self.updateState(newState: newState)

                        return Result.success(())

                    case TurtleCommands.setColor.rawValue:

                        let color = try tokens.filter({ $0 == TurtleCommands.setColor.rawValue })
                            .map(TurtleApiLayerFP.validateColor)
                            .first!

                        let newState = setColor(color)(self.state)
                        self.updateState(newState: newState)

                        return Result.success(())

                    default: throw ErrorMessage.InvalidCommand(commandStr)

                    }
                }

        }
    }
}

// -----------------------------
// Turtle Implementations for "Pass in all functions" design
// -----------------------------

private typealias TurtleApi = TurtleApiPassInAllFunctions.TurtleApi

struct TurtleImplementationPassInAllFunctions {

    static let log: (String) -> Void = { message in
        print(message)
    }

    static let move = FPTurtle.move(log)
    static let turn = FPTurtle.turn(log)
    static let penUp = FPTurtle.penUp(log)
    static let penDown = FPTurtle.penDown(log)
    static let setColor = FPTurtle.setColor(log)

    // the return value is a function:
    //     String -> Result<Unit,ErrorMessage>
    static let normalSize: () -> (String) throws -> Result<Unit, ErrorMessage> = {

        let api = TurtleApi()
        // partially apply the functions
        do {
            let result = try api.exec(move: move, turn: turn, penUp: penUp, penDown: penDown, setColor: setColor)
            return result
        } catch let error {
            // handle error
        }

        return { str in
            Result.failure(ErrorMessage.InvalidCommand("Unknown error"))
        }

    }
    // the return value is a function:
    //     String -> Result<Unit,ErrorMessage>
    static let halfSize: () -> (String) throws -> Result<Unit, ErrorMessage> = {

        let moveHalf: (Distance) -> ((TurtleState) -> TurtleState) = { distance in
            return move(distance / 2)
        }

        let api = TurtleApi()
        // partially apply the functions
        do {
            let result = try api.exec(move: moveHalf, turn: turn, penUp: penUp, penDown: penDown, setColor: setColor)
            return result
        } catch let error {
            // handle error
        }

        return { str in
            Result.failure(ErrorMessage.InvalidCommand("Unknown error"))
        }
    }

}

// -----------------------------
// Turtle API Client for "Pass in all functions" design
// -----------------------------

struct TurtleApiClientPassInAllFunctions {

    // the API type is just a function
    typealias ApiFunction = (String) throws -> Result<Unit, ErrorMessage>

    static func drawTriangle(api: ApiFunction, completion: () -> Void) {
//        ResultModule.result.returnFrom(m: <#T##Result<T, Error>#>)
        do {
            try api("Move 100").get()
            try api("Turn 120").get()
            try api("Move 100").get()
            try api("Turn 120").get()
            try api("Move 100").get()
            try api("Turn 120").get()

            completion()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

// -----------------------------
// Turtle Api Tests for "Pass in all functions" design
// -----------------------------

//let mockApi s =
//printfn "[MockAPI] %s" s
//Ok ()
//TurtleApiClientPassInAllFunctions.drawTriangle(mockApi)
