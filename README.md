# Thirteen way of looking at a turtle (Swift)
This is the Swift version of the original article and talk by Scott Wlaschin written in F#.

This repository acts as an exercise to show the numerous benefits of Functional Programming (FP) over OOP with Swift. There are some sections that have yet to be updated.

The benefits of FP are numerous and combined with other software design patterns and principles, it can allow for creating reusable, clean, maintainable, robust and testable code.

## Links
You can find the talk [here](https://www.youtube.com/watch?v=AG3KuqDbmhM&t=3442s).

And the post [here](https://fsharpforfunandprofit.com/posts/13-ways-of-looking-at-a-turtle/).

Find out more about F# [here](https://fsharpforfunandprofit.com).

Personally, learning F# has broadened my knowledge and perspective on Functional Programming. I highly encourage to take F# as it will add another layer of thinking.

## Example of different implementations

Here is a list with small examples of the different ways of implementing the Turle API. Feel free to clone the repository to have a deeper look into each approach.

- Way 1. A basic object-oriented approach, in which we create a class with mutable state.

```swift
class Turtle {

    let log: (String) -> Void

    init(_ log: @escaping (String) -> Void) {
        self.log = log
    }

    var currentPosition: Position = Position(x: 0, y: 0)
    var currentAngle: Angle = 0
    var currentColor: PenColor = .red
    var currentPenState: PenState = .up
}
```

- Way 2. A basic functional approach, in which we create a module of functions with immutable state.

```swift
enum FPTurtle {

    struct TurtleState: Equatable {
        let position: Position
        let angle: Degrees
        let color: PenColor
        let penState: PenState
    }

    static let initialTurtleState: TurtleState = TurtleState(position: Position(x: 0, y: 0),
                                                             angle: 0,
                                                             color: .black,
                                                             penState: .up)

    static func move(_ log: @escaping (String) -> Void) -> (Distance) -> (TurtleState) -> TurtleState {}

    static func checkPosition(_ position: Position) -> (MoveResponse, Position) {}

    static func moveR(_ log: @escaping (String) -> Void) -> (Distance) -> (TurtleState) -> (MoveResponse, TurtleState) {}

    static func turn(_ log: @escaping (String) -> Void) -> (Angle) -> (TurtleState) -> TurtleState {}

    static func penUp(_ log: (String) -> Void) -> (TurtleState) -> TurtleState {}

    static func penDown(_ log: (String) -> Void) -> (TurtleState) -> TurtleState {}

    static func setColor(_ log: @escaping (String) -> Void) -> (PenColor) -> (TurtleState) -> TurtleState {}

    static func setColorR(_ log: @escaping (String) -> Void) -> (PenColor) -> (TurtleState) -> (SetColorResponse, TurtleState) {}

}
```

- Way 3. An API with a object-oriented core, in which we create an object-oriented API that calls a stateful core class.
```swift
final class TurtleApi {

    let turtle = Turtle(log)

    private static func validateDistance(_ distanceStr: String) throws -> Distance {
        // implementation
    }

    private static func validateAngle(_ angleStr: String) throws -> Degrees {
        // implementation
    }

    private static func validateColor(_ colorStr: String) throws -> PenColor {
        // implementation
    }

    public func exec(_ commandStr: String) throws {
        // implementation
    }

}
```
- Way 4. An API with a functional core, in which we create an stateful API that uses stateless core functions.

```swift
final class FPTurtleApi {

    private var state = FPTurtle.initialTurtleState

    private func updateState(newState: TurtleState) {
        // implementation
    }

    let validateDistance: (String) -> Result<Distance, Error> = { distanceStr in
        // implementation
    }

    let validateAngle: (String) -> Result<Angle, Error> = { angleStr in
        // implementation
    }

    let validateColor: (String) -> Result<PenColor, Error> = { colorStr in
        // implementation
    }

    public func exec() -> (String) -> Result<Unit, Error> {
        // implementation
    }

    private func calculateNewStateR(_ tokens: [String],
                                    _ stateR: Result<TurtleState, Error>) -> Result<TurtleState, Error> {
        // implementation
        }
    }
}
```
- Way 5. An API in front of an agent, in which we create an API that uses a message queue to communicate with an agent.
```swift
struct TurtleAgent {

    static let log: (String) -> Void = { message in print(message) }

    static let move = FPTurtle.move(log)
    static let turn = FPTurtle.turn(log)
    static let penDown = FPTurtle.penDown(log)
    static let penUp = FPTurtle.penUp(log)
    static let setColor = FPTurtle.setColor(log)

    static let mailboxProc = MailboxProcessor<TurtleCommand>()

    let process: () = mailboxProc.start { inbox in
        // implementation
    }

    func post(_ command: TurtleCommand) {
        // implementation
    }

    static private func matchCommandState(_ command: TurtleCommand,
                                            _ state: TurtleState) -> TurtleState {

        // implementation

    }
}
```
- Way 6. Dependency injection using interfaces, in which we decouple the implementation from the API using an interface or record of functions.
```swift
protocol ITurtle {
    var move: (Distance) -> Unit { get }
    var turn: (Angle) -> Unit { get }
    var penUp: () -> Unit { get }
    var penDown: () -> Unit { get }
    var setColor: (PenColor) -> Unit { get }
}
```
- Way 7. Dependency injection using functions, in which we decouple the implementation from the API by passing a function parameter.
```swift
final class TurtleApi {

    private var state = FPTurtle.initialTurtleState

    private func updateState(newState: FPTurtle.TurtleState) {
        self.state = newState
    }

    func exec(move: @escaping (Distance) -> (TurtleState) -> TurtleState,
              turn: @escaping (Angle) -> (TurtleState) -> TurtleState,
              penUp: @escaping (TurtleState) -> TurtleState,
              penDown: @escaping (TurtleState) -> TurtleState,
              setColor: @escaping (PenColor) -> (TurtleState) -> TurtleState)
        -> (String) -> Result<Unit, ErrorMessage> {

        // implementation

    }
}

```
- Way 8. Batch processing using a state monad, in which we create a special “turtle workflow” computation expression to track state for us.

```swift
typealias TurtleStateComputation<T> = (TurtleState) -> (T, TurtleState)

struct TurtleStateComputationClass {

    static func runT<T>(_ turtle: TurtleStateComputation<T>, _ state: TurtleState) -> (T, TurtleState) {
        
        // implementation

    }

    static func returnT<T>(_ x: T) -> TurtleStateComputation<T> {

        // implementation

    }

    static func bindT<T, U>(_ f: @escaping (T) -> TurtleStateComputation<U>,
                            _ xT: @escaping TurtleStateComputation<T>) -> TurtleStateComputation<U> {

        // implementation

    }

    static func toComputation<T>(_ f: @escaping (TurtleState) -> (T, TurtleState)) -> TurtleStateComputation<T> {

        // implementation

    }

    static func toUnitComputation(_ f: @escaping (TurtleState) -> TurtleState) -> TurtleStateComputation<Unit> {

        // implementation

    }

    @_functionBuilder
    struct TurtleBuilder {

        static func buildBlock<T>(_ x: TurtleStateComputation<T>...) -> TurtleStateComputation<Unit> {

            // implementation

        }

        func turtle<T>(
            @TurtleBuilder child: () -> TurtleStateComputation<T>
        ) -> TurtleStateComputation<T> {

            // implementation
        
        }

    }

    static let turtle = TurtleBuilder()

}

```
- Way 9. Batch processing using command objects, in which we create a type to represent a turtle command, and then process a list of commands all at once.
```swift
final class TurtleCommmandHandler {

    static let log: (String) -> Void = { message in
        // implementation
    }

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

    static func applyCommand(state: TurtleState, command: TurtleCommand) -> TurtleState {
        // implementation
    }

    /// Run list of commands in one go
    let run: ([TurtleCommand]) -> Void = { aListOfCommands in
        // implementation
    }

}
```
- Way 10. Event sourcing, in which state is built from a list of past events.

```swift
final class EventStore<T> {

    var eventDict = [EventId: [T]]()
    let saveEvent: PublishSubject<T> = PublishSubject()

    func saveEvent(_ element: T) {
        // implementation
    }

    func save() -> (EventId) -> (T) -> Void 
        // implementation
    }

    func get(eventId: EventId) -> [T] {
        // implementation
    }

    func clear(eventId: EventId) {
        // implementation
    }

}
```
- TODO - Way 11.

- Way 12. Monadic control flow, in which we make decisions in the turtle workflow based on results from earlier commands.
- TODO Way 13.

These are the functional programming techniquest applied in this project:

## Pure, stateless functions. 
As seen in all of the FP-oriented examples. All these are very easy to test and mock.
##  Partial application
As first seen in the simplest FP example (way 2), when the turtle functions had the logging function applied so that the main flow could use piping, and thereafter used extensively, particularly in the “dependency injection using functions approach” (way 7).
##  Object expressions 
To implement an interface without creating a class, as seen in way 6.
## Result type (a.k.a the Either monad). 
Used in all the functional API examples (e.g. way 4) to return an error rather than throw an exception.
## Applicative "lifting"
To lift normal functions to the world of Results, again in way 4 and others.
- Lots of different ways of managing state:
    - mutable fields (way 1)
    - managing state explicitly and piping it though a series of functions (way 2)
    - having state only at the edge (the functional core/imperative shell in way 4)
    - hiding state in an agent (way 5)
    - threading state behind the scenes in a state monad (the turtle workflow in ways 8 and 12)
    - avoiding state altogether by using batches of commands (way 9) or batches of events (way 10) or an interpreter (way 13)
- Wrapping a function in a type. Used in way 8 to manage state (the State monad) and in way 13 to store responses.
- Computation expressions, lots of them! We created and used three:
    result for working with errors
    turtle for managing turtle state
    turtleProgram for building an AST in the interpreter approach (way 13).
- Chaining of monadic functions in the result and turtle workflows. The underlying functions are monadic (“diagonal”) and would not normally compose properly, but inside a workflow, they can be sequenced easily and transparently.
- Representing behavior as a data structure in the “functional dependency injection” example (way 7) so that a single function could be passed in rather than a whole interface.
- Decoupling using a data-centric protocol as seen in the agent, batch command, event sourcing, and interpreter examples.
- Lock free and async processing using an agent (way 5).
- The separation of “building” a computation vs. “running” it, as seen in the turtle workflows (ways 8 and 12) and the turtleProgram workflow (way 13: interpreter).
- Use of event sourcing to rebuild state from scratch rather than maintaining mutable state in memory, as seen in the event sourcing (way 10) and FRP (way 11) examples.
- Use of event streams and FRP (way 11) to break business logic into small, independent, and decoupled processors rather than having a monolithic object.

The original source code can be found [here](https://github.com/kuriishu27/13-ways-of-looking-at-a-turtle)
