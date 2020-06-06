//
//  4-API-FP-Core.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    04-Api_FP_Core.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #4: 4: API (OO/FP hybrid approach) -- OO API calling stateless functions
//
//    In this design, an API layer communicates with pure turtle functions
//    and the client talks to the API layer.
//
//    The API layer manages the state (rather than the client) by storing a mutable turtle state.
//
//    *This approach has been named "Functional Core/Imperative Shell" by [Gary Bernhardt](https://www.youtube.com/watch?v=yTkzNHF6rMs)*
//
//    ======================================

// ======================================
// Turtle Api Layer
// ======================================

final class FPTurtleApiLayer {

    /// Function to log a message
    static let log: (String) -> Void = { message in
        print(message)
    }

    // logged versions
    static let move = FPTurtle.move(log)
    static let turn = FPTurtle.turn(log)
    static let penDown = FPTurtle.penDown(log)
    static let penUp = FPTurtle.penUp(log)
    static let setColor = FPTurtle.setColor(log)

    final class FPTurtleApi {

        private var state = FPTurtle.initialTurtleState

        /// Update the mutable state value
        private func updateState(newState: TurtleState) {
            state = newState
        }

        let validateDistance: (String) -> Result<Distance, Error> = { distanceStr in

            guard let number = Int(distanceStr) else {
                return Result.failure(ErrorMessage.InvalidDistance(distanceStr))
            }

            return Result.success(Float(number))

        }

        let validateAngle: (String) -> Result<Angle, Error> = { angleStr in

            guard let number = Int(angleStr) else {
                return Result.failure(ErrorMessage.InvalidAngle(angleStr))
            }

            return Result.success(Float(number))

        }

        let validateColor: (String) -> Result<PenColor, Error> = { colorStr in

            switch colorStr {
            case "Black": return Result.success(PenColor.black)
            case "Blue": return Result.success(PenColor.blue)
            case "Red": return Result.success(PenColor.red)
            default: return Result.failure(ErrorMessage.InvalidColor(colorStr))
            }

        }

        /// Execute the command string, and return a Result
        /// Exec : commandStr:string -> Result<unit,ErrorMessage>
        public func exec() -> (String) -> Result<Unit, Error> {

            return { commandStr in

                let tokens = commandStr
                    .split(separator: " ")
                    .map({ String($0) })
                    .map(trimString)

                // lift current state to Result
                let stateR = ResultModule.returnR(self.state)

                // calculate the new state
                let newStateR: Result<TurtleState, Error> = self.calculateNewStateR(tokens, stateR)

                // Lift `updateState` into the world of Results and
                // call it with the new state.
                return newStateR.map(self.updateState)

                // Return the final result (output of updateState)

            }

        }

        private func calculateNewStateR(_ tokens: [String],
                                        _ stateR: Result<TurtleState, Error>) -> Result<TurtleState, Error> {

            let command = tokens.count > 0 ? tokens[0] : ""
            let commandValue = tokens.count == 1 ? "" : tokens[1]

            switch command {
            case TurtleCommands.move.rawValue:

                let distanceR = validateDistance(commandValue)
                return ResultModule.lift2R(move, distanceR, stateR)

            case TurtleCommands.turn.rawValue:

                let angleR = validateAngle(commandValue)
                return ResultModule.lift2R(turn, angleR, stateR)

            case TurtleCommands.penUp.rawValue: return ResultModule.returnR(penUp(state))
            case TurtleCommands.penDown.rawValue: return ResultModule.returnR(penDown(state))

            case TurtleCommands.setColor.rawValue:

                let colorR = validateColor(commandValue)
                return ResultModule.lift2R(setColor, colorR, stateR)

            default: return Result.failure(ErrorMessage.InvalidCommand("Invalid command"))

            }
        }

    }
}

// ======================================
// Turtle Api Client
// ======================================

final class FPTurtleApiClient {

    typealias TurtleApi = FPTurtleApiLayer.FPTurtleApi

    let drawTriangle: () -> Void = {

        let api = TurtleApi()

        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 120")
        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 120")
        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 120")
        // back home at (0,0) with angle 0
    }

    let drawThreeLines: () -> Void = {

        let api = TurtleApi()

        // draw black line
        _ = api.exec()("PenDown")
        _ = api.exec()("SetColor Black")
        _ = api.exec()("Move 100")
//        trymove without drawing
        _ = api.exec()("PenUp")
        _ = api.exec()("Turn 90")
        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 90")
//        trydraw red line
        _ = api.exec()("PenDown")
        _ = api.exec()("SetColor Red")
        _ = api.exec()("Move 100")
//        trymove without drawing
        _ = api.exec()("PenUp")
        _ = api.exec()("Turn 90")
        _ = api.exec()("Move 100")
        _ = api.exec()("Turn 90")
//        tryback home at (0,0) with angle 0
//        trydraw diagonal blue line
        _ = api.exec()("PenDown")
        _ = api.exec()("SetColor Blue")
        _ = api.exec()("Turn 45")
        _ = api.exec()("Move 100")
    }

    let drawPolygon: (Float) -> Void = { n in
        let angle = 180.0 - (360.0 / n)

        let api = TurtleApi()

        // define a function that draws one side
        let drawOneSide: () -> Void = {
            _ = api.exec()("Move 100")
            _ = api.exec()("Turn \(angle)")
        }

        // repeat for all sides
        for i in [1..<n] {
            drawOneSide()
        }
    }

    let triggerError: () -> Result<Unit, Error> = {
        let api = TurtleApi()
        return api.exec()("Move bad")
    }

}
