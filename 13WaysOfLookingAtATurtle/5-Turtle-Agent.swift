//
//  5-Turtle-Agent.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation
import Runes

//    ======================================
//    05-TurtleAgent.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #5: API (hybrid approach) -- OO API posting messages to an Agent
//
//    In this design, an API layer communicates with a TurtleAgent
//    and the client talks to the API layer.
//
//    Because the Agent has a message queue, all possible commands are managed with a
//    single discriminated union type (`TurtleCommand`).
//
//    There are no mutables anywhere. The Agent manages the turtle state by
//    storing the current state as a parameter in the recursive message processing loop.
//
//    ======================================

final class MailboxProcessor<T> {

    var inbox: [T] = []
    var state: TurtleState = FPTurtle.initialTurtleState
    var isRunning = false

    init() {
        self.isRunning = true
    }

    func start(_ c: (MailboxProcessor) -> Void) {
        isRunning = true
    }

    func receive() -> T? {
        if isRunning {
            return inbox.removeLast()
        } else {
            return nil
        }
    }

    func post(_ command: T) {
        if isRunning {
            inbox.append(command)
        }
    }
}

// ======================================
// MARK: Agent Implementation
// ======================================

final class AgentImplementation {

    enum TurtleCommand {
        case move(_ distance: Distance)
        case turn(_ angle: Angle)
        case penUp
        case penDown
        case setColor(_ color: PenColor)
    }

    // --------------------------------------
    // MARK: The Agent
    // --------------------------------------

    struct TurtleAgent {

        /// Function to log a message
        static let log: (String) -> Void = { message in print(message) }

        // logged versions
        static let move = FPTurtle.move(log)
        static let turn = FPTurtle.turn(log)
        static let penDown = FPTurtle.penDown(log)
        static let penUp = FPTurtle.penUp(log)
        static let setColor = FPTurtle.setColor(log)

        static let mailboxProc = MailboxProcessor<TurtleCommand>()

        let process: () = mailboxProc.start { inbox in

            while inbox.isRunning {

                let command = inbox.receive()!
                let state = inbox.state

                // create a new state from handling the message
                let nState = matchCommandState(command, state)

            }
        }

        // expose the queue externally
        func post(_ command: TurtleCommand) {
            AgentImplementation.TurtleAgent.mailboxProc.post(command)
        }

        static private func matchCommandState(_ command: TurtleCommand,
                                              _ state: TurtleState) -> TurtleState {
            switch command {
            case .move(let distance):
                return state |> AgentImplementation.TurtleAgent.move(distance)
            case .turn(let angle):
                return state |> AgentImplementation.TurtleAgent.turn(angle)
            case .penUp:
                return state |> AgentImplementation.TurtleAgent.penUp
            case .penDown:
                return state |> AgentImplementation.TurtleAgent.penDown
            case .setColor(let color):
                return state |> AgentImplementation.TurtleAgent.setColor(color)
            }
        }
    }
}

// ======================================
// Turtle Api Layer
// ======================================

final class TurtleApiLayerAgent {

    let turtleAgent = AgentImplementation.TurtleAgent()

    static let validateDistance: (String) -> Result<Distance, Error> = { distanceStr in

        guard let number = Int(distanceStr) else {
            return Result.failure(ErrorMessage.InvalidDistance(distanceStr))
        }

        return Result.success(Float(number))

    }

    static let validateAngle: (String) -> Result<Angle, Error> = { angleStr in

        guard let number = Int(angleStr) else {
            return Result.failure(ErrorMessage.InvalidAngle(angleStr))
        }

        return Result.success(Float(number))

    }

    static let validateColor: (String) -> Result<PenColor, Error> = { colorStr in

        switch colorStr {
        case "Black": return Result.success(PenColor.black)
        case "Blue": return Result.success(PenColor.blue)
        case "Red": return Result.success(PenColor.red)
        default: return Result.failure(ErrorMessage.InvalidColor(colorStr))
        }

    }

