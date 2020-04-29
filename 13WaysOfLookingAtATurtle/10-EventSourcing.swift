//
//  10-EventSourcing.swift
//  13WaysOfLookingAtATurtle
//
//  Created by Christian Leovido on 24/04/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation
import RxSwift

//    ======================================
//    10-EventSourcing.fsx
//
//    Part of "Thirteen ways of looking at a turtle"
//    Related blog post: http://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/
//    ======================================
//
//    Way #10: Event sourcing -- Building state from a list of past events
//
//    In this design, the client sends a `Command` to a `CommandHandler`.
//    The CommandHandler converts that to a list of events and stores them in an `EventStore`.
//
//    In order to know how to process a Command, the CommandHandler builds the current state
//    from scratch using the past events associated with that particular turtle.
//
//    Neither the client nor the command handler needs to track state.  Only the EventStore is mutable.
//
//    ======================================

// ======================================
// MARK: EventStore
// ======================================

typealias EventId = String

final class EventStore<T> {

    // private mutable data
    var eventDict = [EventId: [T]]()

    let saveEvent: PublishSubject<T> = PublishSubject()

    /// Triggered when something is saved
    func saveEvent(_ element: T) {
        print(element)
        saveEvent.onNext(element)
    }
    /// save an event to storage
    func save() -> (EventId) -> (T) -> Void {

        return { eventId in
            return { event in

                if self.eventDict[eventId] != nil {
                    // store newest in front
                    self.eventDict[eventId]!.insert(event, at: 0)
                } else {
                    self.eventDict[eventId] = [event]
                    return self.saveEvent(event)
                }

                return self.saveEvent(event)

            }
        }

    }

    /// get all events associated with the specified eventId
    func get(eventId: EventId) -> [T] {

        guard let eventList = eventDict[eventId] else {
            return []
        }

        return eventList.reversed()

    }

    /// clear all events associated with the specified eventId
    func clear(eventId: EventId) {
        eventDict.removeValue(forKey: eventId)
    }

}

// ====================================
// MARK: Common types for event sourcing
// ====================================

typealias TurtleId = String

/// The type representing a function that gets the StateChangedEvents for a turtle id
/// The oldest events are first
typealias GetStateChangedEventsForId = (EventId) -> [StateChangedEvent]

/// The type representing a function that saves a TurtleEvent
typealias SaveTurtleEvent = (TurtleId) -> (TurtleEvent) -> Void

/// A desired action on a turtlr
enum TurtleCommandAction {
    case move(_ distance: Distance)
    case turn(_ angle: Angle)
    case penUp
    case penDown
    case setColor(_ color: PenColor)
}

/// A command representing a desired action addressed to a specific turtle
struct NewTurtleCommand {
    let turtleId: TurtleId
    let action: TurtleCommandAction
}

/// An event representing a state change that happened
enum StateChangedEvent {
    case moved(_ distance: Distance)
    case turned(_ angle: Angle)
    case penWentUp
    case penWentDown
    case colorChange(_ color: PenColor)
}

/// An event representing a move that happened
/// This can be easily translated into a line-drawing activity on a canvas
struct MovedEvent {
    let startPos: Position
    let endPos: Position
    let penColor: PenColor?
}

/// A union of all possible events
enum TurtleEvent {
    case stateChangedEvent(_: StateChangedEvent)
    case movedEvent(_: MovedEvent)
}

extension TurtleEvent: CustomStringConvertible {
    var description: String {
        switch self {
        case .stateChangedEvent(let event):
            return "====== TURTLE EVENT =====\n\nStateChangedEvent: \(event)\n\n"
        case .movedEvent(let movedEvent):
            return "====== TURTLE EVENT =====\n\nMovedEvent: \(movedEvent)\n\n"
        }
    }
}

// ====================================
// MARK: CommandHandler
// ====================================

struct CommandHandler {

    /// Apply an event to the current state and return the new state of the turtle
    func applyEvent(_ log: @escaping (String) -> Void,
                    _ oldState: TurtleState,
                    _ event: StateChangedEvent) -> TurtleState {

        switch event {
        case .moved(let distance): return FPTurtle.move(log)(distance)(oldState)
        case .turned(let angle): return FPTurtle.turn(log)(angle)(oldState)
        case .penWentUp: return FPTurtle.penUp(log)(oldState)
        case .penWentDown: return FPTurtle.penDown(log)(oldState)
        case .colorChange(let color): return FPTurtle.setColor(log)(color)(oldState)
        }
    }

