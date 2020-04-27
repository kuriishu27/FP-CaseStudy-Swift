//
//  6-DependencyInjection-Interface-1.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    06-DependencyInjection_Interface-1.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #6: Dependency injection (using interfaces) -- v1: OO interface
//
//    In this design, an API layer communicates with a Turtle Interface (OO style) or a record of TurtleFunctions (FP style)
//    rather than directly with a turtle.
//    The client injects a specific turtle implementation via the API's constructor.
//
//    ======================================

// ============================================================================
// Dependency Injection (OO style)
// ============================================================================

// ----------------------------
// - MARK: Turtle Interface
// ----------------------------

typealias Unit = Void

protocol ITurtle {
    var move: (Distance) -> Unit { get }
    var turn: (Angle) -> Unit { get }
    var penUp: () -> Unit { get }
    var penDown: () -> Unit { get }
    var setColor: (PenColor) -> Unit { get }
}
    // Note that there are a lot of "units" in these functions.
    // "unit" in a function implies side effects

// ----------------------------
// - MARK: Turtle Api Layer (OO version)
// ----------------------------

final class TurtleApiLayerOO {

    /// Function to log a message
    static let log: (String) -> Void = { message in
        print(String(format: "%s", message))
    }

    // - MARK: Turtle Api
    public struct TurtleApi {

        private let turtle: ITurtle

        init(iTurtle: ITurtle) {
            self.turtle = iTurtle
        }

        // convert the distance parameter to a float, or throw an exception
        static func validateDistance(_ distanceStr: String) throws -> Distance {

            guard let number = Int(distanceStr) else {
                let msg = "Invalid distance \(distanceStr)"

                log(msg)
                throw TurtleApiException.exception(msg)
            }

            return Float(number)
        }

        // convert the angle parameter to a float<Degrees>, or throw an exception
        static func validateAngle(_ angleStr: String) throws -> Degrees {

            guard let distance = Float(angleStr) else {

                let msg = "Invalid angle \(angleStr)"

                log(msg)
                throw TurtleApiException.exception(msg)
            }

            return distance
        }

        // convert the color parameter to a PenColor, or throw an exception
        static func validateColor(_ colorStr: String) throws -> PenColor {
            switch colorStr {
            case "Black": return .black
            case "Blue": return .blue
            case "Red": return .red
            default: throw TurtleApiException.exception("Color \(colorStr) is not recognized")
            }
        }

        /// Execute the command string, or throw an exception
        /// (exec : commandStr:string -> unit)
        func exec(_ commandStr: String) throws {

            let tokens = commandStr
                .split(separator: " ")
                .map({ String($0) })

            let command = tokens.count > 0 ? tokens[0] : ""
            let commandValue = tokens.count == 1 ? "" : tokens[1]

            switch command {

            case TurtleCommands.move.rawValue:

                do {
                    let distance = try TurtleApi.validateDistance(commandValue)
                    turtle.move(distance)
                } catch let error {
                    throw error
                }

            case TurtleCommands.turn.rawValue:

                do {
                    let angle = try TurtleApi.validateAngle(commandValue)
                    turtle.turn(angle)
                } catch let error {
                    throw error
                }

            case TurtleCommands.penUp.rawValue:
                turtle.penUp()

            case TurtleCommands.penDown.rawValue:
                turtle.penDown()

            case TurtleCommands.setColor.rawValue:

                do {
                    let color = try TurtleApi.validateColor(commandValue)
                    turtle.setColor(color)
                } catch let error {
                    throw error
                }

            default: throw TurtleApiException.exception("Invalid command: \(command)")

            }

        }
    }
}

// ----------------------------
// - MARK: Multiple Turtle Implementations (OO version)
// ----------------------------

extension Turtle: ITurtle {}

struct TurtleImplementationOO {

    let log: (String) -> Void = { message in
        print(message)
    }

    func normalSize() -> some ITurtle {
        // return an interface wrapped around the Turtle
        return Turtle(log)
    }

    func halfSize() -> some ITurtle {

        return Turtle(log)

        // return a decorated interface
        //            {new ITurtle with
        //                member this.Move dist = normalSize.Move (dist/2.0)  // halved!!
        //                member this.Turn angle = normalSize.Turn angle
        //                member this.PenUp() = normalSize.PenUp()
        //                member this.PenDown() = normalSize.PenDown()
        //                member this.SetColor color = normalSize.SetColor color
    }
}

// ----------------------------
// Turtle Api Client (OO version)
// ----------------------------

final class TurtleApiClientOO {

    let drawTriangle: (TurtleApiLayerOO.TurtleApi) -> Void = { api in
        do {
            try api.exec("PenDown")
            try api.exec("SetColor Blue")
            try api.exec("Move 100")
            try api.exec("Turn 120")
            try api.exec("Move 100")
            try api.exec("Turn 120")
            try api.exec("Move 100")
            try api.exec("Turn 120")
            try api.exec("PenUp")
        } catch let error {
            // handle me
        }
    }

}