    /// Execute the command string, and return a Result
    /// Exec : commandStr:string -> Result<unit,ErrorMessage>
    func exec() -> (String) -> Result<Unit, Error> {

        return { commandStr in

            self.turtleAgent.process

            let tokens = commandStr
                .split(separator: " ")
                .map({ String($0) })

            let command = tokens.count > 0 ? tokens[0] : ""
            let commandValue = tokens.count == 1 ? "" : tokens[1]

            switch command {

            case TurtleCommands.move.rawValue:

                let distance = try! TurtleApiLayerAgent.validateDistance(commandValue).get()
                let command = AgentImplementation.TurtleCommand.move(distance)

                return Result.success(self.turtleAgent.post(command))

            case TurtleCommands.turn.rawValue:

                let angle = try! TurtleApiLayerAgent.validateAngle(commandValue).get()
                let command = AgentImplementation.TurtleCommand.turn(angle)

                return Result.success(self.turtleAgent.post(command))

            case TurtleCommands.penUp.rawValue:

                let command = AgentImplementation.TurtleCommand.penUp
                return Result.success(self.turtleAgent.post(command))

            case TurtleCommands.penDown.rawValue:

                let command = AgentImplementation.TurtleCommand.penDown
                return Result.success(self.turtleAgent.post(command))

            case TurtleCommands.setColor.rawValue:

                let color = try! TurtleApiLayerAgent.validateColor(commandValue).get()
                let command = AgentImplementation.TurtleCommand.setColor(color)

                return Result.success(self.turtleAgent.post(command))

            default:
                fatalError()
            }
        }
    }
}

// ======================================
// Turtle Api Client
// ======================================

final class TurtleApiClientAgent {

    let drawTriangle: () -> Void = {
        let api = TurtleApiLayerAgent()

        let res: Result<Unit, Error> = ResultModule.result {
            "Move 100" |> api.exec()
            "Turn 120" |> api.exec()
            "Move 100" |> api.exec()
            "Turn 120" |> api.exec()
            "Move 100" |> api.exec()
            "Turn 120" |> api.exec()
        }
        // back home at (0,0) with angle 0

    }

    //
    //    let drawThreeLines() =
    //        let api = TurtleApi()
    //        result {
    //
    //        // draw black line
    //        do! api.Exec "Pen Down"
    //        do! api.Exec "SetColor Black"
    //        do! api.Exec "Move 100"
    //        // move without drawing
    //        do! api.Exec "Pen Up"
    //        do! api.Exec "Turn 90"
    //        do! api.Exec "Move 100"
    //        do! api.Exec "Turn 90"
    //        // draw red line
    //        do! api.Exec "Pen Down"
    //        do! api.Exec "SetColor Red"
    //        do! api.Exec "Move 100"
    //        // move without drawing
    //        do! api.Exec "Pen Up"
    //        do! api.Exec "Turn 90"
    //        do! api.Exec "Move 100"
    //        do! api.Exec "Turn 90"
    //        // back home at (0,0) with angle 0
    //        // draw diagonal blue line
    //        do! api.Exec "Pen Down"
    //        do! api.Exec "SetColor Blue"
    //        do! api.Exec "Turn 45"
    //        do! api.Exec "Move 100"
    //        }
    //
    //    let drawPolygon n =
    //        let angle = 180.0 - (360.0/float n)
    //        let api = TurtleApi()
    //
    //        // define a function that draws one side
    //        let drawOneSide() = result {
    //            do! api.Exec "Move 100.0"
    //            do! api.Exec (sprintf "Turn %f" angle)
    //            }
    //
    //        // repeat for all sides
    //        for i in [1..n] do
    //            drawOneSide() |> ignore
    //
    //    let triggerError() =
    //        let api = TurtleApi()
    //        api.Exec "Move bad"

}