    // Determine what events to generate, based on the command and the state.
    func eventsFromCommand(_ log: @escaping (String) -> Void,
                           _ command: NewTurtleCommand,
                           _ stateBeforeCommand: TurtleState) -> [TurtleEvent] {

            // --------------------------
            // create the StateChangedEvent from the TurtleCommand
            let stateChangedEvent: () -> StateChangedEvent = {
                switch command.action {
                case .move(let distance):
                    return StateChangedEvent.moved(distance)
                case .turn(let angle):
                    return StateChangedEvent.turned(angle)
                case .penUp:
                    return StateChangedEvent.penWentUp
                case .penDown:
                    return StateChangedEvent.penWentDown
                case .setColor(let color):
                    return StateChangedEvent.colorChange(color)
                }
            }

            // --------------------------
            // calculate the current state from the new event
            let stateAfterCommand = applyEvent(log, stateBeforeCommand, stateChangedEvent())

            // --------------------------
            // create the MovedEvent
            let startPos = stateBeforeCommand.position
            let endPos = stateAfterCommand.position

            let penColor: () -> PenColor? = {
                stateBeforeCommand.penState == .down ? stateBeforeCommand.color : nil
            }

            let movedEvent = MovedEvent(startPos: startPos,
                                        endPos: endPos,
                                        penColor: penColor())

            // --------------------------
            // return the list of events
            if startPos != endPos {
                // if the turtle has moved, return both the stateChangedEvent and the movedEvent
                // lifted into the common TurtleEvent type
                return [TurtleEvent.stateChangedEvent(stateChangedEvent()),
                        TurtleEvent.movedEvent(movedEvent)]

            } else {
                // if the turtle has not moved, return just the stateChangedEvent
                return [TurtleEvent.stateChangedEvent(stateChangedEvent())]
            }

    }

    /// main function : process a command
    func commandHandler(_ log: @escaping (String) -> Void,
                        _ getEvents: @escaping GetStateChangedEventsForId,
                        _ saveEvent: @escaping SaveTurtleEvent) -> (NewTurtleCommand) -> Void {

        return { command in

            /// First load all the events from the event store
            let eventHistory = getEvents(command.turtleId)

            /// Then, recreate the state before the command
            let stateBeforeCommand =
                eventHistory
                    .reduce(FPTurtle.initialTurtleState, { state, event in
                        return self.applyEvent({ _ in }, state, event)
                    })

            /// Construct the events from the command and the stateBeforeCommand
            /// Do use the supplied logger for this bit
            let events = self.eventsFromCommand(log, command, stateBeforeCommand)

            events.forEach(saveEvent(command.turtleId))
        }
    }
}

// ====================================
// MARK: CommandHandlerClient
// ====================================

struct CommandHandlerClient {

    // filter to choose only StateChangedEvent from TurtleEvents
    func stateChangedEventFilter(_ event: TurtleEvent) -> StateChangedEvent? {
        switch event {
        case .stateChangedEvent(let ev):
            return ev
        default:
            return nil
        }
    }

    /// create a command handler
    func makeCommandHandler() -> (NewTurtleCommand) -> Void {

        let logger: (String) -> Void = { message in
            print(message)
        }

        let eventStore = EventStore<TurtleEvent>()

        let getStateChangedEvents: GetStateChangedEventsForId = { eventId in
            eventStore
                .get(eventId: eventId)
                .compactMap({ self.stateChangedEventFilter($0)! })
        }

        let saveEvent: SaveTurtleEvent = { id in
            return { event in eventStore.save()(id)(event) }
        }

        return CommandHandler().commandHandler(logger,
                                               getStateChangedEvents,
                                               saveEvent)

    }

    // Command versions of standard actions
    static var turtleId: String {
        return UUID().uuidString
    }

    let move: (Distance) -> NewTurtleCommand = { distance in
        NewTurtleCommand(turtleId: turtleId,
                         action: TurtleCommandAction.move(distance))
    }

    let turn: (Angle) -> NewTurtleCommand = { angle in
        NewTurtleCommand(turtleId: turtleId,
                         action: TurtleCommandAction.turn(angle))
    }

    let penUp: () -> NewTurtleCommand = {
        NewTurtleCommand(turtleId: turtleId,
                         action: TurtleCommandAction.penUp)
    }

    let penDown: () -> NewTurtleCommand = {
        NewTurtleCommand(turtleId: turtleId,
                         action: TurtleCommandAction.penDown)
    }

    let setColor: (PenColor) -> NewTurtleCommand = { color in
        NewTurtleCommand(turtleId: turtleId,
                         action: TurtleCommandAction.setColor(color))
    }

    func drawTriangle() {

        let handler = makeCommandHandler()

        handler(move(100))
        handler(turn(120))
        handler(move(100))
        handler(turn(120))
        handler(move(100))
        handler(turn(120))

    }

    func drawThreeLines() {

        let handler = makeCommandHandler()
        // draw black line
        handler(penDown())
        handler(setColor(.black))
        handler(move(100))
        // move without drawing
        handler(penUp())
        handler(turn(90.0))
        handler(move(100.0))
        handler(turn(90))
        // draw red line
        handler(penDown())
        handler(setColor(.red))
        handler(move(100))
        // move without drawing
        handler(penUp())
        handler(turn(90.0))
        handler(move(100))
        handler(turn(90.0))
        // back home at (0,0) with angle 0
        // draw diagonal blue line
        handler(penDown())
        handler(setColor(.blue))
        handler(turn(45.0))
        handler(move(100))
    }

    //    let drawPolygon n =
    //    let angle = 180.0 - (360.0/float n)
    //    let angleDegrees = angle * 1.0<Degrees>
    //    let handler = makeCommandHandler()
    //
    //    // define a function that draws one side
    //    let drawOneSide sideNumber =
    //        handler (move 100.0)
    //    handler (turn angleDegrees)
    //
    //    // repeat for all sides
    //    for i in [1..n] do
    //    drawOneSide i
}
