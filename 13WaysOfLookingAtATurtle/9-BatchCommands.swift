//
//  9-BatchCommands.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    09-BatchCommands.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #9: Batch oriented -- Using a list of commands
//
//    In this design, the client creates a list of `Command`s that will be intepreted later.
//    These commands are then run in sequence using the Turtle library functions.
//
//    This approach means that there is no state that needs to be persisted between calls by the client.
//
//    ======================================

// ======================================
// MARK: TurtleCommmandHandler
// ======================================

final class TurtleCommmandHandler {

    /// Function to log a message
    static let log: (String) -> Void = { message in print(message) }

    // logged versions
    static let move = FPTurtle.move(log)
    static let turn = FPTurtle.turn(log)
    static let penDown = FPTurtle.penDown(log)
    static let penUp = FPTurtle.penUp(log)
    static let setColor = FPTurtle.setColor(log)

    enum TurtleCommand {
        case move(_ distance: Distance)
        case turn(_ angle: Angle)
        case penUp
        case penDown
        case setColor(_ color: PenColor)
    }

    // --------------------------------------
    // The Command Handler
    // --------------------------------------

    /// Apply a command to the turtle state and return the new state
    static func applyCommand(state: TurtleState, command: TurtleCommand) -> TurtleState {
        switch command {
        case .move(let distance):
            return move(distance)(state)
        case .turn(let angle):
            return turn(angle)(state)
        case .penUp:
            return penUp(state)
        case .penDown:
            return penDown(state)
        case .setColor(let color):
            return setColor(color)(state)
        }
    }

    /// Run list of commands in one go
    let run: ([TurtleCommand]) -> Void = { aListOfCommands in
        _ = aListOfCommands.reduce(FPTurtle.initialTurtleState, applyCommand)
    }

}

// ======================================
// MARK: TurtleCommmandClient
// ======================================

struct TurtleCommmandClient {

    typealias TurtleCommand = TurtleCommmandHandler.TurtleCommand

    let drawTriangle: () -> Void = {
        // create the list of commands
        let commands: [TurtleCommand] = [
            .move(100),
            .turn(120),
            .move(100),
            .turn(120),
            .move(100),
            .turn(120)
        ]
        // run them
        TurtleCommmandHandler().run(commands)
    }

    let drawThreeLines: () -> Void = {
        // create the list of commands
        let commands: [TurtleCommand] = [
            // draw black line
            .penDown,
            .setColor(.black),
            .move(100),
            // move without drawing
            .penUp,
            .turn(90),
            .move(100),
            .turn(90),
            // draw red line
            .penDown,
            .setColor(.red),
            .move(100),
            // move without drawing
            .penUp,
            .turn(90),
            .move(100),
            .turn(90),
            // back home at (0,0) with angle 0
            // draw diagonal blue line
            .penDown,
            .setColor(.blue),
            .turn(45),
            .move(100)
            ]

        // run the commands
        TurtleCommmandHandler().run(commands)
    }

    let drawPolygon: (Float) -> Void = { n in
        let angle = 180.0 - (360.0 / n)
        let angleDegrees = angle * 1

        // define a function that draws one side
        let drawOneSide: (Int) -> [TurtleCommand] = { sideNumber in
            return [.move(100),
                    .turn(angleDegrees)]
        }

        // repeat for all sides
        let r = Array(1...Int(n))

        let commands = r.flatMap(drawOneSide)

        // run the commands
        TurtleCommmandHandler().run(commands)
    }

}
