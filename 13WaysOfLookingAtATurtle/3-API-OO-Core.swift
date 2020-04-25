//
//  3-API-OO-Core.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

//    ======================================
//    03-Api_OO_Core.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #3: API (OO Approach) -- OO API calling stateful core class
//
//    In this design, an API layer communicates with a turtle class
//    and the client talks to the API layer.
//
//    The input to the API are strings, and so the API validates the
//    input and returns a Result containing any errors.
//
//    ======================================


// ======================================
// Turtle Api Layer
// ======================================


/// Define the exception for API errors
enum TurtleApiException: Error {
    case exception(_ message: String)
}

enum TurtleApiLayer {

    /// Function to log a message
    static let log: (String) -> () = { message in
        print(String(format: "%s", message))
    }

    struct TurtleApi {

        let turtle = Turtle(log)

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
            let tokens = commandStr.split(separator: " ").map({ String($0) })

            try tokens
                .filter({ $0 == "Move" })
                .map(TurtleApi.validateDistance)
                .forEach(turtle.move)

            try tokens.filter({ $0 == "Turn" })
                .map(TurtleApi.validateDistance)
                .forEach(turtle.move)

            try tokens.filter({ $0 == "Angle" })
                .map(TurtleApi.validateAngle)
                .forEach(turtle.move)

            tokens.filter({ $0 == "PenUp" })
                .forEach({ _ in turtle.penUp() })

            tokens.filter({ $0 == "PenDown" })
                .forEach({ _ in turtle.penDown() })

            try tokens.filter({ $0 == "SetColor" })
                .map(TurtleApi.validateDistance)
                .forEach(turtle.move)

        }
    }
}

// ======================================
// Turtle Api Client
// ======================================

final class TurtleApiClient {

    static let drawTriangle = {

        let api = TurtleApiLayer.TurtleApi()

        do {
            try api.exec("Move 100")
            try api.exec("Turn 120")
            try api.exec("Move 100")
            try api.exec("Turn 120")
            try api.exec("Move 100")
            try api.exec("Turn 120")
            // back home at (0,0) with angle 0
        } catch let error {
            TurtleApiClient.triggerError(error)
        }

    }

    static let drawThreeLines = {

        let api = TurtleApiLayer.TurtleApi()

        do {
            // draw black line
            try api.exec("Pen Down")
            try api.exec("SetColor Black")
            try api.exec("Move 100")
            // move without drawing
            try api.exec("Pen Up")
            try api.exec("Turn 90")
            try api.exec("Move 100")
            try api.exec("Turn 90")
            // draw red line
            try api.exec("Pen Down")
            try api.exec("SetColor Red")
            try api.exec("Move 100")
            // move without drawing
            try api.exec("Pen Up")
            try api.exec("Turn 90")
            try api.exec("Move 100")
            try api.exec("Turn 90")
            // back home at (0,0) with angle 0
            // draw diagonal blue line
            try api.exec("Pen Down")
            try api.exec("SetColor Blue")
            try api.exec("Turn 45")
            try api.exec("Move 100")
        } catch let error {
            TurtleApiClient.triggerError(error)
        }

    }


    static let drawPolygon: (Float) -> Void = { n in

        let angle = 180.0 - (360.0 / n)
        let api = TurtleApiLayer.TurtleApi()

        // define a function that draws one side
        let drawOneSide: () -> Void = {
            do {
                try api.exec("Move 100.0")
                try api.exec("Turn %f \(angle)")
            } catch let error {
                TurtleApiClient.triggerError(error)
            }
        }

        // repeat for all sides
        for i in [1..<n] {
            drawOneSide()
        }

    }

    static let triggerError: (Error) -> Void = { error in
        // handle error to be displayed to the user
        print(error.localizedDescription)
    }

}

