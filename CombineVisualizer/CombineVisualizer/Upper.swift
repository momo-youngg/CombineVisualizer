//
//  Upper.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/07.
//

import Foundation
import Combine

/// A publisher that performs type erasure by wrapping another publisher.
///
/// ``AnyPublisher`` is a concrete implementation of ``Publisher`` that has no significant properties of its own, and passes through elements and completion values from its upstream publisher.
///
/// Use ``AnyPublisher`` to wrap a publisher whose type has details you don’t want to expose across API boundaries, such as different modules. Wrapping a ``Subject`` with ``AnyPublisher`` also prevents callers from accessing its ``Subject/send(_:)`` method. When you use type erasure this way, you can change the underlying publisher implementation over time without affecting existing clients.
///
/// You can use Combine’s ``Publisher/eraseToAnyPublisher()`` operator to wrap a publisher with ``AnyPublisher``.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@frozen public struct CZAnyPublisher<Output, Failure> : CZPublisher, CustomStringConvertible, CustomPlaygroundDisplayConvertible where Failure : Error {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String {
        self.inner.description
    }

    /// A custom playground description for this instance.
    public var playgroundDescription: Any {
        self.inner.playgroundDescription
    }
    
    public let inner: AnyPublisher<Output, Failure>
    public let uuid: UUID
    
    public init(inner: AnyPublisher<Output, Failure>, uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }
}

/// A type-erasing subscriber.
///
/// Use an ``AnySubscriber`` to wrap an existing subscriber whose details you don’t want to expose. You can also use ``AnySubscriber`` to create a custom subscriber by providing closures for the methods defined in ``Subscriber``, rather than implementing ``Subscriber`` directly.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class CZAnySubscriber<Input, Failure> : CZSubscriber<AnySubscriber<Input, Failure>>, CustomStringConvertible, CustomReflectable, CustomPlaygroundDisplayConvertible where Failure : Error {

    /// A unique identifier for identifying publisher streams.
    public var combineIdentifier: CombineIdentifier {
        self.inner.combineIdentifier
    }

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String {
        self.inner.description
    }

    /// The custom mirror for this instance.
    ///
    /// If this type has value semantics, the mirror should be unaffected by
    /// subsequent mutations of the instance.
    public var customMirror: Mirror {
        self.inner.customMirror
    }

    /// A custom playground description for this instance.
    public var playgroundDescription: Any {
        self.inner.playgroundDescription
    }
    
    public override init(_ inner: AnySubscriber<Input, Failure>, uuid: UUID) {
        super.init(inner, uuid: uuid)
    }
}

/// A subject that wraps a single value and publishes a new element whenever the value changes.
///
/// Unlike ``PassthroughSubject``, ``CurrentValueSubject`` maintains a buffer of the most recently published element.
///
/// Calling ``CurrentValueSubject/send(_:)`` on a ``CurrentValueSubject`` also updates the current value, making it equivalent to updating the ``CurrentValueSubject/value`` directly.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class CZCurrentValueSubject<Output, Failure> : CZSubject where Failure : Error {

    /// The value wrapped by this subject, published as a new element whenever it changes.
    final public var value: Output {
        self.inner.value
    }
    
    public let inner: CurrentValueSubject<Output, Failure>
    public let uuid: UUID
    
    public init(inner: CurrentValueSubject<Output, Failure>, uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }
}

/// A publisher that awaits subscription before running the supplied closure to create a publisher for the new subscriber.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CZDeferred<DeferredPublisher> : CZPublisher where DeferredPublisher : Publisher {

    /// The kind of values published by this publisher.
    public typealias Output = DeferredPublisher.Output

    /// The kind of errors this publisher might publish.
    public typealias Failure = DeferredPublisher.Failure

    /// The closure to execute when this deferred publisher receives a subscription.
    ///
    /// The publisher returned by this closure immediately receives the incoming subscription.
    public let createPublisher: () -> DeferredPublisher
    
    public let inner: Deferred<DeferredPublisher>
    public let uuid: UUID
    
    public init(inner: Deferred<DeferredPublisher>, uuid: UUID) {
        self.createPublisher = inner.createPublisher
        self.inner = inner
        self.uuid = uuid
    }
}

/// A publisher that never publishes any values, and optionally finishes immediately.
///
/// You can create a ”Never” publisher — one which never sends values and never finishes or fails — with the initializer `Empty(completeImmediately: false)`.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CZEmpty<Output, Failure> : CZPublisher, Equatable where Failure : Error {

    /// A Boolean value that indicates whether the publisher immediately sends a completion.
    ///
    /// If `true`, the publisher finishes immediately after sending a subscription to the subscriber. If `false`, it never completes.
    public let completeImmediately: Bool
    
    public let inner: Empty<Output, Failure>
    public let uuid: UUID
    
    public init(inner: Empty<Output, Failure>, uuid: UUID) {
        self.completeImmediately = inner.completeImmediately
        self.inner = inner
        self.uuid = uuid
    }

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: An `Empty` instance to compare.
    ///   - rhs: Another `Empty` instance to compare.
    /// - Returns: `true` if the two publishers have equal `completeImmediately` properties; otherwise `false`.
    public static func == (lhs: CZEmpty<Output, Failure>, rhs: CZEmpty<Output, Failure>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

/// A publisher that immediately terminates with the specified error.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CZFail<Output, Failure> : CZPublisher where Failure : Error {

    /// The failure to send when terminating the publisher.
    public let error: Failure
    
    public let inner: Fail<Output, Failure>
    public let uuid: UUID
    
    public init(inner: Fail<Output, Failure>, uuid: UUID) {
        self.error = inner.error
        self.inner = inner
        self.uuid = uuid
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CZFail : Equatable where Failure : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `Fail` publisher to compare for equality.
    ///   - rhs: Another `Fail` publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `error` properties; otherwise `false`.
    public static func == (lhs: CZFail<Output, Failure>, rhs: CZFail<Output, Failure>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

/// A publisher that eventually produces a single value and then finishes or fails.
///
/// Use a future to perform some work and then asynchronously publish a single element. You initialize the future with a closure that takes a ``Combine/Future/Promise``; the closure calls the promise with a <doc://com.apple.documentation/documentation/Swift/Result> that indicates either success or failure. In the success case, the future's downstream subscriber receives the element prior to the publishing stream finishing normally. If the result is an error, publishing terminates with that error.
///
/// The following example shows a method that uses a future to asynchronously publish a random number after a brief delay:
///
///     func generateAsyncRandomNumberFromFuture() -> Future <Int, Never> {
///         return Future() { promise in
///             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
///                 let number = Int.random(in: 1...10)
///                 promise(Result.success(number))
///             }
///         }
///     }
///
/// To receive the published value, you use any Combine subscriber, such as a ``Combine/Subscribers/Sink``, like this:
///
///     cancellable = generateAsyncRandomNumberFromFuture()
///         .sink { number in print("Got random number \(number).") }
///
/// ### Integrating with Swift Concurrency
///
/// To integrate with the `async`-`await` syntax in Swift 5.5, `Future` can provide its value to an awaiting caller. This is particularly useful because unlike other types that conform to ``Publisher`` and potentially publish many elements, a `Future` only publishes one element (or fails). By using the ``Combine/Future/value-9iwjz`` property, the above call point looks like this:
///
///     let number = await generateAsyncRandomNumberFromFuture().value
///     print("Got random number \(number).")
///
/// ### Alternatives to Futures
///
/// The `async`-`await` syntax in Swift can also replace the use of a future entirely, for the case where you want to perform some operation after an asynchronous task completes.
///
/// You do this with the function <doc://com.apple.documentation/documentation/Swift/3814988-withCheckedContinuation> and its throwing equivalent, <doc://com.apple.documentation/documentation/Swift/3814989-withCheckedThrowingContinuation>. The following example performs the same asynchronous random number generation as the `Future` example above, but as an `async` method:
///
///     func generateAsyncRandomNumberFromContinuation() async -> Int {
///         return await withCheckedContinuation { continuation in
///             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
///                 let number = Int.random(in: 1...10)
///                 continuation.resume(returning: number)
///             }
///         }
///     }
///
/// The call point for this method doesn't use a closure like the future's sink subscriber does; it simply awaits and assigns the result:
///
///     let asyncRandom = await generateAsyncRandomNumberFromContinuation()
///
/// For more information on continuations, see the <doc://com.apple.documentation/documentation/swift/swift_standard_library/concurrency> topic in the Swift standard library.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class CZFuture<Output, Failure> : CZPublisher where Failure : Error {

    /// A type that represents a closure to invoke in the future, when an element or error is available.
    ///
    /// The promise closure receives one parameter: a `Result` that contains either a single element published by a ``Future``, or an error.
    public typealias Promise = (Result<Output, Failure>) -> Void
    
    public let inner: Future<Output, Failure>
    public let uuid: UUID
    
    public init(inner: Future<Output, Failure>, uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CZFuture where Failure == Never {

    /// The published value of the future, delivered asynchronously.
    ///
    /// This property subscribes to the `Future` and delivers the value asynchronously when the `Future` publishes it. Use this property when you want to use the `async`-`await` syntax with a `Future`.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    final public var value: Output {
        get async {
            await inner.value
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CZFuture {

    /// The published value of the future or an error, delivered asynchronously.
    ///
    /// This property subscribes to the `Future` and delivers the value asynchronously when the `Future` publishes it. If the `Future` terminates with an error, the awaiting caller receives the error instead. Use this property when you want to the `async`-`await` syntax with a `Future` whose ``Publisher/Failure`` type is not <doc://com.apple.documentation/documentation/Swift/Never>.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    final public var value: Output {
        get async throws {
            try await self.inner.value
        }
    }
}

/// A publisher that emits an output to each subscriber just once, and then finishes.
///
/// You can use a ``Just`` publisher to start a chain of publishers. A ``Just`` publisher is also useful when replacing a value with ``Publishers/Catch``.
///
/// In contrast with <doc://com.apple.documentation/documentation/Swift/Result/Publisher>, a ``Just`` publisher can’t fail with an error. And unlike <doc://com.apple.documentation/documentation/Swift/Optional/Publisher>, a ``Just`` publisher always produces a value.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CZJust<Output> : CZPublisher {

    /// The kind of errors this publisher might publish.
    ///
    /// Use `Never` if this `Publisher` does not publish errors.
    public typealias Failure = Never

    /// The one element that the publisher emits.
    public let output: Output
    
    public let inner: Just<Output>
    public let uuid: UUID
    
    public init(inner: Just<Output>, uuid: UUID) {
        self.output = inner.output
        self.inner = inner
        self.uuid = uuid
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CZJust : Equatable where Output : Equatable {

    /// Returns a Boolean value that indicates whether two publishers are equivalent.
    /// - Parameters:
    ///   - lhs: A `Just` publisher to compare for equality.
    ///   - rhs: Another `Just` publisher to compare for equality.
    /// - Returns: `true` if the publishers have equal `output` properties; otherwise `false`.
    public static func == (lhs: CZJust<Output>, rhs: CZJust<Output>) -> Bool {
        return lhs.inner == rhs.inner
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CZJust where Output : Comparable {

    public func min() -> CZJust<Output> {
        return CZJust(inner: self.inner.min(), uuid: self.uuid)
    }

    public func max() -> CZJust<Output> {
        return CZJust(inner: self.inner.max(), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CZJust where Output : Equatable {
    
    public func contains(_ output: Output) -> CZJust<Bool> {
        return CZJust<Bool>(inner: self.inner.contains(output), uuid: self.uuid)
    }
    
    public func removeDuplicates() -> CZJust<Output> {
        return CZJust(inner: self.inner.removeDuplicates(), uuid: self.uuid)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CZJust {

    public func allSatisfy(_ predicate: (Output) -> Bool) -> CZJust<Bool> {
        return CZJust<Bool>(inner: self.inner.allSatisfy(predicate), uuid: self.uuid)
    }

    public func tryAllSatisfy(_ predicate: (Output) throws -> Bool) -> Result<Bool, Error>.CZPublisher {
        return Result<Bool, Error>.CZPublisher(inner: self.inner.tryAllSatisfy(predicate), uuid: self.uuid)
    }

    public func collect() -> CZJust<[Output]> {
        return CZJust<[Output]>(inner: self.inner.collect(), uuid: self.uuid)
    }

    public func compactMap<T>(_ transform: (Output) -> T?) -> Optional<T>.CZPublisher {
        return Optional<T>.CZPublisher(inner: self.inner.compactMap(transform), uuid: self.uuid)
    }

    public func min(by areInIncreasingOrder: (Output, Output) -> Bool) -> CZJust<Output> {
        return CZJust(inner: self.inner.min(by: areInIncreasingOrder), uuid: self.uuid)
    }

    public func max(by areInIncreasingOrder: (Output, Output) -> Bool) -> CZJust<Output> {
        return CZJust(inner: self.inner.max(by: areInIncreasingOrder), uuid: self.uuid)
    }

    public func prepend(_ elements: Output...) -> Publishers.CZSequence<[Output], Just<Output>.Failure> {
        return Publishers.CZSequence<[Output], Just<Output>.Failure>(inner: self.inner.prepend(elements), uuid: self.uuid)
    }

    public func prepend<S>(_ elements: S) -> Publishers.CZSequence<[Output], Just<Output>.Failure> where Output == S.Element, S : Sequence {
        return Publishers.CZSequence<[Output], Just<Output>.Failure>(inner: self.inner.prepend(elements), uuid: self.uuid)
    }

    public func append(_ elements: Output...) -> Publishers.CZSequence<[Output], Just<Output>.Failure> {
        return Publishers.CZSequence<[Output], Just<Output>.Failure>(inner: self.inner.append(elements), uuid: self.uuid)
    }

    public func append<S>(_ elements: S) -> Publishers.CZSequence<[Output], Just<Output>.Failure> where Output == S.Element, S : Sequence {
        return Publishers.CZSequence<[Output], Just<Output>.Failure>(inner: self.inner.append(elements), uuid: self.uuid)
    }

    public func contains(where predicate: (Output) -> Bool) -> CZJust<Bool> {
        return CZJust<Bool>(inner: self.inner.contains(where: predicate), uuid: self.uuid)
    }

    public func tryContains(where predicate: (Output) throws -> Bool) -> Result<Bool, Error>.CZPublisher {
        return Result<Bool, Error>.CZPublisher(inner: self.inner.tryContains(where: predicate), uuid: self.uuid)
    }

    public func count() -> CZJust<Int> {
        return CZJust<Int>(inner: self.inner.count(), uuid: self.uuid)
    }

    public func dropFirst(_ count: Int = 1) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.dropFirst(count), uuid: self.uuid)
    }

    public func drop(while predicate: (Output) -> Bool) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.drop(while: predicate), uuid: self.uuid)
    }

    public func first() -> CZJust<Output> {
        return CZJust<Output>(inner: self.inner.first(), uuid: self.uuid)
    }

    public func first(where predicate: (Output) -> Bool) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.first(where: predicate), uuid: self.uuid)
    }

    public func last() -> CZJust<Output> {
        return CZJust<Output>(inner: self.inner.last(), uuid: self.uuid)
    }

    public func last(where predicate: (Output) -> Bool) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.last(where: predicate), uuid: self.uuid)
    }

    public func filter(_ isIncluded: (Output) -> Bool) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.filter(isIncluded), uuid: self.uuid)
    }

    public func ignoreOutput() -> CZEmpty<Output, Just<Output>.Failure> {
        return CZEmpty<Output, Just<Output>.Failure>(inner: self.inner.ignoreOutput(), uuid: self.uuid)
    }

    public func map<T>(_ transform: (Output) -> T) -> CZJust<T> {
        return CZJust<T>(inner: self.inner.map(transform), uuid: self.uuid)
    }

    public func tryMap<T>(_ transform: (Output) throws -> T) -> Result<T, Error>.CZPublisher {
        return  Result<T, Error>.CZPublisher(inner: self.inner.tryMap(transform), uuid: self.uuid)
    }

    public func mapError<E>(_ transform: (Just<Output>.Failure) -> E) -> Result<Output, E>.CZPublisher where E : Error {
        return Result<Output, E>.CZPublisher(inner: self.inner.mapError(transform), uuid: self.uuid)
    }

    public func output(at index: Int) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.output(at: index), uuid: self.uuid)
    }

    public func output<R>(in range: R) -> Optional<Output>.CZPublisher where R : RangeExpression, R.Bound == Int {
        return Optional<Output>.CZPublisher(inner: self.inner.output(in: range), uuid: self.uuid)
    }

    public func prefix(_ maxLength: Int) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.prefix(maxLength), uuid: self.uuid)
    }

    public func prefix(while predicate: (Output) -> Bool) -> Optional<Output>.CZPublisher {
        return Optional<Output>.CZPublisher(inner: self.inner.prefix(while: predicate), uuid: self.uuid)
    }

    public func reduce<T>(_ initialResult: T, _ nextPartialResult: (T, Output) -> T) -> Result<T, Just<Output>.Failure>.CZPublisher {
        return Result<T, Just<Output>.Failure>.CZPublisher(inner: self.inner.reduce(initialResult, nextPartialResult), uuid: self.uuid)
    }

    public func tryReduce<T>(_ initialResult: T, _ nextPartialResult: (T, Output) throws -> T) -> Result<T, Error>.CZPublisher {
        return Result<T, Error>.CZPublisher(inner: self.inner.tryReduce(initialResult, nextPartialResult), uuid: self.uuid)
    }

    public func removeDuplicates(by predicate: (Output, Output) -> Bool) -> CZJust<Output> {
        return CZJust<Output>(inner: self.inner.removeDuplicates(by: predicate), uuid: self.uuid)
    }

    public func tryRemoveDuplicates(by predicate: (Output, Output) throws -> Bool) -> Result<Output, Error>.CZPublisher {
        return Result<Output, Error>.CZPublisher(inner: self.inner.tryRemoveDuplicates(by: predicate), uuid: self.uuid)
    }

    public func replaceError(with output: Output) -> CZJust<Output> {
        return CZJust<Output>(inner: self.inner.replaceError(with: output), uuid: self.uuid)
    }

    public func replaceEmpty(with output: Output) -> CZJust<Output> {
        return CZJust<Output>(inner: self.inner.replaceEmpty(with: output), uuid: self.uuid)
    }

    public func retry(_ times: Int) -> CZJust<Output> {
        return CZJust<Output>(inner: self.inner.retry(times), uuid: self.uuid)
    }

    public func scan<T>(_ initialResult: T, _ nextPartialResult: (T, Output) -> T) -> Result<T, Just<Output>.Failure>.CZPublisher {
        return Result<T, Just<Output>.Failure>.CZPublisher(inner: self.inner.scan(initialResult, nextPartialResult), uuid: self.uuid)
    }

    public func tryScan<T>(_ initialResult: T, _ nextPartialResult: (T, Output) throws -> T) -> Result<T, Error>.CZPublisher {
        return Result<T, Error>.CZPublisher(inner: self.inner.tryScan(initialResult, nextPartialResult), uuid: self.uuid)
    }

    public func setFailureType<E>(to failureType: E.Type) -> Result<Output, E>.CZPublisher where E : Error {
        return Result<Output, E>.CZPublisher(inner: self.inner.setFailureType(to: failureType), uuid: self.uuid)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {

    /// A publisher that emits before the object has changed.
    public var czObjectWillChange: CZObservableObjectPublisher {
        return CZObservableObjectPublisher(inner: self.objectWillChange, uuid: UUID())
    }
}

/// A publisher that publishes changes from observable objects.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final public class CZObservableObjectPublisher : CZPublisher {

    /// The kind of values published by this publisher.
    public typealias Output = Void

    /// The kind of errors this publisher might publish.
    ///
    /// Use `Never` if this `Publisher` does not publish errors.
    public typealias Failure = Never
    
    public let inner: ObservableObjectPublisher
    public let uuid: UUID
    
    public init(inner: ObservableObjectPublisher, uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }

    /// Sends the changed value to the downstream subscriber.
    final public func send() {
        self.visualize()
        self.inner.send()
    }
}

/// A subject that broadcasts elements to downstream subscribers.
///
/// As a concrete implementation of ``Subject``, the ``PassthroughSubject`` provides a convenient way to adapt existing imperative code to the Combine model.
///
/// Unlike ``CurrentValueSubject``, a ``PassthroughSubject`` doesn’t have an initial value or a buffer of the most recently-published element.
/// A ``PassthroughSubject`` drops values if there are no subscribers, or its current demand is zero.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class CZPassthroughSubject<Output, Failure> : CZSubject where Failure : Error {

    public let inner: PassthroughSubject<Output, Failure>
    public let uuid: UUID
    
    public init(inner: PassthroughSubject<Output, Failure>, uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Applies a closure to create a subject that delivers elements to subscribers.
    ///
    /// Use a multicast publisher when you have multiple downstream subscribers, but you want upstream publishers to only process one ``Subscriber/receive(_:)`` call per event. This is useful when upstream publishers are doing expensive work you don’t want to duplicate, like performing network requests.
    ///
    /// In contrast with ``Publisher/multicast(subject:)``, this method produces a publisher that creates a separate ``Subject`` for each subscriber.
    ///
    /// The following example uses a sequence publisher as a counter to publish three random numbers, generated by a ``Publisher/map(_:)-99evh`` operator.
    /// It uses a ``Publisher/multicast(_:)`` operator whose closure creates a ``PassthroughSubject`` to share the same random number to each of two subscribers. Because the multicast publisher is a ``ConnectablePublisher``, publishing only begins after a call to ``ConnectablePublisher/connect()``.
    ///
    ///     let pub = ["First", "Second", "Third"].publisher
    ///         .map( { return ($0, Int.random(in: 0...100)) } )
    ///         .print("Random")
    ///         .multicast { PassthroughSubject<(String, Int), Never>() }
    ///
    ///     cancellable1 = pub
    ///        .sink { print ("Stream 1 received: \($0)")}
    ///     cancellable2 = pub
    ///        .sink { print ("Stream 2 received: \($0)")}
    ///     pub.connect()
    ///
    ///     // Prints:
    ///     // Random: receive value: (("First", 9))
    ///     // Stream 2 received: ("First", 9)
    ///     // Stream 1 received: ("First", 9)
    ///     // Random: receive value: (("Second", 46))
    ///     // Stream 2 received: ("Second", 46)
    ///     // Stream 1 received: ("Second", 46)
    ///     // Random: receive value: (("Third", 26))
    ///     // Stream 2 received: ("Third", 26)
    ///     // Stream 1 received: ("Third", 26)
    ///
    /// In this example, the output shows that the ``Publisher/print(_:to:)`` operator receives each random value only one time, and then sends the value to both subscribers.
    ///
    /// - Parameter createSubject: A closure to create a new ``Subject`` each time a subscriber attaches to the multicast publisher.
    public func czMulticast<S>(_ createSubject: @escaping () -> S) -> Publishers.CZMulticast<Self, S> where S : Subject, Self.Failure == S.Failure, Self.Output == S.Output {
        return Publishers.CZMulticast(inner: self.multicast(createSubject), uuid: self.generateUUID())
    }

    /// Provides a subject to deliver elements to multiple subscribers.
    ///
    /// Use a multicast publisher when you have multiple downstream subscribers, but you want upstream publishers to only process one ``Subscriber/receive(_:)`` call per event. This is useful when upstream publishers are doing expensive work you don’t want to duplicate, like performing network requests.
    ///
    /// In contrast with ``Publisher/multicast(_:)``, this method produces a publisher that shares the provided ``Subject`` among all the downstream subscribers.
    ///
    /// The following example uses a sequence publisher as a counter to publish three random numbers, generated by a ``Publisher/map(_:)-99evh`` operator.
    /// It uses a ``Publisher/multicast(subject:)`` operator with a ``PassthroughSubject`` to share the same random number to each of two subscribers. Because the multicast publisher is a ``ConnectablePublisher``, publishing only begins after a call to ``ConnectablePublisher/connect()``.
    ///
    ///     let pub = ["First", "Second", "Third"].publisher
    ///         .map( { return ($0, Int.random(in: 0...100)) } )
    ///         .print("Random")
    ///         .multicast(subject: PassthroughSubject<(String, Int), Never>())
    ///
    ///     cancellable1 = pub
    ///         .sink { print ("Stream 1 received: \($0)")}
    ///     cancellable2 = pub
    ///         .sink { print ("Stream 2 received: \($0)")}
    ///     pub.connect()
    ///
    ///     // Prints:
    ///     // Random: receive value: (("First", 78))
    ///     // Stream 2 received: ("First", 78)
    ///     // Stream 1 received: ("First", 78)
    ///     // Random: receive value: (("Second", 98))
    ///     // Stream 2 received: ("Second", 98)
    ///     // Stream 1 received: ("Second", 98)
    ///     // Random: receive value: (("Third", 61))
    ///     // Stream 2 received: ("Third", 61)
    ///     // Stream 1 received: ("Third", 61)
    ///
    /// In this example, the output shows that the ``Publisher/print(_:to:)`` operator receives each random value only one time, and then sends the value to both subscribers.
    ///
    /// - Parameter subject: A subject to deliver elements to downstream subscribers.
    public func czMulticast<S>(subject: S) -> Publishers.CZMulticast<Self, S> where S : Subject, Self.Failure == S.Failure, Self.Output == S.Output {
        return Publishers.CZMulticast(inner: self.multicast(subject: subject), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Specifies the scheduler on which to perform subscribe, cancel, and request operations.
    ///
    /// In contrast with ``Publisher/receive(on:options:)``, which affects downstream messages, ``Publisher/subscribe(on:options:)`` changes the execution context of upstream messages.
    ///
    /// In the following example, the ``Publisher/subscribe(on:options:)`` operator causes `ioPerformingPublisher` to receive requests on `backgroundQueue`, while the ``Publisher/receive(on:options:)`` causes `uiUpdatingSubscriber` to receive elements and completion on `RunLoop.main`.
    ///
    ///     let ioPerformingPublisher == // Some publisher.
    ///     let uiUpdatingSubscriber == // Some subscriber that updates the UI.
    ///
    ///     ioPerformingPublisher
    ///         .subscribe(on: backgroundQueue)
    ///         .receive(on: RunLoop.main)
    ///         .subscribe(uiUpdatingSubscriber)
    ///
    ///
    /// Using ``Publisher/subscribe(on:options:)`` also causes the upstream publisher to perform ``Cancellable/cancel()`` using the specfied scheduler.
    ///
    /// - Parameters:
    ///   - scheduler: The scheduler used to send messages to upstream publishers.
    ///   - options: Options that customize the delivery of elements.
    /// - Returns: A publisher which performs upstream operations on the specified scheduler.
    public func czSubscribe<S>(on scheduler: S, options: S.SchedulerOptions? = nil) -> Publishers.CZSubscribeOn<Self, S> where S : Scheduler {
        return Publishers.CZSubscribeOn(inner: self.subscribe(on: scheduler, options: options), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Measures and emits the time interval between events received from an upstream publisher.
    ///
    /// Use ``Publisher/measureInterval(using:options:)`` to measure the time between events delivered from an upstream publisher.
    ///
    /// In the example below, a 1-second <doc://com.apple.documentation/documentation/Foundation/Timer> is used as the data source for an event publisher; the ``Publisher/measureInterval(using:options:)`` operator reports the elapsed time between the reception of events on the main run loop:
    ///
    ///     cancellable = Timer.publish(every: 1, on: .main, in: .default)
    ///         .autoconnect()
    ///         .measureInterval(using: RunLoop.main)
    ///         .sink { print("\($0)", terminator: "\n") }
    ///
    ///     // Prints:
    ///     //      Stride(magnitude: 1.0013610124588013)
    ///     //      Stride(magnitude: 0.9992760419845581)
    ///
    /// The output type of the returned publisher is the time interval of the provided scheduler.
    ///
    /// This operator uses the provided scheduler’s ``Scheduler/now`` property to measure intervals between events.
    ///
    /// - Parameters:
    ///   - scheduler: A scheduler to use for tracking the timing of events.
    ///   - options: Options that customize the delivery of elements.
    /// - Returns: A publisher that emits elements representing the time interval between the elements it receives.
    public func czMeasureInterval<S>(using scheduler: S, options: S.SchedulerOptions? = nil) -> Publishers.CZMeasureInterval<Self, S> where S : Scheduler {
        return Publishers.CZMeasureInterval(inner: self.measureInterval(using: scheduler, options: options), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Omits elements from the upstream publisher until a given closure returns false, before republishing all remaining elements.
    ///
    /// Use ``Publisher/drop(while:)`` to omit elements from an upstream publisher until the element received meets a condition you specify.
    ///
    /// In the example below, the operator omits all elements in the stream until the first element arrives that’s a positive integer, after which the operator publishes all remaining elements:
    ///
    ///     let numbers = [-62, -1, 0, 10, 0, 22, 41, -1, 5]
    ///     cancellable = numbers.publisher
    ///         .drop { $0 <= 0 }
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "10 0, 22 41 -1 5"
    ///
    ///
    /// - Parameter predicate: A closure that takes an element as a parameter and returns a Boolean value indicating whether to drop the element from the publisher’s output.
    /// - Returns: A publisher that skips over elements until the provided closure returns `false`.
    public func czDrop(while predicate: @escaping (Self.Output) -> Bool) -> Publishers.CZDropWhile<Self> {
        return Publishers.CZDropWhile(inner: self.drop(while: predicate), uuid: self.generateUUID())
    }

    /// Omits elements from the upstream publisher until an error-throwing closure returns false, before republishing all remaining elements.
    ///
    /// Use ``Publisher/tryDrop(while:)`` to omit elements from an upstream until an error-throwing closure you provide returns false, after which the remaining items in the stream are published. If the closure throws, no elements are emitted and the publisher fails with an error.
    ///
    /// In the example below, elements are ignored until `-1` is encountered in the stream and the closure returns `false`. The publisher then republishes the remaining elements and finishes normally. Conversely, if the `guard` value in the closure had been encountered, the closure would throw and the publisher would fail with an error.
    ///
    ///     struct RangeError: Error {}
    ///     var numbers = [1, 2, 3, 4, 5, 6, -1, 7, 8, 9, 10]
    ///     let range: CountableClosedRange<Int> = (1...100)
    ///     cancellable = numbers.publisher
    ///         .tryDrop {
    ///             guard $0 != 0 else { throw RangeError() }
    ///             return range.contains($0)
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)") },
    ///             receiveValue: { print ("value: \($0)") }
    ///         )
    ///
    ///     // Prints: "-1 7 8 9 10 completion: finished"
    ///     // If instead numbers was [1, 2, 3, 4, 5, 6, 0, -1, 7, 8, 9, 10], tryDrop(while:) would fail with a RangeError.
    ///
    /// - Parameter predicate: A closure that takes an element as a parameter and returns a Boolean value indicating whether to drop the element from the publisher’s output.
    /// - Returns: A publisher that skips over elements until the provided closure returns `false`, and then republishes all remaining elements. If the predicate closure throws, the publisher fails with an error.
    public func czTryDrop(while predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.CZTryDropWhile<Self> {
        return Publishers.CZTryDropWhile(inner: self.tryDrop(while: predicate), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Republishes all elements that match a provided closure.
    ///
    /// Combine’s ``Publisher/filter(_:)`` operator performs an operation similar to that of <doc://com.apple.documentation/documentation/Swift/Sequence/3018365-filter> in the Swift Standard Library: it uses a closure to test each element to determine whether to republish the element to the downstream subscriber.
    ///
    /// The following example, uses a filter operation that receives an `Int` and only republishes a value if it’s even.
    ///
    ///     let numbers: [Int] = [1, 2, 3, 4, 5]
    ///     cancellable = numbers.publisher
    ///         .filter { $0 % 2 == 0 }
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "2 4"
    ///
    /// - Parameter isIncluded: A closure that takes one element and returns a Boolean value indicating whether to republish the element.
    /// - Returns: A publisher that republishes all elements that satisfy the closure.
    public func czFilter(_ isIncluded: @escaping (Self.Output) -> Bool) -> Publishers.CZFilter<Self> {
        return Publishers.CZFilter(inner: self.filter(isIncluded), uuid: self.generateUUID())
    }

    /// Republishes all elements that match a provided error-throwing closure.
    ///
    /// Use ``Publisher/tryFilter(_:)`` to filter elements evaluated in an error-throwing closure. If the `isIncluded` closure throws an error, the publisher fails with that error.
    ///
    /// In the example below, ``Publisher/tryFilter(_:)`` checks to see if the element provided by the publisher is zero, and throws a `ZeroError` before terminating the publisher with the thrown error. Otherwise, it republishes the element only if it's even:
    ///
    ///     struct ZeroError: Error {}
    ///
    ///     let numbers: [Int] = [1, 2, 3, 4, 0, 5]
    ///     cancellable = numbers.publisher
    ///         .tryFilter{
    ///             if $0 == 0 {
    ///                 throw ZeroError()
    ///             } else {
    ///                 return $0 % 2 == 0
    ///             }
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("\($0)") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///          )
    ///
    ///     // Prints: "2 4 failure(DivisionByZeroError())".
    ///
    /// - Parameter isIncluded: A closure that takes one element and returns a Boolean value that indicated whether to republish the element or throws an error.
    /// - Returns: A publisher that republishes all elements that satisfy the closure.
    public func czTryFilter(_ isIncluded: @escaping (Self.Output) throws -> Bool) -> Publishers.CZTryFilter<Self> {
        return Publishers.CZTryFilter(inner: self.tryFilter(isIncluded), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Raises a debugger signal when a provided closure needs to stop the process in the debugger.
    ///
    /// Use ``Publisher/breakpoint(receiveSubscription:receiveOutput:receiveCompletion:)`` to examine one or more stages of the subscribe/publish/completion process and stop in the debugger, based on conditions you specify. When any of the provided closures returns `true`, this operator raises the `SIGTRAP` signal to stop the process in the debugger. Otherwise, this publisher passes through values and completions as-is.
    ///
    /// In the example below, a ``PassthroughSubject`` publishes strings to a breakpoint republisher. When the breakpoint receives the string “`DEBUGGER`”, it returns `true`, which stops the app in the debugger.
    ///
    ///     let publisher = PassthroughSubject<String?, Never>()
    ///     cancellable = publisher
    ///         .breakpoint(
    ///             receiveOutput: { value in return value == "DEBUGGER" }
    ///         )
    ///         .sink { print("\(String(describing: $0))" , terminator: " ") }
    ///
    ///     publisher.send("DEBUGGER")
    ///
    ///     // Prints: "error: Execution was interrupted, reason: signal SIGTRAP."
    ///     // Depending on your specific environment, the console messages may
    ///     // also include stack trace information, which is not shown here.
    ///
    /// - Parameters:
    ///   - receiveSubscription: A closure that executes when the publisher receives a subscription. Return `true` from this closure to raise `SIGTRAP`, or false to continue.
    ///   - receiveOutput: A closure that executes when the publisher receives a value. Return `true` from this closure to raise `SIGTRAP`, or false to continue.
    ///   - receiveCompletion: A closure that executes when the publisher receives a completion. Return `true` from this closure to raise `SIGTRAP`, or false to continue.
    /// - Returns: A publisher that raises a debugger signal when one of the provided closures returns `true`.
    public func czBreakpoint(receiveSubscription: ((Subscription) -> Bool)? = nil, receiveOutput: ((Self.Output) -> Bool)? = nil, receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Bool)? = nil) -> Publishers.CZBreakpoint<Self> {
        return Publishers.CZBreakpoint(inner: self.breakpoint(receiveSubscription: receiveSubscription, receiveOutput: receiveOutput, receiveCompletion: receiveCompletion), uuid: self.generateUUID())
    }

    /// Raises a debugger signal upon receiving a failure.
    ///
    /// When the upstream publisher fails with an error, this publisher raises the `SIGTRAP` signal, which stops the process in the debugger. Otherwise, this publisher passes through values and completions as-is.
    ///
    /// In this example a ``PassthroughSubject`` publishes strings, but its downstream ``Publisher/tryMap(_:)`` operator throws an error. This sends the error downstream as a ``Subscribers/Completion/failure(_:)``. The ``Publisher/breakpointOnError()`` operator receives this completion and stops the app in the debugger.
    ///
    ///      struct CustomError : Error {}
    ///      let publisher = PassthroughSubject<String?, Error>()
    ///      cancellable = publisher
    ///          .tryMap { stringValue in
    ///              throw CustomError()
    ///          }
    ///          .breakpointOnError()
    ///          .sink(
    ///              receiveCompletion: { completion in print("Completion: \(String(describing: completion))") },
    ///              receiveValue: { aValue in print("Result: \(String(describing: aValue))") }
    ///          )
    ///
    ///      publisher.send("TEST DATA")
    ///
    ///      // Prints: "error: Execution was interrupted, reason: signal SIGTRAP."
    ///      // Depending on your specific environment, the console messages may
    ///      // also include stack trace information, which is not shown here.
    ///
    /// - Returns: A publisher that raises a debugger signal upon receiving a failure.
    public func czBreakpointOnError() -> Publishers.CZBreakpoint<Self> {
        return Publishers.CZBreakpoint(inner: self.breakpointOnError(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes a single Boolean value that indicates whether all received elements pass a given predicate.
    ///
    /// Use the ``Publisher/allSatisfy(_:)`` operator to determine if all elements in a stream satisfy a criteria you provide. When this publisher receives an element, it runs the predicate against the element. If the predicate returns `false`, the publisher produces a `false` value and finishes. If the upstream publisher finishes normally, this publisher produces a `true` value and finishes.
    ///
    /// In the example below, the ``Publisher/allSatisfy(_:)`` operator tests if each an integer array publisher’s elements fall into the `targetRange`:
    ///
    ///     let targetRange = (-1...100)
    ///     let numbers = [-1, 0, 10, 5]
    ///     numbers.publisher
    ///         .allSatisfy { targetRange.contains($0) }
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "true"
    ///
    /// With operators similar to ``Publisher/reduce(_:_:)``, this publisher produces at most one value.
    ///
    ///  > Note: Upon receiving any request greater than zero, this publisher requests unlimited elements from the upstream publisher.
    ///
    /// - Parameter predicate: A closure that evaluates each received element. Return `true` to continue, or `false` to cancel the upstream and complete.
    /// - Returns: A publisher that publishes a Boolean value that indicates whether all received elements pass a given predicate.
    public func czAllSatisfy(_ predicate: @escaping (Self.Output) -> Bool) -> Publishers.CZAllSatisfy<Self> {
        return Publishers.CZAllSatisfy(inner: self.allSatisfy(predicate), uuid: self.generateUUID())
    }

    /// Publishes a single Boolean value that indicates whether all received elements pass a given error-throwing predicate.
    ///
    /// Use the ``Publisher/tryAllSatisfy(_:)`` operator to determine if all elements in a stream satisfy a criteria in an error-throwing predicate you provide. When this publisher receives an element, it runs the predicate against the element. If the predicate returns `false`, the publisher produces a `false` value and finishes. If the upstream publisher finishes normally, this publisher produces a `true` value and finishes. If the predicate throws an error, the publisher fails and passes the error to its downstream subscriber.
    ///
    /// In the example below, an error-throwing predicate tests if each of an integer array publisher’s elements fall into the `targetRange`; the predicate throws an error if an element is zero and terminates the stream.
    ///
    ///     let targetRange = (-1...100)
    ///     let numbers = [-1, 10, 5, 0]
    ///
    ///     numbers.publisher
    ///         .tryAllSatisfy { anInt in
    ///             guard anInt != 0 else { throw RangeError() }
    ///             return targetRange.contains(anInt)
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)") },
    ///             receiveValue: { print ("value: \($0)") }
    ///         )
    ///
    ///     // Prints: "completion: failure(RangeError())"
    ///
    /// With operators similar to ``Publisher/reduce(_:_:)``, this publisher produces at most one value.
    ///
    ///  > Note: Upon receiving any request greater than zero, this publisher requests unlimited elements from the upstream publisher.
    ///
    /// - Parameter predicate: A closure that evaluates each received element. Return `true` to continue, or `false` to cancel the upstream and complete. The closure may throw an error, in which case the publisher cancels the upstream publisher and fails with the thrown error.
    /// - Returns: A publisher that publishes a Boolean value that indicates whether all received elements pass a given predicate.
    public func czTryAllSatisfy(_ predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.CZTryAllSatisfy<Self> {
        return Publishers.CZTryAllSatisfy(inner: self.tryAllSatisfy(predicate), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Output : Equatable {

    /// Publishes only elements that don’t match the previous element.
    ///
    /// Use ``Publisher/removeDuplicates()`` to remove repeating elements from an upstream publisher. This operator has a two-element memory: the operator uses the current and previously published elements as the basis for its comparison.
    ///
    /// In the example below, ``Publisher/removeDuplicates()`` triggers on the doubled, tripled, and quadrupled occurrences of `1`, `3`, and `4` respectively. Because the two-element memory considers only the current element and the previous element, the operator prints the final `0` in the example data since its immediate predecessor is `4`.
    ///
    ///     let numbers = [0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 0]
    ///     cancellable = numbers.publisher
    ///         .removeDuplicates()
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1 2 3 4 0"
    ///
    /// - Returns: A publisher that consumes — rather than publishes — duplicate elements.
    public func czRemoveDuplicates() -> Publishers.CZRemoveDuplicates<Self> {
        return Publishers.CZRemoveDuplicates(inner: self.removeDuplicates(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes only elements that don’t match the previous element, as evaluated by a provided closure.
    ///
    /// Use ``Publisher/removeDuplicates(by:)`` to remove repeating elements from an upstream publisher based upon the evaluation of the current and previously published elements using a closure you provide.
    ///
    /// Use the ``Publisher/removeDuplicates(by:)`` operator when comparing types that don’t themselves implement `Equatable`, or if you need to compare values differently than the type’s `Equatable` implementation.
    ///
    /// In the example below, the ``Publisher/removeDuplicates(by:)`` functionality triggers when the `x` property of the current and previous elements are equal, otherwise the operator publishes the current `Point` to the downstream subscriber:
    ///
    ///     struct Point {
    ///         let x: Int
    ///         let y: Int
    ///     }
    ///
    ///     let points = [Point(x: 0, y: 0), Point(x: 0, y: 1),
    ///                   Point(x: 1, y: 1), Point(x: 2, y: 1)]
    ///     cancellable = points.publisher
    ///         .removeDuplicates { prev, current in
    ///             // Considers points to be duplicate if the x coordinate
    ///             // is equal, and ignores the y coordinate
    ///             prev.x == current.x
    ///         }
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: Point(x: 0, y: 0) Point(x: 1, y: 1) Point(x: 2, y: 1)
    ///
    /// - Parameter predicate: A closure to evaluate whether two elements are equivalent, for purposes of filtering. Return `true` from this closure to indicate that the second element is a duplicate of the first.
    /// - Returns: A publisher that consumes — rather than publishes — duplicate elements.
    public func czRemoveDuplicates(by predicate: @escaping (Self.Output, Self.Output) -> Bool) -> Publishers.CZRemoveDuplicates<Self> {
        return Publishers.CZRemoveDuplicates(inner: self.removeDuplicates(by: predicate), uuid: self.generateUUID())
    }

    /// Publishes only elements that don’t match the previous element, as evaluated by a provided error-throwing closure.
    ///
    /// Use ``Publisher/tryRemoveDuplicates(by:)`` to remove repeating elements from an upstream publisher based upon the evaluation of elements using an error-throwing closure you provide. If your closure throws an error, the publisher terminates with the error.
    ///
    /// In the example below, the closure provided to ``Publisher/tryRemoveDuplicates(by:)`` returns `true` when two consecutive elements are equal, thereby filtering out `0`,
    /// `1`, `2`, and `3`. However, the closure throws an error when it encounters `4`. The publisher then terminates with this error.
    ///
    ///     struct BadValuesError: Error {}
    ///     let numbers = [0, 0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
    ///     cancellable = numbers.publisher
    ///         .tryRemoveDuplicates { first, second -> Bool in
    ///             if (first == 4 && second == 4) {
    ///                 throw BadValuesError()
    ///             }
    ///             return first == second
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("\($0)") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///          )
    ///
    ///      // Prints: "0 1 2 3 4 failure(BadValuesError()"
    ///
    /// - Parameter predicate: A closure to evaluate whether two elements are equivalent, for purposes of filtering. Return `true` from this closure to indicate that the second element is a duplicate of the first. If this closure throws an error, the publisher terminates with the thrown error.
    /// - Returns: A publisher that consumes — rather than publishes — duplicate elements.
    public func czTryRemoveDuplicates(by predicate: @escaping (Self.Output, Self.Output) throws -> Bool) -> Publishers.CZTryRemoveDuplicates<Self> {
        return Publishers.CZTryRemoveDuplicates(inner: self.tryRemoveDuplicates(by: predicate), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Decodes the output from the upstream using a specified decoder.
    ///
    /// Use ``Publisher/decode(type:decoder:)`` with a <doc://com.apple.documentation/documentation/Foundation/JSONDecoder> (or a <doc://com.apple.documentation/documentation/Foundation/PropertyListDecoder> for property lists) to decode data received from a <doc://com.apple.documentation/documentation/Foundation/URLSession/DataTaskPublisher> or other data source using the <doc://com.apple.documentation/documentation/Swift/Decodable> protocol.
    ///
    /// In this example, a ``PassthroughSubject`` publishes a JSON string. The JSON decoder parses the string, converting its fields according to the <doc://com.apple.documentation/documentation/Swift/Decodable> protocol implemented by `Article`, and successfully populating a new `Article`. The ``Publishers/Decode`` publisher then publishes the `Article` to the downstream. If a decoding operation fails, which happens in the case of missing or malformed data in the source JSON string, the stream terminates and passes the error to the downstream subscriber.
    ///
    ///     struct Article: Codable {
    ///         let title: String
    ///         let author: String
    ///         let pubDate: Date
    ///     }
    ///
    ///     let dataProvider = PassthroughSubject<Data, Never>()
    ///     cancellable = dataProvider
    ///         .decode(type: Article.self, decoder: JSONDecoder())
    ///         .sink(receiveCompletion: { print ("Completion: \($0)")},
    ///               receiveValue: { print ("value: \($0)") })
    ///
    ///     dataProvider.send(Data("{\"pubDate\":1574273638.575666, \"title\" : \"My First Article\", \"author\" : \"Gita Kumar\" }".utf8))
    ///
    ///     // Prints: ".sink() data received Article(title: "My First Article", author: "Gita Kumar", pubDate: 2050-11-20 18:13:58 +0000)"
    ///
    /// - Parameters:
    ///   - type: The encoded data to decode into a struct that conforms to the <doc://com.apple.documentation/documentation/Swift/Decodable> protocol.
    ///   - decoder:  A decoder that implements the ``TopLevelDecoder`` protocol.
    /// - Returns: A publisher that decodes a given type using a specified decoder and publishes the result.
    public func czDecode<Item, Coder>(type: Item.Type, decoder: Coder) -> Publishers.CZDecode<Self, Item, Coder> where Item : Decodable, Coder : TopLevelDecoder, Self.Output == Coder.Input {
        return Publishers.CZDecode(inner: self.decode(type: type, decoder: decoder), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Output : Encodable {
    
    /// Encodes the output from upstream using a specified encoder.
    ///
    /// Use ``Publisher/encode(encoder:)`` with a <doc://com.apple.documentation/documentation/Foundation/JSONDecoder> (or a <doc://com.apple.documentation/documentation/Foundation/PropertyListDecoder> for property lists) to encode an <doc://com.apple.documentation/documentation/Swift/Encodable> struct into <doc://com.apple.documentation/documentation/Foundation/Data> that could be used to make a JSON string (or written to disk as a binary plist in the case of property lists).
    ///
    /// In this example, a ``PassthroughSubject`` publishes an `Article`. The ``Publisher/encode(encoder:)`` operator encodes the properties of the `Article` struct into a new JSON string according to the <doc://com.apple.documentation/documentation/Swift/Codable> protocol adopted by `Article`. The operator publishes the resulting JSON string to the downstream subscriber. If the encoding operation fails, which can happen in the case of complex properties that can’t be directly transformed into JSON, the stream terminates and the error is passed to the downstream subscriber.
    ///
    ///     struct Article: Codable {
    ///         let title: String
    ///         let author: String
    ///         let pubDate: Date
    ///     }
    ///
    ///     let dataProvider = PassthroughSubject<Article, Never>()
    ///     let cancellable = dataProvider
    ///         .encode(encoder: JSONEncoder())
    ///         .sink(receiveCompletion: { print ("Completion: \($0)") },
    ///               receiveValue: {  data in
    ///                 guard let stringRepresentation = String(data: data, encoding: .utf8) else { return }
    ///                 print("Data received \(data) string representation: \(stringRepresentation)")
    ///         })
    ///
    ///     dataProvider.send(Article(title: "My First Article", author: "Gita Kumar", pubDate: Date()))
    ///
    ///     // Prints: "Data received 86 bytes string representation: {"title":"My First Article","author":"Gita Kumar","pubDate":606211803.279603}"
    ///
    /// - Parameter encoder: An encoder that implements the ``TopLevelEncoder`` protocol.
    /// - Returns: A publisher that encodes received elements using a specified encoder, and publishes the resulting data.
    public func czEncode<Coder>(encoder: Coder) -> Publishers.CZEncode<Self, Coder> where Coder : TopLevelEncoder {
        return Publishers.CZEncode(inner: self.encode(encoder: encoder), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Output : Equatable {

    /// Publishes a Boolean value upon receiving an element equal to the argument.
    ///
    /// Use ``Publisher/contains(_:)`` to find the first element in an upstream that’s equal to the supplied argument. The contains publisher consumes all received elements until the upstream publisher produces a matching element. Upon finding the first match, it emits `true` and finishes normally. If the upstream finishes normally without producing a matching element, this publisher emits `false` and finishes.
    ///
    /// In the example below, the ``Publisher/contains(_:)`` operator emits `true` the first time it receives the value `5` from the `numbers.publisher`, and then finishes normally.
    ///
    ///     let numbers = [-1, 5, 10, 5]
    ///     numbers.publisher
    ///         .contains(5)
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "true"
    ///
    /// - Parameter output: An element to match against.
    /// - Returns: A publisher that emits the Boolean value `true` when the upstream publisher emits a matching value.
    public func czContains(_ output: Self.Output) -> Publishers.CZContains<Self> {
        return Publishers.CZContains(inner: self.contains(output), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Subscribes to an additional publisher and publishes a tuple upon receiving output from either publisher.
    ///
    /// Use ``Publisher/combineLatest(_:)`` when you want the downstream subscriber to receive a tuple of the most-recent element from multiple publishers when any of them emit a value. To pair elements from multiple publishers, use ``Publisher/zip(_:)`` instead. To receive just the most-recent element from multiple publishers rather than tuples, use ``Publisher/merge(with:)-7qt71``.
    ///
    /// > Tip: The combined publisher doesn't produce elements until each of its upstream publishers publishes at least one element.
    ///
    /// The combined publisher passes through any requests to *all* upstream publishers. However, it still obeys the demand-fulfilling rule of only sending the request amount downstream. If the demand isn’t ``Subscribers/Demand/unlimited``, it drops values from upstream publishers. It implements this by using a buffer size of 1 for each upstream, and holds the most-recent value in each buffer.
    ///
    /// In this example, ``PassthroughSubject`` `pub1` and also `pub2` emit values; as ``Publisher/combineLatest(_:)`` receives input from either upstream publisher, it combines the latest value from each publisher into a tuple and publishes it.
    ///
    ///     let pub1 = PassthroughSubject<Int, Never>()
    ///     let pub2 = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pub1
    ///         .combineLatest(pub2)
    ///         .sink { print("Result: \($0).") }
    ///
    ///     pub1.send(1)
    ///     pub1.send(2)
    ///     pub2.send(2)
    ///     pub1.send(3)
    ///     pub1.send(45)
    ///     pub2.send(22)
    ///
    ///     // Prints:
    ///     //    Result: (2, 2).    // pub1 latest = 2, pub2 latest = 2
    ///     //    Result: (3, 2).    // pub1 latest = 3, pub2 latest = 2
    ///     //    Result: (45, 2).   // pub1 latest = 45, pub2 latest = 2
    ///     //    Result: (45, 22).  // pub1 latest = 45, pub2 latest = 22
    ///
    /// When all upstream publishers finish, this publisher finishes. If an upstream publisher never publishes a value, this publisher never finishes.
    ///
    /// - Parameter other: Another publisher to combine with this one.
    /// - Returns: A publisher that receives and combines elements from this and another publisher.
    public func czCombineLatest<P>(_ other: P) -> Publishers.CZCombineLatest<Self, P> where P : Publisher, Self.Failure == P.Failure {
        return Publishers.CZCombineLatest(inner: self.combineLatest(other), uuid: self.generateUUID())
    }

    ///     cancellable = pub1
    ///         .combineLatest(pub2) { (first, second) in
    ///             return first * second
    ///         }
    ///         .sink { print("Result: \($0).") }
    ///
    ///     pub1.send(1)
    ///     pub1.send(2)
    ///     pub2.send(2)
    ///     pub1.send(9)
    ///     pub1.send(3)
    ///     pub2.send(12)
    ///     pub1.send(13)
    ///     //
    ///     // Prints:
    ///     //Result: 4.    (pub1 latest = 2, pub2 latest = 2)
    ///     //Result: 18.   (pub1 latest = 9, pub2 latest = 2)
    ///     //Result: 6.    (pub1 latest = 3, pub2 latest = 2)
    ///     //Result: 36.   (pub1 latest = 3, pub2 latest = 12)
    ///     //Result: 156.  (pub1 latest = 13, pub2 latest = 12)
    ///
    /// All upstream publishers need to finish for this publisher to finish. If an upstream publisher never publishes a value, this publisher never finishes.
    /// If any of the combined publishers terminates with a failure, this publisher also fails.
    ///
    /// - Parameters:
    ///   - other: Another publisher to combine with this one.
    ///   - transform: A closure that receives the most-recent value from each publisher and returns a new value to publish.
    /// - Returns: A publisher that receives and combines elements from this and another publisher.
    public func czCombineLatest<P, T>(_ other: P, _ transform: @escaping (Self.Output, P.Output) -> T) -> Publishers.CZMap<Publishers.CombineLatest<Self, P>, T> where P : Publisher, Self.Failure == P.Failure {
        return Publishers.CZMap(inner: self.combineLatest(other, transform), uuid: self.generateUUID())
    }

    /// Subscribes to two additional publishers and publishes a tuple upon receiving output from any of the publishers.
    ///
    /// Use ``Publisher/combineLatest(_:_:)-5crqg`` when you want the downstream subscriber to receive a tuple of the most-recent element from multiple publishers when any of them emit a value. To combine elements from multiple publishers, use ``Publisher/zip(_:_:)-8d7k7`` instead. To receive just the most-recent element from multiple publishers rather than tuples, use ``Publisher/merge(with:_:)``.
    ///
    /// > Tip: The combined publisher doesn't produce elements until each of its upstream publishers publishes at least one element.
    ///
    /// The combined publisher passes through any requests to *all* upstream publishers. However, it still obeys the demand-fulfilling rule of only sending the request amount downstream. If the demand isn’t ``Subscribers/Demand/unlimited``, it drops values from upstream publishers. It implements this by using a buffer size of 1 for each upstream, and holds the most-recent value in each buffer.
    ///
    /// All upstream publishers need to finish for this publisher to finish. If an upstream publisher never publishes a value, this publisher never finishes.
    ///
    /// In this example, three instances of ``PassthroughSubject`` emit values; as ``Publisher/combineLatest(_:_:)-5crqg`` receives input from any of the upstream publishers, it combines the latest value from each publisher into a tuple and publishes it:
    ///
    ///     let pub = PassthroughSubject<Int, Never>()
    ///     let pub2 = PassthroughSubject<Int, Never>()
    ///     let pub3 = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pub
    ///         .combineLatest(pub2, pub3)
    ///         .sink { print("Result: \($0).") }
    ///
    ///     pub.send(1)
    ///     pub.send(2)
    ///     pub2.send(2)
    ///     pub3.send(9)
    ///
    ///     pub.send(3)
    ///     pub2.send(12)
    ///     pub.send(13)
    ///     pub3.send(19)
    ///
    ///     // Prints:
    ///     //  Result: (2, 2, 9).
    ///     //  Result: (3, 2, 9).
    ///     //  Result: (3, 12, 9).
    ///     //  Result: (13, 12, 9).
    ///     //  Result: (13, 12, 19).
    ///
    /// If any of the combined publishers terminates with a failure, this publisher also fails.
    /// - Parameters:
    ///   - publisher1: A second publisher to combine with the first publisher.
    ///   - publisher2: A third publisher to combine with the first publisher.
    /// - Returns: A publisher that receives and combines elements from this publisher and two other publishers.
    public func czCombineLatest<P, Q>(_ publisher1: P, _ publisher2: Q) -> Publishers.CZCombineLatest3<Self, P, Q> where P : Publisher, Q : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure {
        return Publishers.CZCombineLatest3(inner: self.combineLatest(publisher1, publisher2), uuid: self.generateUUID())
    }

    /// Subscribes to two additional publishers and invokes a closure upon receiving output from any of the publishers.
    ///
    /// Use `combineLatest<P, Q>(_:,_:)` to combine the current and two additional publishers and transform them using a closure you specify to publish a new value to the downstream.
    ///
    /// > Tip: The combined publisher doesn't produce elements until each of its upstream publishers publishes at least one element.
    ///
    /// The combined publisher passes through any requests to *all* upstream publishers. However, it still obeys the demand-fulfilling rule of only sending the request amount downstream. If the demand isn’t `.unlimited`, it drops values from upstream publishers. It implements this by using a buffer size of 1 for each upstream, and holds the most-recent value in each buffer.
    /// All upstream publishers need to finish for this publisher to finish. If an upstream publisher never publishes a value, this publisher never finishes.
    /// If any of the combined publishers terminates with a failure, this publisher also fails.
    ///
    /// In the example below, `combineLatest()` receives the most-recent values published by three publishers, multiplies them together, and republishes the result:
    ///
    ///     let pub = PassthroughSubject<Int, Never>()
    ///     let pub2 = PassthroughSubject<Int, Never>()
    ///     let pub3 = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pub
    ///         .combineLatest(pub2, pub3) { firstValue, secondValue, thirdValue in
    ///             return firstValue * secondValue * thirdValue
    ///         }
    ///         .sink { print("Result: \($0).") }
    ///
    ///     pub.send(1)
    ///     pub.send(2)
    ///     pub2.send(2)
    ///     pub3.send(10)
    ///
    ///     pub.send(9)
    ///     pub3.send(4)
    ///     pub2.send(12)
    ///
    ///     // Prints:
    ///     //  Result: 40.     // pub = 2, pub2 = 2, pub3 = 10
    ///     //  Result: 180.    // pub = 9, pub2 = 2, pub3 = 10
    ///     //  Result: 72.     // pub = 9, pub2 = 2, pub3 = 4
    ///     //  Result: 432.    // pub = 9, pub2 = 12, pub3 = 4
    ///
    /// - Parameters:
    ///   - publisher1: A second publisher to combine with the first publisher.
    ///   - publisher2: A third publisher to combine with the first publisher.
    ///   - transform: A closure that receives the most-recent value from each publisher and returns a new value to publish.
    /// - Returns: A publisher that receives and combines elements from this publisher and two other publishers.
    public func czCombineLatest<P, Q, T>(_ publisher1: P, _ publisher2: Q, _ transform: @escaping (Self.Output, P.Output, Q.Output) -> T) -> Publishers.CZMap<Publishers.CombineLatest3<Self, P, Q>, T> where P : Publisher, Q : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure {
        return Publishers.CZMap(inner: self.combineLatest(publisher1, publisher2, transform), uuid: self.generateUUID())
    }

    /// Subscribes to three additional publishers and publishes a tuple upon receiving output from any of the publishers.
    ///
    /// Use ``Publisher/combineLatest(_:_:_:)-48buc`` when you want the downstream subscriber to receive a tuple of the most-recent element from multiple publishers when any of them emit a value. To combine elements from multiple publishers, use ``Publisher/zip(_:_:_:)-16rcy`` instead. To receive just the most-recent element from multiple publishers rather than tuples, use ``Publisher/merge(with:_:_:)``.
    ///
    /// > Tip: The combined publisher doesn't produce elements until each of its upstream publishers publishes at least one element.
    ///
    /// The combined publisher passes through any requests to *all* upstream publishers. However, it still obeys the demand-fulfilling rule of only sending the request amount downstream. If the demand isn’t ``Subscribers/Demand/unlimited``, it drops values from upstream publishers. It implements this by using a buffer size of 1 for each upstream, and holds the most-recent value in each buffer.
    ///
    /// All upstream publishers need to finish for this publisher to finish. If an upstream publisher never publishes a value, this publisher never finishes.
    ///
    /// In the example below, ``Publisher/combineLatest(_:_:_:)-48buc`` receives input from any of the publishers, combines the latest value from each publisher into a tuple and publishes it:
    ///
    ///     let pub = PassthroughSubject<Int, Never>()
    ///     let pub2 = PassthroughSubject<Int, Never>()
    ///     let pub3 = PassthroughSubject<Int, Never>()
    ///     let pub4 = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pub
    ///         .combineLatest(pub2, pub3, pub4)
    ///         .sink { print("Result: \($0).") }
    ///
    ///     pub.send(1)
    ///     pub.send(2)
    ///     pub2.send(2)
    ///     pub3.send(9)
    ///     pub4.send(1)
    ///
    ///     pub.send(3)
    ///     pub2.send(12)
    ///     pub.send(13)
    ///     pub3.send(19)
    ///     //
    ///     // Prints:
    ///     //  Result: (2, 2, 9, 1).
    ///     //  Result: (3, 2, 9, 1).
    ///     //  Result: (3, 12, 9, 1).
    ///     //  Result: (13, 12, 9, 1).
    ///     //  Result: (13, 12, 19, 1).
    ///
    /// If any individual publisher of the combined set terminates with a failure, this publisher also fails.
    ///
    /// - Parameters:
    ///   - publisher1: A second publisher to combine with the first publisher.
    ///   - publisher2: A third publisher to combine with the first publisher.
    ///   - publisher3: A fourth publisher to combine with the first publisher.
    /// - Returns: A publisher that receives and combines elements from this publisher and three other publishers.
    public func czCombineLatest<P, Q, R>(_ publisher1: P, _ publisher2: Q, _ publisher3: R) -> Publishers.CZCombineLatest4<Self, P, Q, R> where P : Publisher, Q : Publisher, R : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure, Q.Failure == R.Failure {
        return Publishers.CZCombineLatest4(inner: self.combineLatest(publisher1, publisher2, publisher3), uuid: self.generateUUID())
    }

    /// Subscribes to three additional publishers and invokes a closure upon receiving output from any of the publishers.
    ///
    /// Use ``Publisher/combineLatest(_:_:_:_:)`` when you need to combine the current and 3 additional publishers and transform the values using a closure in which you specify the published elements, to publish a new element.
    ///
    /// > Tip: The combined publisher doesn't produce elements until each of its upstream publishers publishes at least one element.
    ///
    /// The combined publisher passes through any requests to *all* upstream publishers. However, it still obeys the demand-fulfilling rule of only sending the request amount downstream. If the demand isn’t ``Subscribers/Demand/unlimited``, it drops values from upstream publishers. It implements this by using a buffer size of 1 for each upstream, and holds the most-recent value in each buffer.
    ///
    /// All upstream publishers need to finish for this publisher to finish. If an upstream publisher never publishes a value, this publisher never finishes.
    ///
    /// In the example below, as ``Publisher/combineLatest(_:_:_:_:)`` receives the most-recent values published by four publishers, multiplies them together, and republishes the result:
    ///
    ///     let pub = PassthroughSubject<Int, Never>()
    ///     let pub2 = PassthroughSubject<Int, Never>()
    ///     let pub3 = PassthroughSubject<Int, Never>()
    ///     let pub4 = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pub
    ///         .combineLatest(pub2, pub3, pub4) { firstValue, secondValue, thirdValue, fourthValue in
    ///             return firstValue * secondValue * thirdValue * fourthValue
    ///         }
    ///         .sink { print("Result: \($0).") }
    ///
    ///     pub.send(1)
    ///     pub.send(2)
    ///     pub2.send(2)
    ///     pub3.send(9)
    ///     pub4.send(1)
    ///
    ///     pub.send(3)
    ///     pub2.send(12)
    ///     pub.send(13)
    ///     pub3.send(19)
    ///
    ///     // Prints:
    ///     //  Result: 36.     // pub = 2,  pub2 = 2,   pub3 = 9,  pub4 = 1
    ///     //  Result: 54.     // pub = 3,  pub2 = 2,   pub3 = 9,  pub4 = 1
    ///     //  Result: 324.    // pub = 3,  pub2 = 12,  pub3 = 9,  pub4 = 1
    ///     //  Result: 1404.   // pub = 13, pub2 = 12,  pub3 = 9,  pub4 = 1
    ///     //  Result: 2964.   // pub = 13, pub2 = 12,  pub3 = 19, pub4 = 1
    ///
    /// - Parameters:
    ///   - publisher1: A second publisher to combine with the first publisher.
    ///   - publisher2: A third publisher to combine with the first publisher.
    ///   - publisher3: A fourth publisher to combine with the first publisher.
    ///   - transform: A closure that receives the most-recent value from each publisher and returns a new value to publish.
    /// - Returns: A publisher that receives and combines elements from this publisher and three other publishers.
    public func czCombineLatest<P, Q, R, T>(_ publisher1: P, _ publisher2: Q, _ publisher3: R, _ transform: @escaping (Self.Output, P.Output, Q.Output, R.Output) -> T) -> Publishers.CZMap<Publishers.CombineLatest4<Self, P, Q, R>, T> where P : Publisher, Q : Publisher, R : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure, Q.Failure == R.Failure {
        return Publishers.CZMap(inner: self.combineLatest(publisher1, publisher2, publisher3, transform), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Republishes elements up to the specified maximum count.
    ///
    /// Use ``Publisher/prefix(_:)`` to limit the number of elements republished to the downstream subscriber.
    ///
    /// In the example below, the ``Publisher/prefix(_:)`` operator limits its output to the first two elements before finishing normally:
    ///
    ///     let numbers = (0...10)
    ///     cancellable = numbers.publisher
    ///         .prefix(2)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1"
    ///
    /// - Parameter maxLength: The maximum number of elements to republish.
    /// - Returns: A publisher that publishes up to the specified number of elements.
    public func czPrefix(_ maxLength: Int) -> Publishers.CZOutput<Self> {
        return Publishers.CZOutput(inner: self.prefix(maxLength), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Prints log messages for all publishing events.
    ///
    /// Use ``Publisher/print(_:to:)`` to log messages the console.
    ///
    /// In the example below, log messages are printed on the console:
    ///
    ///     let integers = (1...2)
    ///     cancellable = integers.publisher
    ///        .print("Logged a message", to: nil)
    ///        .sink { _ in }
    ///
    ///     // Prints:
    ///     //  Logged a message: receive subscription: (1..<2)
    ///     //  Logged a message: request unlimited
    ///     //  Logged a message: receive value: (1)
    ///     //  Logged a message: receive finished
    ///
    /// - Parameters:
    ///   - prefix: A string —- which defaults to empty -— with which to prefix all log messages.
    ///   - stream: A stream for text output that receives messages, and which directs output to the console by default.  A custom stream can be used to log messages to other destinations.
    /// - Returns: A publisher that prints log messages for all publishing events.
    public func czPrint(_ prefix: String = "", to stream: TextOutputStream? = nil) -> Publishers.CZPrint<Self> {
        return Publishers.CZPrint(inner: self.print(prefix, to: stream), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Republishes elements while a predicate closure indicates publishing should continue.
    ///
    /// Use ``Publisher/prefix(while:)`` to emit values while elements from the upstream publisher meet a condition you specify. The publisher finishes when the closure returns `false`.
    ///
    /// In the example below, the ``Publisher/prefix(while:)`` operator emits values while the element it receives is less than five:
    ///
    ///     let numbers = (0...10)
    ///     numbers.publisher
    ///         .prefix { $0 < 5 }
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1 2 3 4"
    ///
    /// - Parameter predicate: A closure that takes an element as its parameter and returns a Boolean value that indicates whether publishing should continue.
    /// - Returns: A publisher that passes through elements until the predicate indicates publishing should finish.
    public func czPrefix(while predicate: @escaping (Self.Output) -> Bool) -> Publishers.CZPrefixWhile<Self> {
        return Publishers.CZPrefixWhile(inner: self.prefix(while: predicate), uuid: self.generateUUID())
    }

    /// Republishes elements while an error-throwing predicate closure indicates publishing should continue.
    ///
    /// Use ``Publisher/tryPrefix(while:)`` to emit values from the upstream publisher that meet a condition you specify in an error-throwing closure.
    /// The publisher finishes when the closure returns `false`. If the closure throws an error, the publisher fails with that error.
    ///
    ///     struct OutOfRangeError: Error {}
    ///
    ///     let numbers = (0...10).reversed()
    ///     cancellable = numbers.publisher
    ///         .tryPrefix {
    ///             guard $0 != 0 else {throw OutOfRangeError()}
    ///             return $0 <= numbers.max()!
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)", terminator: " ") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///         )
    ///
    ///     // Prints: "10 9 8 7 6 5 4 3 2 1 completion: failure(OutOfRangeError()) "
    ///
    /// - Parameter predicate: A closure that takes an element as its parameter and returns a Boolean value indicating whether publishing should continue.
    /// - Returns: A publisher that passes through elements until the predicate throws or indicates publishing should finish.
    public func czTryPrefix(while predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.CZTryPrefixWhile<Self> {
        return Publishers.CZTryPrefixWhile(inner: self.tryPrefix(while: predicate), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Failure == Never {

    /// Changes the failure type declared by the upstream publisher.
    ///
    /// Use ``Publisher/setFailureType(to:)`` when you need set the error type of a publisher that cannot fail.
    ///
    /// Conversely, if the upstream can fail, you would use ``Publisher/mapError(_:)`` to provide instructions on converting the error types to needed by the downstream publisher’s inputs.
    ///
    /// The following example has two publishers with mismatched error types: `pub1`’s error type is <doc://com.apple.documentation/documentation/Swift/Never>, and `pub2`’s error type is <doc://com.apple.documentation/documentation/Swift/Error>. Because of the mismatch, the ``Publisher/combineLatest(_:)`` operator requires that `pub1` use ``Publisher/setFailureType(to:)`` to make it appear that `pub1` can produce the <doc://com.apple.documentation/documentation/Swift/Error> type, like `pub2` can.
    ///
    ///     let pub1 = [0, 1, 2, 3, 4, 5].publisher
    ///     let pub2 = CurrentValueSubject<Int, Error>(0)
    ///     let cancellable = pub1
    ///         .setFailureType(to: Error.self)
    ///         .combineLatest(pub2)
    ///         .sink(
    ///             receiveCompletion: { print ("completed: \($0)") },
    ///             receiveValue: { print ("value: \($0)")}
    ///          )
    ///
    ///     // Prints: "value: (5, 0)".
    ///
    /// - Parameter failureType: The `Failure` type presented by this publisher.
    /// - Returns: A publisher that appears to send the specified failure type.
    public func czSetFailureType<E>(to failureType: E.Type) -> Publishers.CZSetFailureType<Self, E> where E : Error {
        return Publishers.CZSetFailureType(inner: self.setFailureType(to: failureType), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes a Boolean value upon receiving an element that satisfies the predicate closure.
    ///
    /// Use ``Publisher/contains(where:)`` to find the first element in an upstream that satisfies the closure you provide. This operator consumes elements produced from the upstream publisher until the upstream publisher produces a matching element.
    ///
    /// This operator is useful when the upstream publisher produces elements that don’t conform to `Equatable`.
    ///
    /// In the example below, the ``Publisher/contains(where:)`` operator tests elements against the supplied closure and emits `true` for the first elements that’s greater than `4`, and then finishes normally.
    ///
    ///     let numbers = [-1, 0, 10, 5]
    ///     numbers.publisher
    ///         .contains {$0 > 4}
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "true"
    ///
    /// - Parameter predicate: A closure that takes an element as its parameter and returns a Boolean value that indicates whether the element satisfies the closure’s comparison logic.
    /// - Returns: A publisher that emits the Boolean value `true` when the upstream  publisher emits a matching value.
    public func czContains(where predicate: @escaping (Self.Output) -> Bool) -> Publishers.CZContainsWhere<Self> {
        return Publishers.CZContainsWhere(inner: self.contains(where: predicate), uuid: self.generateUUID())
    }

    /// Publishes a Boolean value upon receiving an element that satisfies the throwing predicate closure.
    ///
    /// Use ``Publisher/tryContains(where:)`` to find the first element in an upstream that satisfies the error-throwing closure you provide.
    ///
    /// This operator consumes elements produced from the upstream publisher until the upstream publisher either:
    ///
    /// - Produces a matching element, after which it emits `true` and the publisher finishes normally.
    /// - Emits `false` if no matching element is found and the publisher finishes normally.
    ///
    /// If the predicate throws an error, the publisher fails, passing the error to its downstream.
    ///
    /// In the example below, the ``Publisher/tryContains(where:)`` operator tests values to find an element less than `10`; when the closure finds an odd number, like `3`, the publisher terminates with an `IllegalValueError`.
    ///
    ///     struct IllegalValueError: Error {}
    ///
    ///     let numbers = [3, 2, 10, 5, 0, 9]
    ///     numbers.publisher
    ///         .tryContains {
    ///             if ($0 % 2 != 0) {
    ///                 throw IllegalValueError()
    ///             }
    ///            return $0 < 10
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)") },
    ///             receiveValue: { print ("value: \($0)") }
    ///         )
    ///
    ///     // Prints: "completion: failure(IllegalValueError())"
    ///
    /// - Parameter predicate: A closure that takes an element as its parameter and returns a Boolean value that indicates whether the element satisfies the closure’s comparison logic.
    /// - Returns: A publisher that emits the Boolean value `true` when the upstream publisher emits a matching value.
    public func czTryContains(where predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.CZTryContainsWhere<Self> {
        return Publishers.CZTryContainsWhere(inner: self.tryContains(where: predicate), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Failure == Never {

    /// Creates a connectable wrapper around the publisher.
    ///
    /// In the following example, ``Publisher/makeConnectable()`` wraps its upstream publisher (an instance of ``Publishers/Share``) with a ``ConnectablePublisher``. Without this, the first sink subscriber would receive all the elements from the sequence publisher and cause it to complete before the second subscriber attaches. By making the publisher connectable, the publisher doesn’t produce any elements until after the ``ConnectablePublisher/connect()`` call.
    ///
    ///      let subject = Just<String>("Sent")
    ///      let pub = subject
    ///          .share()
    ///          .makeConnectable()
    ///      cancellable1 = pub.sink { print ("Stream 1 received: \($0)")  }
    ///
    ///      // For example purposes, use DispatchQueue to add a second subscriber
    ///      // a second later, and then connect to the publisher a second after that.
    ///      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    ///          self.cancellable2 = pub.sink { print ("Stream 2 received: \($0)") }
    ///      }
    ///      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    ///          self.connectable = pub.connect()
    ///      }
    ///      // Prints:
    ///      // Stream 2 received: Sent
    ///      // Stream 1 received: Sent
    ///
    ///  > Note: The ``ConnectablePublisher/connect()`` operator returns a ``Cancellable`` instance that you must retain. You can also use this instance to cancel publishing.
    ///
    /// - Returns: A ``ConnectablePublisher`` wrapping this publisher.
    public func czMakeConnectable() -> Publishers.CZMakeConnectable<Self> {
        return Publishers.CZMakeConnectable(inner: self.makeConnectable(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Collects all received elements, and emits a single array of the collection when the upstream publisher finishes.
    ///
    /// Use ``Publisher/collect()`` to gather elements into an array that the operator emits after the upstream publisher finishes.
    ///
    /// If the upstream publisher fails with an error, this publisher forwards the error to the downstream receiver instead of sending its output.
    ///
    /// This publisher requests an unlimited number of elements from the upstream publisher and uses an unbounded amount of memory to store the received values. The publisher may exert memory pressure on the system for very large sets of elements.
    ///
    /// The ``Publisher/collect()`` operator only sends the collected array to its downstream receiver after a request whose demand is greater than 0 items. Otherwise, ``Publisher/collect()`` waits until it receives a non-zero request.
    ///
    /// In the example below, an Integer range is a publisher that emits an array of integers:
    ///
    ///     let numbers = (0...10)
    ///     cancellable = numbers.publisher
    ///         .collect()
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]"
    ///
    /// - Returns: A publisher that collects all received items and returns them as an array upon completion.
    public func czCollect() -> Publishers.CZCollect<Self> {
        return Publishers.CZCollect(inner: self.collect(), uuid: self.generateUUID())
    }

    /// Collects up to the specified number of elements, and then emits a single array of the collection.
    ///
    /// Use ``Publisher/collect(_:)`` to emit arrays of at most `count` elements from an upstream publisher. If the upstream publisher finishes before collecting the specified number of elements, the publisher sends an array of only the items it received. This may be fewer than `count` elements.
    ///
    /// If the upstream publisher fails with an error, this publisher forwards the error to the downstream receiver instead of sending its output.
    ///
    /// In the example below, the ``Publisher/collect(_:)`` operator emits one partial and two full arrays based on the requested collection size of `5`:
    ///
    ///     let numbers = (0...10)
    ///     cancellable = numbers.publisher
    ///         .collect(5)
    ///         .sink { print("\($0), terminator: " "") }
    ///
    ///     // Prints "[0, 1, 2, 3, 4] [5, 6, 7, 8, 9] [10] "
    ///
    /// > Note: When this publisher receives a request for `.max(n)` elements, it requests `.max(count * n)` from the upstream publisher.
    ///
    /// - Parameter count: The maximum number of received elements to buffer before publishing.
    /// - Returns: A publisher that collects up to the specified number of elements, and then publishes them as an array.
    public func czCollect(_ count: Int) -> Publishers.CZCollectByCount<Self> {
        return Publishers.CZCollectByCount(inner: self.collect(count), uuid: self.generateUUID())
    }

    /// Collects elements by a given time-grouping strategy, and emits a single array of the collection.
    ///
    /// Use ``Publisher/collect(_:options:)`` to emit arrays of elements on a schedule specified by a ``Scheduler`` and `Stride` that you provide. At the end of each scheduled interval, the publisher sends an array that contains the items it collected. If the upstream publisher finishes before filling the buffer, the publisher sends an array that contains items it received. This may be fewer than the number of elements specified in the requested `Stride`.
    ///
    /// If the upstream publisher fails with an error, this publisher forwards the error to the downstream receiver instead of sending its output.
    ///
    /// The example above collects timestamps generated on a one-second <doc://com.apple.documentation/documentation/Foundation/Timer> in groups (`Stride`) of five.
    ///
    ///     let sub = Timer.publish(every: 1, on: .main, in: .default)
    ///         .autoconnect()
    ///         .collect(.byTime(RunLoop.main, .seconds(5)))
    ///         .sink { print("\($0)", terminator: "\n\n") }
    ///
    ///     // Prints: "[2020-01-24 00:54:46 +0000, 2020-01-24 00:54:47 +0000,
    ///     //          2020-01-24 00:54:48 +0000, 2020-01-24 00:54:49 +0000,
    ///     //          2020-01-24 00:54:50 +0000]"
    ///
    /// > Note: When this publisher receives a request for `.max(n)` elements, it requests `.max(count * n)` from the upstream publisher.
    ///
    /// - Parameters:
    ///   - strategy: The timing group strategy used by the operator to collect and publish elements.
    ///   - options: Scheduler options to use for the strategy.
    /// - Returns: A publisher that collects elements by a given strategy, and emits a single array of the collection.
    public func czCollect<S>(_ strategy: Publishers.TimeGroupingStrategy<S>, options: S.SchedulerOptions? = nil) -> Publishers.CZCollectByTime<Self, S> where S : Scheduler {
        return Publishers.CZCollectByTime(inner: self.collect(strategy, options: options), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Specifies the scheduler on which to receive elements from the publisher.
    ///
    /// You use the ``Publisher/receive(on:options:)`` operator to receive results and completion on a specific scheduler, such as performing UI work on the main run loop. In contrast with ``Publisher/subscribe(on:options:)``, which affects upstream messages, ``Publisher/receive(on:options:)`` changes the execution context of downstream messages.
    ///
    /// In the following example, the ``Publisher/subscribe(on:options:)`` operator causes `jsonPublisher` to receive requests on `backgroundQueue`, while the
    /// ``Publisher/receive(on:options:)`` causes `labelUpdater` to receive elements and completion on `RunLoop.main`.
    ///
    ///     let jsonPublisher = MyJSONLoaderPublisher() // Some publisher.
    ///     let labelUpdater = MyLabelUpdateSubscriber() // Some subscriber that updates the UI.
    ///
    ///     jsonPublisher
    ///         .subscribe(on: backgroundQueue)
    ///         .receive(on: RunLoop.main)
    ///         .subscribe(labelUpdater)
    ///
    ///
    /// Prefer ``Publisher/receive(on:options:)`` over explicit use of dispatch queues when performing work in subscribers. For example, instead of the following pattern:
    ///
    ///     pub.sink {
    ///         DispatchQueue.main.async {
    ///             // Do something.
    ///         }
    ///     }
    ///
    /// Use this pattern instead:
    ///
    ///     pub.receive(on: DispatchQueue.main).sink {
    ///         // Do something.
    ///     }
    ///
    ///  > Note: ``Publisher/receive(on:options:)`` doesn’t affect the scheduler used to call the subscriber’s ``Subscriber/receive(subscription:)`` method.
    ///
    /// - Parameters:
    ///   - scheduler: The scheduler the publisher uses for element delivery.
    ///   - options: Scheduler options used to customize element delivery.
    /// - Returns: A publisher that delivers elements using the specified scheduler.
    public func czReceive<S>(on scheduler: S, options: S.SchedulerOptions? = nil) -> Publishers.CZReceiveOn<Self, S> where S : Scheduler {
        return Publishers.CZReceiveOn(inner: self.receive(on: scheduler, options: options), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes the value of a key path.
    ///
    /// In the following example, the ``Publisher/map(_:)-6sm0a`` operator uses the Swift key path syntax to access the `die` member of the `DiceRoll` structure published by the ``Just`` publisher.
    ///
    /// The downstream sink subscriber receives only the value of this `Int`, not the entire `DiceRoll`.
    ///
    ///     struct DiceRoll {
    ///         let die: Int
    ///     }
    ///
    ///     cancellable = Just(DiceRoll(die:Int.random(in:1...6)))
    ///         .map(\.die)
    ///         .sink {
    ///             print ("Rolled: \($0)")
    ///         }
    ///     // Prints "Rolled: 3" (or some other random value).
    ///
    /// - Parameter keyPath: The key path of a property on `Output`.
    /// - Returns: A publisher that publishes the value of the key path.
    public func czMap<T>(_ keyPath: KeyPath<Self.Output, T>) -> Publishers.CZMapKeyPath<Self, T> {
        return Publishers.CZMapKeyPath(inner: self.map(keyPath), uuid: self.generateUUID())
    }

    /// Publishes the values of two key paths as a tuple.
    ///
    /// In the following example, the ``Publisher/map(_:_:)`` operator uses the Swift key path syntax to access the `die1` and `die2` members of the `DiceRoll` structure published by the ``Just`` publisher.
    ///
    /// The downstream sink subscriber receives only these two values (as an `(Int, Int)` tuple), not the entire `DiceRoll`.
    ///
    ///     struct DiceRoll {
    ///         let die1: Int
    ///         let die2: Int
    ///     }
    ///
    ///     cancellable = Just(DiceRoll(die1:Int.random(in:1...6),
    ///                                 die2: Int.random(in:1...6)))
    ///         .map(\.die1, \.die2)
    ///         .sink { values in
    ///             print ("Rolled: \(values.0), \(values.1) (total: \(values.0 + values.1))")
    ///         }
    ///     // Prints "Rolled: 6, 4 (total: 10)" (or other random values).
    ///
    /// - Parameters:
    ///   - keyPath0: The key path of a property on `Output`.
    ///   - keyPath1: The key path of another property on `Output`.
    /// - Returns: A publisher that publishes the values of two key paths as a tuple.
    public func czMap<T0, T1>(_ keyPath0: KeyPath<Self.Output, T0>, _ keyPath1: KeyPath<Self.Output, T1>) -> Publishers.CZMapKeyPath2<Self, T0, T1> {
        return Publishers.CZMapKeyPath2(inner: self.map(keyPath0, keyPath1), uuid: self.generateUUID())
    }

    /// Publishes the values of three key paths as a tuple.
    ///
    /// In the following example, the ``Publisher/map(_:_:_:)`` operator uses the Swift key path syntax to access the `die1`, `die2`, and `die3` members of the `DiceRoll` structure published by the ``Just`` publisher.
    ///
    /// The downstream sink subscriber receives only these three values (as an `(Int, Int, Int)` tuple), not the entire `DiceRoll`.
    ///
    ///     struct DiceRoll {
    ///         let die1: Int
    ///         let die2: Int
    ///         let die3: Int
    ///     }
    ///
    ///     cancellable = Just(DiceRoll(die1:Int.random(in:1...6),
    ///                                 die2: Int.random(in:1...6),
    ///                                 die3: Int.random(in:1...6)))
    ///         .map(\.die1, \.die2, \.die3)
    ///         .sink { values in
    ///             print ("Rolled: \(values.0), \(values.1), \(values.2) (total \(values.0 + values.1 + values.2))")
    ///         }
    ///     // Prints "Rolled: 5, 4, 2 (total 11)" (or other random values).
    ///
    /// - Parameters:
    ///   - keyPath0: The key path of a property on `Output`.
    ///   - keyPath1: The key path of a second property on `Output`.
    ///   - keyPath2: The key path of a third property on `Output`.
    /// - Returns: A publisher that publishes the values of three key paths as a tuple.
    public func czMap<T0, T1, T2>(_ keyPath0: KeyPath<Self.Output, T0>, _ keyPath1: KeyPath<Self.Output, T1>, _ keyPath2: KeyPath<Self.Output, T2>) -> Publishers.CZMapKeyPath3<Self, T0, T1, T2> {
        return Publishers.CZMapKeyPath3(inner: self.map(keyPath0, keyPath1, keyPath2), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Republishes elements until another publisher emits an element.
    ///
    /// After the second publisher publishes an element, the publisher returned by this method finishes.
    ///
    /// - Parameter publisher: A second publisher.
    /// - Returns: A publisher that republishes elements until the second publisher publishes an element.
    public func czPrefix<P>(untilOutputFrom publisher: P) -> Publishers.CZPrefixUntilOutput<Self, P> where P : Publisher {
        return Publishers.CZPrefixUntilOutput(inner: self.prefix(untilOutputFrom: publisher), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Applies a closure that collects each element of a stream and publishes a final result upon completion.
    ///
    /// Use ``Publisher/reduce(_:_:)`` to collect a stream of elements and produce an accumulated value based on a closure you provide.
    ///
    /// In the following example, the ``Publisher/reduce(_:_:)`` operator collects all the integer values it receives from its upstream publisher:
    ///
    ///     let numbers = (0...10)
    ///     cancellable = numbers.publisher
    ///         .reduce(0, { accum, next in accum + next })
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "55"
    ///
    /// - Parameters:
    ///   - initialResult: The value that the closure receives the first time it’s called.
    ///   - nextPartialResult: A closure that produces a new value by taking the previously-accumulated value and the next element it receives from the upstream publisher.
    /// - Returns: A publisher that applies the closure to all received elements and produces an accumulated value when the upstream publisher finishes. If ``Publisher/reduce(_:_:)`` receives an error from the upstream publisher, the operator delivers it to the downstream subscriber, the publisher terminates and publishes no value.
    public func czReduce<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Self.Output) -> T) -> Publishers.CZReduce<Self, T> {
        return Publishers.CZReduce(inner: self.reduce(initialResult, nextPartialResult), uuid: self.generateUUID())
    }

    /// Applies an error-throwing closure that collects each element of a stream and publishes a final result upon completion.
    ///
    /// Use ``Publisher/tryReduce(_:_:)`` to collect a stream of elements and produce an accumulated value based on an error-throwing closure you provide.
    /// If the closure throws an error, the publisher fails and passes the error to its subscriber.
    ///
    /// In the example below, the publisher’s `0` element causes the `myDivide(_:_:)` function to throw an error and publish the <doc://com.apple.documentation/documentation/Swift/Double/1641611-nan> result:
    ///
    ///     struct DivisionByZeroError: Error {}
    ///     func myDivide(_ dividend: Double, _ divisor: Double) throws -> Double {
    ///         guard divisor != 0 else { throw DivisionByZeroError() }
    ///         return dividend / divisor
    ///     }
    ///
    ///     var numbers: [Double] = [5, 4, 3, 2, 1, 0]
    ///     numbers.publisher
    ///         .tryReduce(numbers.first!, { accum, next in try myDivide(accum, next) })
    ///         .catch({ _ in Just(Double.nan) })
    ///         .sink { print("\($0)") }
    ///
    /// - Parameters:
    ///   - initialResult: The value that the closure receives the first time it’s called.
    ///   - nextPartialResult: An error-throwing closure that takes the previously-accumulated value and the next element from the upstream publisher to produce a new value.
    ///
    /// - Returns: A publisher that applies the closure to all received elements and produces an accumulated value when the upstream publisher finishes.
    public func czTryReduce<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Self.Output) throws -> T) -> Publishers.CZTryReduce<Self, T> {
        return Publishers.CZTryReduce(inner: self.tryReduce(initialResult, nextPartialResult), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Calls a closure with each received element and publishes any returned optional that has a value.
    ///
    /// Combine’s ``Publisher/compactMap(_:)`` operator performs a function similar to that of <doc://com.apple.documentation/documentation/Swift/Sequence/2950916-compactmap> in the Swift standard library: the ``Publisher/compactMap(_:)`` operator in Combine removes `nil` elements in a publisher’s stream and republishes non-`nil` elements to the downstream subscriber.
    ///
    /// The example below uses a range of numbers as the source for a collection based publisher. The ``Publisher/compactMap(_:)`` operator consumes each element from the `numbers` publisher attempting to access the dictionary using the element as the key. If the example’s dictionary returns a `nil`, due to a non-existent key, ``Publisher/compactMap(_:)`` filters out the `nil` (missing) elements.
    ///
    ///     let numbers = (0...5)
    ///     let romanNumeralDict: [Int : String] =
    ///         [1: "I", 2: "II", 3: "III", 5: "V"]
    ///
    ///     cancellable = numbers.publisher
    ///         .compactMap { romanNumeralDict[$0] }
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "I II III V"
    ///
    /// - Parameter transform: A closure that receives a value and returns an optional value.
    /// - Returns: Any non-`nil` optional results of the calling the supplied closure.
    public func czCompactMap<T>(_ transform: @escaping (Self.Output) -> T?) -> Publishers.CZCompactMap<Self, T> {
        return Publishers.CZCompactMap(inner: self.compactMap(transform), uuid: self.generateUUID())
    }

    /// Calls an error-throwing closure with each received element and publishes any returned optional that has a value.
    ///
    /// Use ``Publisher/tryCompactMap(_:)`` to remove `nil` elements from a publisher’s stream based on an error-throwing closure you provide. If the closure throws an error, the publisher cancels the upstream publisher and sends the thrown error to the downstream subscriber as a ``Publisher/Failure``.
    ///
    /// The following example uses an array of numbers as the source for a collection-based publisher. A ``Publisher/tryCompactMap(_:)`` operator consumes each integer from the publisher and uses a dictionary to transform the numbers from its Arabic to Roman numerals, as an optional <doc://com.apple.documentation/documentation/Swift/String>.
    ///
    /// If the closure called by ``Publisher/tryCompactMap(_:)`` fails to look up a Roman numeral, it returns the optional String `(unknown)`.
    ///
    /// If the closure called by ``Publisher/tryCompactMap(_:)`` determines the input is `0`, it throws an error. The ``Publisher/tryCompactMap(_:)`` operator catches this error and stops publishing, sending a ``Subscribers/Completion/failure(_:)`` that wraps the error.
    ///
    ///     struct ParseError: Error {}
    ///     func romanNumeral(from: Int) throws -> String? {
    ///         let romanNumeralDict: [Int : String] =
    ///             [1: "I", 2: "II", 3: "III", 4: "IV", 5: "V"]
    ///         guard from != 0 else { throw ParseError() }
    ///         return romanNumeralDict[from]
    ///     }
    ///     let numbers = [6, 5, 4, 3, 2, 1, 0]
    ///     cancellable = numbers.publisher
    ///         .tryCompactMap { try romanNumeral(from: $0) }
    ///         .sink(
    ///               receiveCompletion: { print ("\($0)") },
    ///               receiveValue: { print ("\($0)", terminator: " ") }
    ///          )
    ///
    ///     // Prints: "(Unknown) V IV III II I failure(ParseError())"
    ///
    /// - Parameter transform: An error-throwing closure that receives a value and returns an optional value.
    /// - Returns: Any non-`nil` optional results of calling the supplied closure.
    public func czTryCompactMap<T>(_ transform: @escaping (Self.Output) throws -> T?) -> Publishers.CZTryCompactMap<Self, T> {
        return Publishers.CZTryCompactMap(inner: self.tryCompactMap(transform), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Combines elements from this publisher with those from another publisher, delivering an interleaved sequence of elements.
    ///
    /// Use ``Publisher/merge(with:)-7fk3a`` when you want to receive a new element whenever any of the upstream publishers emits an element. To receive tuples of the most-recent value from all the upstream publishers whenever any of them emit a value, use ``Publisher/combineLatest(_:)``. To combine elements from multiple upstream publishers, use ``Publisher/zip(_:)``.
    ///
    /// In this example, as ``Publisher/merge(with:)-7fk3a`` receives input from either upstream publisher, it republishes it to the downstream:
    ///
    ///     let publisher = PassthroughSubject<Int, Never>()
    ///     let pub2 = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = publisher
    ///         .merge(with: pub2)
    ///         .sink { print("\($0)", terminator: " " )}
    ///
    ///     publisher.send(2)
    ///     pub2.send(2)
    ///     publisher.send(3)
    ///     pub2.send(22)
    ///     publisher.send(45)
    ///     pub2.send(22)
    ///     publisher.send(17)
    ///
    ///     // Prints: "2 2 3 22 45 22 17"
    ///
    ///
    /// The merged publisher continues to emit elements until all upstream publishers finish.
    /// If an upstream publisher produces an error, the merged publisher fails with that error.
    ///
    /// - Parameter other: Another publisher.
    /// - Returns: A publisher that emits an event when either upstream publisher emits an event.
    public func czMerge<P>(with other: P) -> Publishers.CZMerge<Self, P> where P : Publisher, Self.Failure == P.Failure, Self.Output == P.Output {
        return Publishers.CZMerge(inner: self.merge(with: other), uuid: self.generateUUID())
    }

    /// Combines elements from this publisher with those from two other publishers, delivering an interleaved sequence of elements.
    ///
    /// Use ``Publisher/merge(with:_:)`` when you want to receive a new element whenever any of the upstream publishers emits an element. To receive tuples of the most-recent value from all the upstream publishers whenever any of them emit a value, use ``Publisher/combineLatest(_:_:)-5crqg``.
    /// To combine elements from multiple upstream publishers, use ``Publisher/zip(_:_:)-8d7k7``.
    ///
    /// In this example, as ``Publisher/merge(with:_:)`` receives input from the upstream publishers, it republishes the interleaved elements to the downstream:
    ///
    ///     let pubA = PassthroughSubject<Int, Never>()
    ///     let pubB = PassthroughSubject<Int, Never>()
    ///     let pubC = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pubA
    ///         .merge(with: pubB, pubC)
    ///         .sink { print("\($0)", terminator: " " )}
    ///
    ///     pubA.send(1)
    ///     pubB.send(40)
    ///     pubC.send(90)
    ///     pubA.send(2)
    ///     pubB.send(50)
    ///     pubC.send(100)
    ///
    ///     // Prints: "1 40 90 2 50 100"
    ///
    /// The merged publisher continues to emit elements until all upstream publishers finish.
    /// If an upstream publisher produces an error, the merged publisher fails with that error.
    ///
    /// - Parameters:
    ///   - b: A second publisher.
    ///   - c: A third publisher.
    /// - Returns: A publisher that emits an event when any upstream publisher emits an event.
    public func czMerge<B, C>(with b: B, _ c: C) -> Publishers.CZMerge3<Self, B, C> where B : Publisher, C : Publisher, Self.Failure == B.Failure, Self.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output {
        return Publishers.CZMerge3(inner: self.merge(with: b, c), uuid: self.generateUUID())
    }

    /// Combines elements from this publisher with those from three other publishers, delivering an interleaved sequence of elements.
    ///
    /// Use ``Publisher/merge(with:_:_:)`` when you want to receive a new element whenever any of the upstream publishers emits an element. To receive tuples of the most-recent value from all the upstream publishers whenever any of them emit a value, use ``Publisher/combineLatest(_:_:_:)-48buc``.
    /// To combine elements from multiple upstream publishers, use ``Publisher/zip(_:_:_:)-16rcy``.
    ///
    /// In this example, as ``Publisher/merge(with:_:_:)`` receives input from the upstream publishers, it republishes the interleaved elements to the downstream:
    ///
    ///     let pubA = PassthroughSubject<Int, Never>()
    ///     let pubB = PassthroughSubject<Int, Never>()
    ///     let pubC = PassthroughSubject<Int, Never>()
    ///     let pubD = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pubA
    ///         .merge(with: pubB, pubC, pubD)
    ///         .sink { print("\($0)", terminator: " " )}
    ///
    ///     pubA.send(1)
    ///     pubB.send(40)
    ///     pubC.send(90)
    ///     pubD.send(-1)
    ///     pubA.send(2)
    ///     pubB.send(50)
    ///     pubC.send(100)
    ///     pubD.send(-2)
    ///
    ///     // Prints: "1 40 90 -1 2 50 100 -2 "
    ///
    /// The merged publisher continues to emit elements until all upstream publishers finish.
    /// If an upstream publisher produces an error, the merged publisher fails with that error.
    ///
    /// - Parameters:
    ///   - b: A second publisher.
    ///   - c: A third publisher.
    ///   - d: A fourth publisher.
    /// - Returns: A publisher that emits an event when any upstream publisher emits an event.
    public func czMerge<B, C, D>(with b: B, _ c: C, _ d: D) -> Publishers.CZMerge4<Self, B, C, D> where B : Publisher, C : Publisher, D : Publisher, Self.Failure == B.Failure, Self.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output {
        return Publishers.CZMerge4(inner: self.merge(with: b, c, d), uuid: self.generateUUID())
    }

    /// Combines elements from this publisher with those from four other publishers, delivering an interleaved sequence of elements.
    ///
    /// Use ``Publisher/merge(with:_:_:_:)`` when you want to receive a new element whenever any of the upstream publishers emits an element. To receive tuples of the most-recent value from all the upstream publishers whenever any of them emit a value, use ``Publisher/combineLatest(_:_:_:)-48buc``.
    /// To combine elements from multiple upstream publishers, use ``Publisher/zip(_:_:_:)-16rcy``.
    ///
    /// In this example, as ``Publisher/merge(with:_:_:_:)`` receives input from the upstream publishers, it republishes the interleaved elements to the downstream:
    ///
    ///      let pubA = PassthroughSubject<Int, Never>()
    ///      let pubB = PassthroughSubject<Int, Never>()
    ///      let pubC = PassthroughSubject<Int, Never>()
    ///      let pubD = PassthroughSubject<Int, Never>()
    ///      let pubE = PassthroughSubject<Int, Never>()
    ///
    ///      cancellable = pubA
    ///          .merge(with: pubB, pubC, pubD, pubE)
    ///          .sink { print("\($0)", terminator: " " ) }
    ///
    ///      pubA.send(1)
    ///      pubB.send(40)
    ///      pubC.send(90)
    ///      pubD.send(-1)
    ///      pubE.send(33)
    ///      pubA.send(2)
    ///      pubB.send(50)
    ///      pubC.send(100)
    ///      pubD.send(-2)
    ///      pubE.send(33)
    ///
    ///      // Prints: "1 40 90 -1 33 2 50 100 -2 33"
    ///
    ///
    /// The merged publisher continues to emit elements until all upstream publishers finish.
    /// If an upstream publisher produces an error, the merged publisher fails with that error.
    ///
    /// - Parameters:
    ///   - b: A second publisher.
    ///   - c: A third publisher.
    ///   - d: A fourth publisher.
    ///   - e: A fifth publisher.
    /// - Returns: A publisher that emits an event when any upstream publisher emits an event.
    public func czMerge<B, C, D, E>(with b: B, _ c: C, _ d: D, _ e: E) -> Publishers.CZMerge5<Self, B, C, D, E> where B : Publisher, C : Publisher, D : Publisher, E : Publisher, Self.Failure == B.Failure, Self.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output {
        Publishers.CZMerge5(inner: self.merge(with: b, c, d, e), uuid: self.generateUUID())
    }

    /// Combines elements from this publisher with those from five other publishers, delivering an interleaved sequence of elements.
    ///
    /// Use ``Publisher/merge(with:_:_:_:_:_:)`` when you want to receive a new element whenever any of the upstream publishers emits an element. To receive tuples of the most-recent value from all the upstream publishers whenever any of them emit a value, use ``Publisher/combineLatest(_:_:_:)-48buc``.
    /// To combine elements from multiple upstream publishers, use ``Publisher/zip(_:_:_:)-16rcy``.
    ///
    /// In this example, as ``Publisher/merge(with:_:_:_:_:_:)`` receives input from the upstream publishers, it republishes the interleaved elements to the downstream:
    ///
    ///     let pubA = PassthroughSubject<Int, Never>()
    ///     let pubB = PassthroughSubject<Int, Never>()
    ///     let pubC = PassthroughSubject<Int, Never>()
    ///     let pubD = PassthroughSubject<Int, Never>()
    ///     let pubE = PassthroughSubject<Int, Never>()
    ///     let pubF = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pubA
    ///         .merge(with: pubB, pubC, pubD, pubE, pubF)
    ///         .sink { print("\($0)", terminator: " " ) }
    ///
    ///     pubA.send(1)
    ///     pubB.send(40)
    ///     pubC.send(90)
    ///     pubD.send(-1)
    ///     pubE.send(33)
    ///     pubF.send(44)
    ///
    ///     pubA.send(2)
    ///     pubB.send(50)
    ///     pubC.send(100)
    ///     pubD.send(-2)
    ///     pubE.send(33)
    ///     pubF.send(33)
    ///
    ///     //Prints: "1 40 90 -1 33 44 2 50 100 -2 33 33"
    ///
    /// The merged publisher continues to emit elements until all upstream publishers finish.
    /// If an upstream publisher produces an error, the merged publisher fails with that error.
    ///
    /// - Parameters:
    ///   - b: A second publisher.
    ///   - c: A third publisher.
    ///   - d: A fourth publisher.
    ///   - e: A fifth publisher.
    ///   - f: A sixth publisher.
    /// - Returns: A publisher that emits an event when any upstream publisher emits an event.
    public func czMerge<B, C, D, E, F>(with b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> Publishers.CZMerge6<Self, B, C, D, E, F> where B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, Self.Failure == B.Failure, Self.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output {
        return Publishers.CZMerge6(inner: self.merge(with: b, c, d, e, f), uuid: self.generateUUID())
    }

    /// Combines elements from this publisher with those from six other publishers, delivering an interleaved sequence of elements.
    ///
    /// Use ``Publisher/merge(with:_:_:_:_:_:)`` when you want to receive a new element whenever any of the upstream publishers emits an element. To receive tuples of the most-recent value from all the upstream publishers whenever any of them emit a value, use ``Publisher/combineLatest(_:_:_:)-48buc``.
    /// To combine elements from multiple upstream publishers, use ``Publisher/zip(_:_:_:)-16rcy``.
    ///
    /// In this example, as ``Publisher/merge(with:_:_:_:_:_:)`` receives input from the upstream publishers; it republishes the interleaved elements to the downstream:
    ///
    ///     let pubA = PassthroughSubject<Int, Never>()
    ///     let pubB = PassthroughSubject<Int, Never>()
    ///     let pubC = PassthroughSubject<Int, Never>()
    ///     let pubD = PassthroughSubject<Int, Never>()
    ///     let pubE = PassthroughSubject<Int, Never>()
    ///     let pubF = PassthroughSubject<Int, Never>()
    ///     let pubG = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pubA
    ///         .merge(with: pubB, pubC, pubD, pubE, pubE, pubG)
    ///         .sink { print("\($0)", terminator: " " ) }
    ///
    ///     pubA.send(1)
    ///     pubB.send(40)
    ///     pubC.send(90)
    ///     pubD.send(-1)
    ///     pubE.send(33)
    ///     pubF.send(44)
    ///     pubG.send(54)
    ///
    ///     pubA.send(2)
    ///     pubB.send(50)
    ///     pubC.send(100)
    ///     pubD.send(-2)
    ///     pubE.send(33)
    ///     pubF.send(33)
    ///     pubG.send(54)
    ///
    ///     //Prints: "1 40 90 -1 33 44 54 2 50 100 -2 33 33 54"
    ///
    ///
    /// The merged publisher continues to emit elements until all upstream publishers finish.
    /// If an upstream publisher produces an error, the merged publisher fails with that error.
    ///
    /// - Parameters:
    ///   - b: A second publisher.
    ///   - c: A third publisher.
    ///   - d: A fourth publisher.
    ///   - e: A fifth publisher.
    ///   - f: A sixth publisher.
    ///   - g: A seventh publisher.
    /// - Returns: A publisher that emits an event when any upstream publisher emits an event.
    public func czMerge<B, C, D, E, F, G>(with b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> Publishers.CZMerge7<Self, B, C, D, E, F, G> where B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, G : Publisher, Self.Failure == B.Failure, Self.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output, F.Failure == G.Failure, F.Output == G.Output {
        Publishers.CZMerge7(inner: self.merge(with: b, c, d, e, f, g), uuid: self.generateUUID())
    }

    /// Combines elements from this publisher with those from seven other publishers, delivering an interleaved sequence of elements.
    ///
    /// Use ``Publisher/merge(with:_:_:_:_:_:_:)`` when you want to receive a new element whenever any of the upstream publishers emits an element. To receive tuples of the most-recent value from all the upstream publishers whenever any of them emit a value, use ``Publisher/combineLatest(_:_:_:)-48buc``.
    /// To combine elements from multiple upstream publishers, use ``Publisher/zip(_:_:_:)-16rcy``.
    ///
    /// In this example, as ``Publisher/merge(with:_:_:_:_:_:_:)`` receives input from the upstream publishers, it republishes the interleaved elements to the downstream:
    ///
    ///     let pubA = PassthroughSubject<Int, Never>()
    ///     let pubB = PassthroughSubject<Int, Never>()
    ///     let pubC = PassthroughSubject<Int, Never>()
    ///     let pubD = PassthroughSubject<Int, Never>()
    ///     let pubE = PassthroughSubject<Int, Never>()
    ///     let pubF = PassthroughSubject<Int, Never>()
    ///     let pubG = PassthroughSubject<Int, Never>()
    ///     let pubH = PassthroughSubject<Int, Never>()
    ///
    ///     cancellable = pubA
    ///         .merge(with: pubB, pubC, pubD, pubE, pubF, pubG, pubH)
    ///         .sink { print("\($0)", terminator: " " ) }
    ///
    ///     pubA.send(1)
    ///     pubB.send(40)
    ///     pubC.send(90)
    ///     pubD.send(-1)
    ///     pubE.send(33)
    ///     pubF.send(44)
    ///     pubG.send(54)
    ///     pubH.send(1000)
    ///
    ///     pubA.send(2)
    ///     pubB.send(50)
    ///     pubC.send(100)
    ///     pubD.send(-2)
    ///     pubE.send(33)
    ///     pubF.send(33)
    ///     pubG.send(54)
    ///     pubH.send(1001)
    ///
    ///     //Prints: "1 40 90 -1 33 44 54 1000 2 50 100 -2 33 33 54 1001"
    ///
    /// The merged publisher continues to emit elements until all upstream publishers finish.
    /// If an upstream publisher produces an error, the merged publisher fails with that error.
    ///
    /// - Parameters:
    ///   - b: A second publisher.
    ///   - c: A third publisher.
    ///   - d: A fourth publisher.
    ///   - e: A fifth publisher.
    ///   - f: A sixth publisher.
    ///   - g: A seventh publisher.
    ///   - h: An eighth publisher.
    /// - Returns: A publisher that emits an event when any upstream publisher emits an event.
    public func czMerge<B, C, D, E, F, G, H>(with b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H) -> Publishers.CZMerge8<Self, B, C, D, E, F, G, H> where B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, G : Publisher, H : Publisher, Self.Failure == B.Failure, Self.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output, F.Failure == G.Failure, F.Output == G.Output, G.Failure == H.Failure, G.Output == H.Output {
        Publishers.CZMerge8(inner: self.merge(with: b, c, d, e, f, g, h), uuid: self.generateUUID())
    }

    /// Combines elements from this publisher with those from another publisher of the same type, delivering an interleaved sequence of elements.
    ///
    /// - Parameter other: Another publisher of this publisher’s type.
    /// - Returns: A publisher that emits an event when either upstream publisher emits an event.
    public func czMerge(with other: Self) -> Publishers.CZMergeMany<Self> {
        return Publishers.CZMergeMany(inner: self.merge(with: other), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Transforms elements from the upstream publisher by providing the current
    /// element to a closure along with the last value returned by the closure.
    ///
    /// Use ``Publisher/scan(_:_:)`` to accumulate all previously-published values into a single
    /// value, which you then combine with each newly-published value.
    ///
    /// The following example logs a running total of all values received
    /// from the sequence publisher.
    ///
    ///     let range = (0...5)
    ///     cancellable = range.publisher
    ///         .scan(0) { return $0 + $1 }
    ///         .sink { print ("\($0)", terminator: " ") }
    ///      // Prints: "0 1 3 6 10 15 ".
    ///
    /// - Parameters:
    ///   - initialResult: The previous result returned by the `nextPartialResult` closure.
    ///   - nextPartialResult: A closure that takes as its arguments the previous value returned by the closure and the next element emitted from the upstream publisher.
    /// - Returns: A publisher that transforms elements by applying a closure that receives its previous return value and the next element from the upstream publisher.
    public func czScan<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Self.Output) -> T) -> Publishers.CZScan<Self, T> {
        return Publishers.CZScan(inner: self.scan(initialResult, nextPartialResult), uuid: self.generateUUID())
    }

    /// Transforms elements from the upstream publisher by providing the current element to an error-throwing closure along with the last value returned by the closure.
    ///
    /// Use ``Publisher/tryScan(_:_:)`` to accumulate all previously-published values into a single value, which you then combine with each newly-published value.
    /// If your accumulator closure throws an error, the publisher terminates with the error.
    ///
    /// In the example below, ``Publisher/tryScan(_:_:)`` calls a division function on elements of a collection publisher. The ``Publishers/TryScan`` publisher publishes each result until the function encounters a `DivisionByZeroError`, which terminates the publisher.
    ///
    ///     struct DivisionByZeroError: Error {}
    ///
    ///     /// A function that throws a DivisionByZeroError if `current` provided by the TryScan publisher is zero.
    ///     func myThrowingFunction(_ lastValue: Int, _ currentValue: Int) throws -> Int {
    ///         guard currentValue != 0 else { throw DivisionByZeroError() }
    ///         return (lastValue + currentValue) / currentValue
    ///      }
    ///
    ///     let numbers = [1,2,3,4,5,0,6,7,8,9]
    ///     cancellable = numbers.publisher
    ///         .tryScan(10) { try myThrowingFunction($0, $1) }
    ///         .sink(
    ///             receiveCompletion: { print ("\($0)") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///          )
    ///
    ///     // Prints: "11 6 3 1 1 -1 failure(DivisionByZeroError())".
    ///
    /// If the closure throws an error, the publisher fails with the error.
    ///
    /// - Parameters:
    ///   - initialResult: The previous result returned by the `nextPartialResult` closure.
    ///   - nextPartialResult: An error-throwing closure that takes as its arguments the previous value returned by the closure and the next element emitted from the upstream publisher.
    /// - Returns: A publisher that transforms elements by applying a closure that receives its previous return value and the next element from the upstream publisher.
    public func czTryScan<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Self.Output) throws -> T) -> Publishers.CZTryScan<Self, T> {
        return Publishers.CZTryScan(inner: self.tryScan(initialResult, nextPartialResult), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes the number of elements received from the upstream publisher.
    ///
    /// Use ``Publisher/count()`` to determine the number of elements received from the upstream publisher before it completes:
    ///
    ///     let numbers = (0...10)
    ///     cancellable = numbers.publisher
    ///         .count()
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "11"
    ///
    /// - Returns: A publisher that consumes all elements until the upstream publisher finishes, then emits a single value with the total number of elements received.
    public func czCount() -> Publishers.CZCount<Self> {
        return Publishers.CZCount(inner: self.count(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes the last element of a stream that satisfies a predicate closure, after upstream finishes.
    ///
    /// Use ``Publisher/last(where:)`` when you need to republish only the last element of a stream that satisfies a closure you specify.
    ///
    /// In the example below, a range publisher emits the last element that satisfies the closure’s criteria, then finishes normally:
    ///
    ///     let numbers = (-10...10)
    ///     cancellable = numbers.publisher
    ///         .last { $0 < 6 }
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "5"
    ///
    /// - Parameter predicate: A closure that takes an element as its parameter and returns a Boolean value that indicates whether to publish the element.
    /// - Returns: A publisher that only publishes the last element satisfying the given predicate.
    public func czLast(where predicate: @escaping (Self.Output) -> Bool) -> Publishers.CZLastWhere<Self> {
        return Publishers.CZLastWhere(inner: self.last(where: predicate), uuid: self.generateUUID())
    }

    /// Publishes the last element of a stream that satisfies an error-throwing predicate closure, after the stream finishes.
    ///
    /// Use ``Publisher/tryLast(where:)`` when you need to republish the last element that satisfies an error-throwing closure you specify. If the predicate closure throws an error, the publisher fails.
    ///
    /// In the example below, a publisher emits the last element that satisfies the error-throwing closure, then finishes normally:
    ///
    ///     struct RangeError: Error {}
    ///
    ///     let numbers = [-62, 1, 6, 10, 9, 22, 41, -1, 5]
    ///     cancellable = numbers.publisher
    ///         .tryLast {
    ///             guard 0 != 0  else {throw RangeError()}
    ///             return true
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)", terminator: " ") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///         )
    ///     // Prints: "5 completion: finished"
    ///     // If instead the numbers array had contained a `0`, the `tryLast` operator would terminate publishing with a RangeError."
    ///
    /// - Parameter predicate: A closure that takes an element as its parameter and returns a Boolean value that indicates whether to publish the element.
    /// - Returns: A publisher that only publishes the last element satisfying the given predicate.
    public func czTryLast(where predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.CZTryLastWhere<Self> {
        return Publishers.CZTryLastWhere(inner: self.tryLast(where: predicate), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Ignores all upstream elements, but passes along the upstream publisher's completion state (finished or failed).
    ///
    /// Use the ``Publisher/ignoreOutput()`` operator to determine if a publisher is able to complete successfully or would fail.
    ///
    /// In the example below, the array publisher (`numbers`) delivers the first five of its elements successfully, as indicated by the ``Publisher/ignoreOutput()`` operator. The operator consumes, but doesn’t republish the elements downstream. However, the sixth element, `0`, causes the error throwing closure to catch a `NoZeroValuesAllowedError` that terminates the stream.
    ///
    ///     struct NoZeroValuesAllowedError: Error {}
    ///     let numbers = [1, 2, 3, 4, 5, 0, 6, 7, 8, 9]
    ///     cancellable = numbers.publisher
    ///         .tryFilter({ anInt in
    ///             guard anInt != 0 else { throw NoZeroValuesAllowedError() }
    ///             return anInt < 20
    ///         })
    ///         .ignoreOutput()
    ///         .sink(receiveCompletion: {print("completion: \($0)")},
    ///               receiveValue: {print("value \($0)")})
    ///
    ///     // Prints: "completion: failure(NoZeroValuesAllowedError())"
    ///
    /// The output type of this publisher is <doc://com.apple.documentation/documentation/Swift/Never>.
    ///
    /// - Returns: A publisher that ignores all upstream elements.
    public func czIgnoreOutput() -> Publishers.CZIgnoreOutput<Self> {
        return Publishers.CZIgnoreOutput(inner: self.ignoreOutput(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Failure == Self.Output.Failure, Self.Output : Publisher {

    /// Republishes elements sent by the most recently received publisher.
    ///
    /// This operator works with an upstream publisher of publishers, flattening the stream of elements to appear as if they were coming from a single stream of elements. It switches the inner publisher as new ones arrive but keeps the outer publisher constant for downstream subscribers.
    ///
    /// For example, given the type `AnyPublisher<URLSession.DataTaskPublisher, NSError>`, calling `switchToLatest()` results in the type `SwitchToLatest<(Data, URLResponse), URLError>`. The downstream subscriber sees a continuous stream of `(Data, URLResponse)` elements from what looks like a single <doc://com.apple.documentation/documentation/Foundation/URLSession/DataTaskPublisher> even though the elements are coming from different upstream publishers.
    ///
    /// When this operator receives a new publisher from the upstream publisher, it cancels its previous subscription. Use this feature to prevent earlier publishers from performing unnecessary work, such as creating network request publishers from frequently updating user interface publishers.
    ///
    /// The following example updates a ``PassthroughSubject`` with a new value every `0.1` seconds. A ``Publisher/map(_:)-99evh`` operator receives the new value and uses it to create a new <doc://com.apple.documentation/documentation/Foundation/URLSession/DataTaskPublisher>. By using the `switchToLatest()` operator, the downstream sink subscriber receives the `(Data, URLResponse)` output type from the data task publishers, rather than the <doc://com.apple.documentation/documentation/Foundation/URLSession/DataTaskPublisher> type produced by the ``Publisher/map(_:)-99evh`` operator. Furthermore, creating each new data task publisher cancels the previous data task publisher.
    ///
    ///     let subject = PassthroughSubject<Int, Never>()
    ///     cancellable = subject
    ///         .setFailureType(to: URLError.self)
    ///         .map() { index -> URLSession.DataTaskPublisher in
    ///             let url = URL(string: "https://example.org/get?index=\(index)")!
    ///             return URLSession.shared.dataTaskPublisher(for: url)
    ///         }
    ///         .switchToLatest()
    ///         .sink(receiveCompletion: { print("Complete: \($0)") },
    ///               receiveValue: { (data, response) in
    ///                 guard let url = response.url else { print("Bad response."); return }
    ///                 print("URL: \(url)")
    ///         })
    ///
    ///     for index in 1...5 {
    ///         DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(index/10)) {
    ///             subject.send(index)
    ///         }
    ///     }
    ///
    ///     // Prints "URL: https://example.org/get?index=5"
    ///
    /// The exact behavior of this example depends on the value of `asyncAfter` and the speed of the network connection. If the delay value is longer, or the network connection is fast, the earlier data tasks may complete before `switchToLatest()` can cancel them. If this happens, the output includes multiple URLs whose tasks complete before cancellation.
    public func czSwitchToLatest() -> Publishers.CZSwitchToLatest<Self.Output, Self> {
        return Publishers.CZSwitchToLatest(inner: self.switchToLatest(), uuid: self.generateUUID())
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Publisher where Self.Failure == Never, Self.Output : Publisher {

    /// Republishes elements sent by the most recently received publisher.
    ///
    /// This operator works with an upstream publisher of publishers, flattening the stream of elements to appear as if they were coming from a single stream of elements. It switches the inner publisher as new ones arrive but keeps the outer publisher constant for downstream subscribers.
    ///
    /// When this operator receives a new publisher from the upstream publisher, it cancels its previous subscription. Use this feature to prevent earlier publishers from performing unnecessary work, such as creating network request publishers from frequently updating user interface publishers.
    public func czSwitchToLatest() -> Publishers.CZSwitchToLatest<Self.Output, Publishers.SetFailureType<Self, Self.Output.Failure>> {
        return Publishers.CZSwitchToLatest(inner: self.switchToLatest(), uuid: self.generateUUID())
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Publisher where Self.Failure == Never, Self.Output : Publisher, Self.Output.Failure == Never {

    /// Republishes elements sent by the most recently received publisher.
    ///
    /// This operator works with an upstream publisher of publishers, flattening the stream of elements to appear as if they were coming from a single stream of elements. It switches the inner publisher as new ones arrive but keeps the outer publisher constant for downstream subscribers.
    ///
    /// When this operator receives a new publisher from the upstream publisher, it cancels its previous subscription. Use this feature to prevent earlier publishers from performing unnecessary work, such as creating network request publishers from frequently updating user interface publishers.
    public func czSwitchToLatest() -> Publishers.CZSwitchToLatest<Self.Output, Self> {
        return Publishers.CZSwitchToLatest(inner: self.switchToLatest(), uuid: self.generateUUID())
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Publisher where Self.Output : Publisher, Self.Output.Failure == Never {

    /// Republishes elements sent by the most recently received publisher.
    ///
    /// This operator works with an upstream publisher of publishers, flattening the stream of elements to appear as if they were coming from a single stream of elements. It switches the inner publisher as new ones arrive but keeps the outer publisher constant for downstream subscribers.
    ///
    /// When this operator receives a new publisher from the upstream publisher, it cancels its previous subscription. Use this feature to prevent earlier publishers from performing unnecessary work, such as creating network request publishers from frequently updating user interface publishers.
    public func czSwitchToLatest() -> Publishers.CZSwitchToLatest<Publishers.SetFailureType<Self.Output, Self.Failure>, Publishers.Map<Self, Publishers.SetFailureType<Self.Output, Self.Failure>>> {
        return Publishers.CZSwitchToLatest(inner: self.switchToLatest(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Attempts to recreate a failed subscription with the upstream publisher up to the number of times you specify.
    ///
    /// Use ``Publisher/retry(_:)`` to try a connecting to an upstream publisher after a failed connection attempt.
    ///
    /// In the example below, a <doc://com.apple.documentation/documentation/Foundation/URLSession/DataTaskPublisher> attempts to connect to a remote URL. If the connection attempt succeeds, it publishes the remote service’s HTML to the downstream publisher and completes normally. Otherwise, the retry operator attempts to reestablish the connection. If after three attempts the publisher still can’t connect to the remote URL, the ``Publisher/catch(_:)`` operator replaces the error with a new publisher that publishes a “connection timed out” HTML page. After the downstream subscriber receives the timed out message, the stream completes normally.
    ///
    ///     struct WebSiteData: Codable {
    ///         var rawHTML: String
    ///     }
    ///
    ///     let myURL = URL(string: "https://www.example.com")
    ///
    ///     cancellable = URLSession.shared.dataTaskPublisher(for: myURL!)
    ///         .retry(3)
    ///         .map({ (page) -> WebSiteData in
    ///             return WebSiteData(rawHTML: String(decoding: page.data, as: UTF8.self))
    ///         })
    ///         .catch { error in
    ///             return Just(WebSiteData(rawHTML: "<HTML>Unable to load page - timed out.</HTML>"))
    ///     }
    ///     .sink(receiveCompletion: { print ("completion: \($0)") },
    ///           receiveValue: { print ("value: \($0)") }
    ///      )
    ///
    ///     // Prints: The HTML content from the remote URL upon a successful connection,
    ///     //         or returns "<HTML>Unable to load page - timed out.</HTML>" if the number of retries exceeds the specified value.
    ///
    /// After exceeding the specified number of retries, the publisher passes the failure to the downstream receiver.
    /// - Parameter retries: The number of times to attempt to recreate the subscription.
    /// - Returns: A publisher that attempts to recreate its subscription to a failed upstream publisher.
    public func czRetry(_ retries: Int) -> Publishers.CZRetry<Self> {
        return Publishers.CZRetry(inner: self.retry(retries), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Converts any failure from the upstream publisher into a new error.
    ///
    /// Use the ``Publisher/mapError(_:)`` operator when you need to replace one error type with another, or where a downstream operator needs the error types of its inputs to match.
    ///
    /// The following example uses a ``Publisher/tryMap(_:)`` operator to divide `1` by each element produced by a sequence publisher. When the publisher produces a `0`, the ``Publisher/tryMap(_:)`` fails with a
    /// `DivisionByZeroError`. The ``Publisher/mapError(_:)`` operator converts this into a `MyGenericError`.
    ///
    ///     struct DivisionByZeroError: Error {}
    ///     struct MyGenericError: Error { var wrappedError: Error }
    ///
    ///     func myDivide(_ dividend: Double, _ divisor: Double) throws -> Double {
    ///            guard divisor != 0 else { throw DivisionByZeroError() }
    ///            return dividend / divisor
    ///        }
    ///
    ///     let divisors: [Double] = [5, 4, 3, 2, 1, 0]
    ///     divisors.publisher
    ///         .tryMap { try myDivide(1, $0) }
    ///         .mapError { MyGenericError(wrappedError: $0) }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)") ,
    ///             receiveValue: { print ("value: \($0)", terminator: " ") }
    ///          )
    ///
    ///     // Prints: "0.2 0.25 0.3333333333333333 0.5 1.0 completion: failure(MyGenericError(wrappedError: DivisionByZeroError()))"
    ///
    /// - Parameter transform: A closure that takes the upstream failure as a parameter and returns a new error for the publisher to terminate with.
    /// - Returns: A publisher that replaces any upstream failure with a new error produced by the `transform` closure.
    public func czMapError<E>(_ transform: @escaping (Self.Failure) -> E) -> Publishers.CZMapError<Self, E> where E : Error {
        return Publishers.CZMapError(inner: self.mapError(transform), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes either the most-recent or first element published by the upstream publisher in the specified time interval.
    ///
    /// Use ``Publisher/throttle(for:scheduler:latest:)`` to selectively republish elements from an upstream publisher during an interval you specify. Other elements received from the upstream in the throttling interval aren’t republished.
    ///
    /// In the example below, a <doc://com.apple.documentation/documentation/Foundation/Timer/TimerPublisher> produces elements on one-second intervals; the ``Publisher/throttle(for:scheduler:latest:)`` operator delivers the first event, then republishes only the latest event in the following ten second intervals:
    ///
    ///     cancellable = Timer.publish(every: 3.0, on: .main, in: .default)
    ///         .autoconnect()
    ///         .print("\(Date().description)")
    ///         .throttle(for: 10.0, scheduler: RunLoop.main, latest: true)
    ///         .sink(
    ///             receiveCompletion: { print ("Completion: \($0).") },
    ///             receiveValue: { print("Received Timestamp \($0).") }
    ///          )
    ///
    ///     // Prints:
    ///      //    Publish at: 2020-03-19 18:26:54 +0000: receive value: (2020-03-19 18:26:57 +0000)
    ///      //    Received Timestamp 2020-03-19 18:26:57 +0000.
    ///      //    Publish at: 2020-03-19 18:26:54 +0000: receive value: (2020-03-19 18:27:00 +0000)
    ///      //    Publish at: 2020-03-19 18:26:54 +0000: receive value: (2020-03-19 18:27:03 +0000)
    ///      //    Publish at: 2020-03-19 18:26:54 +0000: receive value: (2020-03-19 18:27:06 +0000)
    ///      //    Publish at: 2020-03-19 18:26:54 +0000: receive value: (2020-03-19 18:27:09 +0000)
    ///      //    Received Timestamp 2020-03-19 18:27:09 +0000.
    ///
    /// - Parameters:
    ///   - interval: The interval at which to find and emit either the most recent or the first element, expressed in the time system of the scheduler.
    ///   - scheduler: The scheduler on which to publish elements.
    ///   - latest: A Boolean value that indicates whether to publish the most recent element. If `false`, the publisher emits the first element received during the interval.
    /// - Returns: A publisher that emits either the most-recent or first element received during the specified interval.
    public func czThrottle<S>(for interval: S.SchedulerTimeType.Stride, scheduler: S, latest: Bool) -> Publishers.CZThrottle<Self, S> where S : Scheduler {
        return Publishers.CZThrottle(inner: self.throttle(for: interval, scheduler: scheduler, latest: latest), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Shares the output of an upstream publisher with multiple subscribers.
    ///
    /// The publisher returned by this operator supports multiple subscribers, all of whom receive unchanged elements and completion states from the upstream publisher.
    ///
    ///  - Tip: ``Publishers/Share`` is effectively a combination of the ``Publishers/Multicast`` and ``PassthroughSubject`` publishers, with an implicit ``ConnectablePublisher/autoconnect()``.
    ///
    /// The following example uses a sequence publisher as a counter to publish three random numbers, generated by a ``Publisher/map(_:)-99evh`` operator. It uses a ``Publisher/share()`` operator to share the same random number to each of two subscribers. This example uses a ``Publisher/delay(for:tolerance:scheduler:options:)`` operator only to prevent the first subscriber from exhausting the sequence publisher immediately; an asynchronous publisher wouldn’t need this.
    ///
    ///     let pub = (1...3).publisher
    ///         .delay(for: 1, scheduler: DispatchQueue.main)
    ///         .map( { _ in return Int.random(in: 0...100) } )
    ///         .print("Random")
    ///         .share()
    ///
    ///     cancellable1 = pub
    ///         .sink { print ("Stream 1 received: \($0)")}
    ///     cancellable2 = pub
    ///         .sink { print ("Stream 2 received: \($0)")}
    ///
    ///     // Prints:
    ///     // Random: receive value: (20)
    ///     // Stream 1 received: 20
    ///     // Stream 2 received: 20
    ///     // Random: receive value: (85)
    ///     // Stream 1 received: 85
    ///     // Stream 2 received: 85
    ///     // Random: receive value: (98)
    ///     // Stream 1 received: 98
    ///     // Stream 2 received: 98
    ///
    ///
    /// Without the ``Publisher/share()`` operator, stream 1 receives three random values, followed by stream 2 receiving three different random values.
    ///
    /// Also note that ``Publishers/Share`` is a class rather than a structure like most other publishers. This means you can use this operator to create a publisher instance that uses reference semantics.
    /// - Returns: A class instance that shares elements received from its upstream to multiple subscribers.
    public func czShare() -> Publishers.CZShare<Self> {
        return Publishers.CZShare(inner: self.share(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Output : Comparable {

    /// Publishes the minimum value received from the upstream publisher, after it finishes.
    ///
    /// Use ``Publisher/min(by:)`` to find the minimum value in a stream of elements from an upstream publisher.
    ///
    /// In the example below, the ``Publisher/min(by:)`` operator emits a value when the publisher finishes, that value is the minimum of the values received from upstream, which is `-1`.
    ///
    ///     let numbers = [-1, 0, 10, 5]
    ///     numbers.publisher
    ///         .min()
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "-1"
    ///
    /// After this publisher receives a request for more than 0 items, it requests unlimited items from its upstream publisher.
    /// - Returns: A publisher that publishes the minimum value received from the upstream publisher, after the upstream publisher finishes.
    public func czMin() -> Publishers.CZComparison<Self> {
        return Publishers.CZComparison(inner: self.min(), uuid: self.generateUUID())
    }

    /// Publishes the maximum value received from the upstream publisher, after it finishes.
    ///
    /// Use ``Publisher/max()`` to determine the maximum value in the stream of elements from an upstream publisher.
    ///
    /// In the example below, the ``Publisher/max()`` operator emits a value when the publisher finishes, that value is the maximum of the values received from upstream, which is `10`.
    ///
    ///     let numbers = [0, 10, 5]
    ///     cancellable = numbers.publisher
    ///         .max()
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "10"
    ///
    /// After this publisher receives a request for more than 0 items, it requests unlimited items from its upstream publisher.
    /// - Returns: A publisher that publishes the maximum value received from the upstream publisher, after the upstream publisher finishes.
    public func czMax() -> Publishers.CZComparison<Self> {
        return Publishers.CZComparison(inner: self.max(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes the minimum value received from the upstream publisher, after it finishes.
    ///
    /// Use ``Publisher/min(by:)`` to determine the minimum value in the stream of elements from an upstream publisher using a comparison operation you specify.
    ///
    /// This operator is useful when the value received from the upstream publisher isn’t <doc://com.apple.documentation/documentation/Swift/Comparable>.
    ///
    /// In the example below an array publishes enumeration elements representing playing card ranks. The ``Publisher/min(by:)`` operator compares the current and next elements using the `rawValue` property of each enumeration value in the user supplied closure and prints the minimum value found after publishing all of the elements.
    ///
    ///     enum Rank: Int {
    ///         case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
    ///     }
    ///
    ///     let cards: [Rank] = [.five, .queen, .ace, .eight, .king]
    ///     cancellable = cards.publisher
    ///         .min {
    ///             return  $0.rawValue < $1.rawValue
    ///         }
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "ace"
    ///
    /// After this publisher receives a request for more than 0 items, it requests unlimited items from its upstream publisher.
    ///
    /// - Parameter areInIncreasingOrder: A closure that receives two elements and returns true if they’re in increasing order.
    /// - Returns: A publisher that publishes the minimum value received from the upstream publisher, after the upstream publisher finishes.
    public func czMin(by areInIncreasingOrder: @escaping (Self.Output, Self.Output) -> Bool) -> Publishers.CZComparison<Self> {
        return Publishers.CZComparison(inner: self.min(by: areInIncreasingOrder), uuid: self.generateUUID())
    }

    /// Publishes the minimum value received from the upstream publisher, using the provided error-throwing closure to order the items.
    ///
    /// Use ``Publisher/tryMin(by:)`` to determine the minimum value of elements received from the upstream publisher using an error-throwing closure you specify.
    ///
    /// In the example below, an array publishes elements. The ``Publisher/tryMin(by:)`` operator executes the error-throwing closure that throws when the `first` element is an odd number, terminating the publisher.
    ///
    ///     struct IllegalValueError: Error {}
    ///
    ///     let numbers: [Int]  = [0, 10, 6, 13, 22, 22]
    ///     numbers.publisher
    ///         .tryMin { first, second -> Bool in
    ///             if (first % 2 != 0) {
    ///                 throw IllegalValueError()
    ///             }
    ///             return first < second
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)") },
    ///             receiveValue: { print ("value: \($0)") }
    ///         )
    ///
    ///     // Prints: "completion: failure(IllegalValueError())"
    ///
    /// After this publisher receives a request for more than 0 items, it requests unlimited items from its upstream publisher.
    ///
    /// - Parameter areInIncreasingOrder: A throwing closure that receives two elements and returns `true` if they’re in increasing order. If this closure throws, the publisher terminates with a ``Subscribers/Completion/failure(_:)``.
    /// - Returns: A publisher that publishes the minimum value received from the upstream publisher, after the upstream publisher finishes.
    public func czTryMin(by areInIncreasingOrder: @escaping (Self.Output, Self.Output) throws -> Bool) -> Publishers.CZTryComparison<Self> {
        return Publishers.CZTryComparison(inner: self.tryMin(by: areInIncreasingOrder), uuid: self.generateUUID())
    }

    /// Publishes the maximum value received from the upstream publisher, using the provided ordering closure.
    ///
    /// Use ``Publisher/max(by:)`` to determine the maximum value of elements received from the upstream publisher based on an ordering closure you specify.
    ///
    /// In the example below, an array publishes enumeration elements representing playing card ranks. The ``Publisher/max(by:)`` operator compares the current and next elements using the `rawValue` property of each enumeration value in the user supplied closure and prints the maximum value found after publishing all of the elements.
    ///
    ///     enum Rank: Int {
    ///         case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
    ///     }
    ///
    ///     let cards: [Rank] = [.five, .queen, .ace, .eight, .jack]
    ///     cancellable = cards.publisher
    ///         .max {
    ///             return  $0.rawValue > $1.rawValue
    ///         }
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "queen"
    ///
    /// After this publisher receives a request for more than 0 items, it requests unlimited items from its upstream publisher.
    ///
    /// - Parameter areInIncreasingOrder: A closure that receives two elements and returns true if they’re in increasing order.
    /// - Returns: A publisher that publishes the maximum value received from the upstream publisher, after the upstream publisher finishes.
    public func czMax(by areInIncreasingOrder: @escaping (Self.Output, Self.Output) -> Bool) -> Publishers.CZComparison<Self> {
        return Publishers.CZComparison(inner: self.max(by: areInIncreasingOrder), uuid: self.generateUUID())
    }

    /// Publishes the maximum value received from the upstream publisher, using the provided error-throwing closure to order the items.
    ///
    /// Use ``Publisher/tryMax(by:)`` to determine the maximum value of elements received from the upstream publisher using an error-throwing closure you specify.
    ///
    /// In the example below, an array publishes elements. The ``Publisher/tryMax(by:)`` operator executes the error-throwing closure that throws when the `first` element is an odd number, terminating the publisher.
    ///
    ///     struct IllegalValueError: Error {}
    ///
    ///     let numbers: [Int]  = [0, 10, 6, 13, 22, 22]
    ///     cancellable = numbers.publisher
    ///         .tryMax { first, second -> Bool in
    ///             if (first % 2 != 0) {
    ///                 throw IllegalValueError()
    ///             }
    ///             return first > second
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)") },
    ///             receiveValue: { print ("value: \($0)") }
    ///         )
    ///
    ///     // Prints: completion: failure(IllegalValueError())
    ///
    /// After this publisher receives a request for more than 0 items, it requests unlimited items from its upstream publisher.
    ///
    /// - Parameter areInIncreasingOrder: A throwing closure that receives two elements and returns `true` if they’re in increasing order. If this closure throws, the publisher terminates with a ``Subscribers/Completion/failure(_:)``.
    ///
    /// - Returns: A publisher that publishes the maximum value received from the upstream publisher, after the upstream publisher finishes.
    public func czTryMax(by areInIncreasingOrder: @escaping (Self.Output, Self.Output) throws -> Bool) -> Publishers.CZTryComparison<Self> {
        return Publishers.CZTryComparison(inner: self.tryMax(by: areInIncreasingOrder), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Replaces nil elements in the stream with the provided element.
    ///
    /// The ``Publisher/replaceNil(with:)`` operator enables replacement of `nil` values in a stream with a substitute value. In the example below, a collection publisher contains a nil value. The ``Publisher/replaceNil(with:)`` operator replaces this with `0.0`.
    ///
    ///     let numbers: [Double?] = [1.0, 2.0, nil, 3.0]
    ///     numbers.publisher
    ///         .replaceNil(with: 0.0)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "Optional(1.0) Optional(2.0) Optional(0.0) Optional(3.0)"
    ///
    /// - Parameter output: The element to use when replacing `nil`.
    /// - Returns: A publisher that replaces `nil` elements from the upstream publisher with the provided element.
    public func czReplaceNil<T>(with output: T) -> Publishers.CZMap<Self, T> where Self.Output == T? {
        return Publishers.CZMap(inner: self.replaceNil(with: output), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Replaces any errors in the stream with the provided element.
    ///
    /// If the upstream publisher fails with an error, this publisher emits the provided element, then finishes normally.
    ///
    /// In the example below, a publisher of strings fails with a `MyError` instance, which sends a failure completion downstream. The ``Publisher/replaceError(with:)`` operator handles the failure by publishing the string `(replacement element)` and completing normally.
    ///
    ///     struct MyError: Error {}
    ///     let fail = Fail<String, MyError>(error: MyError())
    ///     cancellable = fail
    ///         .replaceError(with: "(replacement element)")
    ///         .sink(
    ///             receiveCompletion: { print ("\($0)") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///         )
    ///
    ///     // Prints: "(replacement element) finished".
    ///
    /// This ``Publisher/replaceError(with:)`` functionality is useful when you want to handle an error by sending a single replacement element and end the stream. Use ``Publisher/catch(_:)`` to recover from an error and provide a replacement publisher to continue providing elements to the downstream subscriber.
    ///
    /// - Parameter output: An element to emit when the upstream publisher fails.
    /// - Returns: A publisher that replaces an error from the upstream publisher with the provided output element.
    public func czReplaceError(with output: Self.Output) -> Publishers.CZReplaceError<Self> {
        return Publishers.CZReplaceError(inner: self.replaceError(with: output), uuid: self.generateUUID())
    }

    /// Replaces an empty stream with the provided element.
    ///
    /// Use ``Publisher/replaceEmpty(with:)`` to provide a replacement element if the upstream publisher finishes without producing any elements.
    ///
    /// In the example below, the empty `Double` array publisher doesn’t produce any elements, so ``Publisher/replaceEmpty(with:)`` publishes `Double.nan` and finishes normally.
    ///
    ///     let numbers: [Double] = []
    ///     cancellable = numbers.publisher
    ///         .replaceEmpty(with: Double.nan)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints "(nan)".
    ///
    /// Conversely, providing a non-empty publisher publishes all elements and the publisher then terminates normally:
    ///
    ///     let otherNumbers: [Double] = [1.0, 2.0, 3.0]
    ///     cancellable2 = otherNumbers.publisher
    ///         .replaceEmpty(with: Double.nan)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: 1.0 2.0 3.0
    ///
    /// - Parameter output: An element to emit when the upstream publisher finishes without emitting any elements.
    /// - Returns: A publisher that replaces an empty stream with the provided output element.
    public func czReplaceEmpty(with output: Self.Output) -> Publishers.CZReplaceEmpty<Self> {
        return Publishers.CZReplaceEmpty(inner: self.replaceEmpty(with: output), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Raises a fatal error when its upstream publisher fails, and otherwise republishes all received input.
    ///
    /// Use `assertNoFailure()` for internal integrity checks that are active during testing. However, it is important to note that, like its Swift counterpart `fatalError(_:)`, the `assertNoFailure()` operator asserts a fatal exception when triggered during development and testing, _and_ in shipping versions of code.
    ///
    /// In the example below, a `CurrentValueSubject` publishes the initial and second values successfully. The third value, containing a `genericSubjectError`, causes the `assertNoFailure()` operator to assert a fatal exception stopping the process:
    ///
    ///     public enum SubjectError: Error {
    ///         case genericSubjectError
    ///     }
    ///
    ///     let subject = CurrentValueSubject<String, Error>("initial value")
    ///     subject
    ///         .assertNoFailure()
    ///         .sink(receiveCompletion: { print ("completion: \($0)") },
    ///               receiveValue: { print ("value: \($0).") }
    ///         )
    ///
    ///     subject.send("second value")
    ///     subject.send(completion: Subscribers.Completion<Error>.failure(SubjectError.genericSubjectError))
    ///
    ///     // Prints:
    ///     //  value: initial value.
    ///     //  value: second value.
    ///     //  The process then terminates in the debugger as the assertNoFailure operator catches the genericSubjectError.
    ///
    /// - Parameters:
    ///   - prefix: A string used at the beginning of the fatal error message.
    ///   - file: A filename used in the error message. This defaults to `#file`.
    ///   - line: A line number used in the error message. This defaults to `#line`.
    /// - Returns: A publisher that raises a fatal error when its upstream publisher fails.
    public func czAssertNoFailure(_ prefix: String = "", file: StaticString = #file, line: UInt = #line) -> Publishers.CZAssertNoFailure<Self> {
        return Publishers.CZAssertNoFailure(inner: self.assertNoFailure(prefix, file: file, line: line), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Ignores elements from the upstream publisher until it receives an element from a second publisher.
    ///
    /// Use ``Publisher/drop(untilOutputFrom:)`` to ignore elements from the upstream publisher until another, second, publisher delivers its first element.
    /// This publisher requests a single value from the second publisher, and it ignores (drops) all elements from the upstream publisher until the second publisher produces a value. After the second publisher produces an element, ``Publisher/drop(untilOutputFrom:)`` cancels its subscription to the second publisher, and allows events from the upstream publisher to pass through.
    ///
    /// After this publisher receives a subscription from the upstream publisher, it passes through backpressure requests from downstream to the upstream publisher. If the upstream publisher acts on those requests before the other publisher produces an item, this publisher drops the elements it receives from the upstream publisher.
    ///
    /// In the example below, the `pub1` publisher defers publishing its elements until the `pub2` publisher delivers its first element:
    ///
    ///     let upstream = PassthroughSubject<Int,Never>()
    ///     let second = PassthroughSubject<String,Never>()
    ///     cancellable = upstream
    ///         .drop(untilOutputFrom: second)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     upstream.send(1)
    ///     upstream.send(2)
    ///     second.send("A")
    ///     upstream.send(3)
    ///     upstream.send(4)
    ///     // Prints "3 4"
    ///
    /// - Parameter publisher: A publisher to monitor for its first emitted element.
    /// - Returns: A publisher that drops elements from the upstream publisher until the `other` publisher produces a value.
    public func czDrop<P>(untilOutputFrom publisher: P) -> Publishers.CZDropUntilOutput<Self, P> where P : Publisher, Self.Failure == P.Failure {
        return Publishers.CZDropUntilOutput(inner: self.drop(untilOutputFrom: publisher), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Performs the specified closures when publisher events occur.
    ///
    /// Use ``Publisher/handleEvents(receiveSubscription:receiveOutput:receiveCompletion:receiveCancel:receiveRequest:)`` when you want to examine elements as they progress through the stages of the publisher’s lifecycle.
    ///
    /// In the example below, a publisher of integers shows the effect of printing debugging information at each stage of the element-processing lifecycle:
    ///
    ///     let integers = (0...2)
    ///     cancellable = integers.publisher
    ///         .handleEvents(receiveSubscription: { subs in
    ///             print("Subscription: \(subs.combineIdentifier)")
    ///         }, receiveOutput: { anInt in
    ///             print("in output handler, received \(anInt)")
    ///         }, receiveCompletion: { _ in
    ///             print("in completion handler")
    ///         }, receiveCancel: {
    ///             print("received cancel")
    ///         }, receiveRequest: { (demand) in
    ///             print("received demand: \(demand.description)")
    ///         })
    ///         .sink { _ in return }
    ///
    ///     // Prints:
    ///     //   received demand: unlimited
    ///     //   Subscription: 0x7f81284734c0
    ///     //   in output handler, received 0
    ///     //   in output handler, received 1
    ///     //   in output handler, received 2
    ///     //   in completion handler
    ///
    ///
    /// - Parameters:
    ///   - receiveSubscription: An optional closure that executes when the publisher receives the subscription from the upstream publisher. This value defaults to `nil`.
    ///   - receiveOutput: An optional closure that executes when the publisher receives a value from the upstream publisher. This value defaults to `nil`.
    ///   - receiveCompletion: An optional closure that executes when the upstream publisher finishes normally or terminates with an error. This value defaults to `nil`.
    ///   - receiveCancel: An optional closure that executes when the downstream receiver cancels publishing. This value defaults to `nil`.
    ///   - receiveRequest: An optional closure that executes when the publisher receives a request for more elements. This value defaults to `nil`.
    /// - Returns: A publisher that performs the specified closures when publisher events occur.
    public func czHandleEvents(receiveSubscription: ((Subscription) -> Void)? = nil, receiveOutput: ((Self.Output) -> Void)? = nil, receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil, receiveCancel: (() -> Void)? = nil, receiveRequest: ((Subscribers.Demand) -> Void)? = nil) -> Publishers.CZHandleEvents<Self> {
        return Publishers.CZHandleEvents(inner: self.handleEvents(receiveSubscription: receiveSubscription, receiveOutput: receiveOutput, receiveCompletion: receiveCompletion, receiveCancel: receiveCancel, receiveRequest: receiveRequest), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Prefixes a publisher’s output with the specified values.
    ///
    /// Use ``Publisher/prepend(_:)-7wk5l`` when you need to prepend specific elements before the output of a publisher.
    ///
    /// In the example below, the ``Publisher/prepend(_:)-7wk5l`` operator publishes the provided elements before republishing all elements from `dataElements`:
    ///
    ///     let dataElements = (0...10)
    ///     cancellable = dataElements.publisher
    ///         .prepend(0, 1, 255)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1 255 0 1 2 3 4 5 6 7 8 9 10"
    ///
    /// - Parameter elements: The elements to publish before this publisher’s elements.
    /// - Returns: A publisher that prefixes the specified elements prior to this publisher’s elements.
    public func czPrepend(_ elements: Self.Output...) -> Publishers.CZConcatenate<Publishers.Sequence<[Self.Output], Self.Failure>, Self> {
        return Publishers.CZConcatenate(inner: self.prepend(elements), uuid: self.generateUUID())
    }

    /// Prefixes a publisher’s output with the specified sequence.
    ///
    /// Use ``Publisher/prepend(_:)-v9sb`` to publish values from two publishers when you need to prepend one publisher’s elements to another.
    ///
    /// In this example the ``Publisher/prepend(_:)-v9sb`` operator publishes the provided sequence before republishing all elements from `dataElements`:
    ///
    ///     let prefixValues = [0, 1, 255]
    ///     let dataElements = (0...10)
    ///     cancellable = dataElements.publisher
    ///         .prepend(prefixValues)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1 255 0 1 2 3 4 5 6 7 8 9 10"
    ///
    /// - Parameter elements: A sequence of elements to publish before this publisher’s elements.
    /// - Returns: A publisher that prefixes the sequence of elements prior to this publisher’s elements.
    public func czPrepend<S>(_ elements: S) -> Publishers.CZConcatenate<Publishers.Sequence<S, Self.Failure>, Self> where S : Sequence, Self.Output == S.Element {
        return Publishers.CZConcatenate(inner: self.prepend(elements), uuid: self.generateUUID())
    }

    /// Prefixes the output of this publisher with the elements emitted by the given publisher.
    ///
    /// Use ``Publisher/prepend(_:)-5dj9c`` to publish values from two publishers when you need to prepend one publisher’s elements to another.
    ///
    /// In the example below, a publisher of `prefixValues` publishes its elements before the `dataElements` publishes its elements:
    ///
    ///     let prefixValues = [0, 1, 255]
    ///     let dataElements = (0...10)
    ///     cancellable = dataElements.publisher
    ///         .prepend(prefixValues.publisher)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1 255 0 1 2 3 4 5 6 7 8 9 10"
    ///
    /// - Parameter publisher: The prefixing publisher.
    /// - Returns: A publisher that prefixes the prefixing publisher’s elements prior to this publisher’s elements.
    public func czPrepend<P>(_ publisher: P) -> Publishers.CZConcatenate<P, Self> where P : Publisher, Self.Failure == P.Failure, Self.Output == P.Output {
        return Publishers.CZConcatenate(inner: self.prepend(publisher), uuid: self.generateUUID())
    }

    /// Appends a publisher’s output with the specified elements.
    ///
    /// Use ``Publisher/append(_:)-1qb8d`` when you need to prepend specific elements after the output of a publisher.
    ///
    /// In the example below, the ``Publisher/append(_:)-1qb8d`` operator publishes the provided elements after republishing all elements from `dataElements`:
    ///
    ///     let dataElements = (0...10)
    ///     cancellable = dataElements.publisher
    ///         .append(0, 1, 255)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1 2 3 4 5 6 7 8 9 10 0 1 255"
    ///
    ///
    /// - Parameter elements: Elements to publish after this publisher’s elements.
    /// - Returns: A publisher that appends the specifiecd elements after this publisher’s elements.
    public func czAppend(_ elements: Self.Output...) -> Publishers.CZConcatenate<Self, Publishers.Sequence<[Self.Output], Self.Failure>> {
        return Publishers.CZConcatenate(inner: self.append(elements), uuid: self.generateUUID())
    }

    /// Appends a publisher’s output with the specified sequence.
    ///
    /// Use ``Publisher/append(_:)-69sdn`` to append a sequence to the end of a publisher’s output.
    ///
    /// In the example below, the ``Publisher/append(_:)-69sdn`` publisher republishes all elements from `groundTransport` until it finishes, then publishes the members of `airTransport`:
    ///
    ///     let groundTransport = ["car", "bus", "truck", "subway", "bicycle"]
    ///     let airTransport = ["parasail", "jet", "helicopter", "rocket"]
    ///     cancellable = groundTransport.publisher
    ///         .append(airTransport)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "car bus truck subway bicycle parasail jet helicopter rocket"
    ///
    /// - Parameter elements: A sequence of elements to publish after this publisher’s elements.
    /// - Returns: A publisher that appends the sequence of elements after this publisher’s elements.
    public func czAppend<S>(_ elements: S) -> Publishers.CZConcatenate<Self, Publishers.Sequence<S, Self.Failure>> where S : Sequence, Self.Output == S.Element {
        return Publishers.CZConcatenate(inner: self.append(elements), uuid: self.generateUUID())
    }

    /// Appends the output of this publisher with the elements emitted by the given publisher.
    ///
    /// Use ``Publisher/append(_:)-5yh02`` to append the output of one publisher to another. The ``Publisher/append(_:)-5yh02`` operator produces no elements until this publisher finishes. It then produces this publisher’s elements, followed by the given publisher’s elements. If this publisher fails with an error, the given publishers elements aren’t published.
    ///
    /// In the example below, the `append` publisher republishes all elements from the `numbers` publisher until it finishes, then publishes all elements from the `otherNumbers` publisher:
    ///
    ///     let numbers = (0...10)
    ///     let otherNumbers = (25...35)
    ///     cancellable = numbers.publisher
    ///         .append(otherNumbers.publisher)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "0 1 2 3 4 5 6 7 8 9 10 25 26 27 28 29 30 31 32 33 34 35 "
    ///
    /// - Parameter publisher: The appending publisher.
    /// - Returns: A publisher that appends the appending publisher’s elements after this publisher’s elements.
    public func czAppend<P>(_ publisher: P) -> Publishers.CZConcatenate<Self, P> where P : Publisher, Self.Failure == P.Failure, Self.Output == P.Output {
        return Publishers.CZConcatenate(inner: self.append(publisher), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes elements only after a specified time interval elapses between events.
    ///
    /// Use the ``Publisher/debounce(for:scheduler:options:)`` operator to control the number of values and time between delivery of values from the upstream publisher. This operator is useful to process bursty or high-volume event streams where you need to reduce the number of values delivered to the downstream to a rate you specify.
    ///
    /// In this example, a ``PassthroughSubject`` publishes elements on a schedule defined by the `bounces` array. The array is composed of tuples representing a value sent by the ``PassthroughSubject``, and a <doc://com.apple.documentation/documentation/Foundation/TimeInterval> ranging from one-quarter second up to 2 seconds that drives a delivery timer. As the queue builds, elements arriving faster than one-half second `debounceInterval` are discarded, while elements arriving at a rate slower than `debounceInterval` are passed through to the ``Publisher/sink(receiveValue:)`` operator.
    ///
    ///     let bounces:[(Int,TimeInterval)] = [
    ///         (0, 0),
    ///         (1, 0.25),  // 0.25s interval since last index
    ///         (2, 1),     // 0.75s interval since last index
    ///         (3, 1.25),  // 0.25s interval since last index
    ///         (4, 1.5),   // 0.25s interval since last index
    ///         (5, 2)      // 0.5s interval since last index
    ///     ]
    ///
    ///     let subject = PassthroughSubject<Int, Never>()
    ///     cancellable = subject
    ///         .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    ///         .sink { index in
    ///             print ("Received index \(index)")
    ///         }
    ///
    ///     for bounce in bounces {
    ///         DispatchQueue.main.asyncAfter(deadline: .now() + bounce.1) {
    ///             subject.send(bounce.0)
    ///         }
    ///     }
    ///
    ///     // Prints:
    ///     //  Received index 1
    ///     //  Received index 4
    ///     //  Received index 5
    ///
    ///     //  Here is the event flow shown from the perspective of time, showing value delivery through the `debounce()` operator:
    ///
    ///     //  Time 0: Send index 0.
    ///     //  Time 0.25: Send index 1. Index 0 was waiting and is discarded.
    ///     //  Time 0.75: Debounce period ends, publish index 1.
    ///     //  Time 1: Send index 2.
    ///     //  Time 1.25: Send index 3. Index 2 was waiting and is discarded.
    ///     //  Time 1.5: Send index 4. Index 3 was waiting and is discarded.
    ///     //  Time 2: Debounce period ends, publish index 4. Also, send index 5.
    ///     //  Time 2.5: Debounce period ends, publish index 5.
    ///
    /// - Parameters:
    ///   - dueTime: The time the publisher should wait before publishing an element.
    ///   - scheduler: The scheduler on which this publisher delivers elements
    ///   - options: Scheduler options that customize this publisher’s delivery of elements.
    /// - Returns: A publisher that publishes events only after a specified time elapses.
    public func czDebounce<S>(for dueTime: S.SchedulerTimeType.Stride, scheduler: S, options: S.SchedulerOptions? = nil) -> Publishers.CZDebounce<Self, S> where S : Scheduler {
        return Publishers.CZDebounce(inner: self.debounce(for: dueTime, scheduler: scheduler, options: options), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes the last element of a stream, after the stream finishes.
    ///
    /// Use ``Publisher/last()`` when you need to emit only the last element from an upstream publisher.
    ///
    /// In the example below, the range publisher only emits the last element from the sequence publisher, `10`, then finishes normally.
    ///
    ///     let numbers = (-10...10)
    ///     cancellable = numbers.publisher
    ///         .last()
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "10"
    ///
    /// - Returns: A publisher that only publishes the last element of a stream.
    public func czLast() -> Publishers.CZLast<Self> {
        return Publishers.CZLast(inner: self.last(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Transforms all elements from the upstream publisher with a provided closure.
    ///
    /// Combine’s ``Publisher/map(_:)-99evh`` operator performs a function similar to that of <doc://com.apple.documentation/documentation/Swift/Sequence/3018373-map> in the Swift standard library: it uses a closure to transform each element it receives from the upstream publisher. You use ``Publisher/map(_:)-99evh`` to transform from one kind of element to another.
    ///
    /// The following example uses an array of numbers as the source for a collection based publisher. A ``Publisher/map(_:)-99evh`` operator consumes each integer from the publisher and uses a dictionary to transform it from its Arabic numeral to a Roman equivalent, as a <doc://com.apple.documentation/documentation/Swift/String>.
    /// If the ``Publisher/map(_:)-99evh``’s closure fails to look up a Roman numeral, it returns the string `(unknown)`.
    ///
    ///     let numbers = [5, 4, 3, 2, 1, 0]
    ///     let romanNumeralDict: [Int : String] =
    ///        [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
    ///     cancellable = numbers.publisher
    ///         .map { romanNumeralDict[$0] ?? "(unknown)" }
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "V IV III II I (unknown)"
    ///
    /// If your closure can throw an error, use Combine’s ``Publisher/tryMap(_:)`` operator instead.
    ///
    /// - Parameter transform: A closure that takes one element as its parameter and returns a new element.
    /// - Returns: A publisher that uses the provided closure to map elements from the upstream publisher to new elements that it then publishes.
    public func czMap<T>(_ transform: @escaping (Self.Output) -> T) -> Publishers.CZMap<Self, T> {
        return Publishers.CZMap(inner: self.map(transform), uuid: self.generateUUID())
    }

    /// Transforms all elements from the upstream publisher with a provided error-throwing closure.
    ///
    /// Combine’s ``Publisher/tryMap(_:)`` operator performs a function similar to that of <doc://com.apple.documentation/documentation/Swift/Sequence/3018373-map> in the Swift standard library: it uses a closure to transform each element it receives from the upstream publisher. You use ``Publisher/tryMap(_:)`` to transform from one kind of element to another, and to terminate publishing when the map’s closure throws an error.
    ///
    /// The following example uses an array of numbers as the source for a collection based publisher. A ``Publisher/tryMap(_:)`` operator consumes each integer from the publisher and uses a dictionary to transform it from its Arabic numeral to a Roman equivalent, as a <doc://com.apple.documentation/documentation/Swift/String>.
    /// If the ``Publisher/tryMap(_:)``’s closure fails to look up a Roman numeral, it throws an error. The ``Publisher/tryMap(_:)`` operator catches this error and terminates publishing, sending a ``Subscribers/Completion/failure(_:)`` that wraps the error.
    ///
    ///     struct ParseError: Error {}
    ///     func romanNumeral(from:Int) throws -> String {
    ///         let romanNumeralDict: [Int : String] =
    ///             [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
    ///         guard let numeral = romanNumeralDict[from] else {
    ///             throw ParseError()
    ///         }
    ///         return numeral
    ///     }
    ///     let numbers = [5, 4, 3, 2, 1, 0]
    ///     cancellable = numbers.publisher
    ///         .tryMap { try romanNumeral(from: $0) }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///          )
    ///
    ///     // Prints: "V IV III II I completion: failure(ParseError())"
    ///
    /// If your closure doesn’t throw, use ``Publisher/map(_:)-99evh`` instead.
    ///
    /// - Parameter transform: A closure that takes one element as its parameter and returns a new element. If the closure throws an error, the publisher fails with the thrown error.
    /// - Returns: A publisher that uses the provided closure to map elements from the upstream publisher to new elements that it then publishes.
    public func czTryMap<T>(_ transform: @escaping (Self.Output) throws -> T) -> Publishers.CZTryMap<Self, T> {
        return Publishers.CZTryMap(inner: self.tryMap(transform), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Terminates publishing if the upstream publisher exceeds the specified time interval without producing an element.
    ///
    /// Use ``Publisher/timeout(_:scheduler:options:customError:)`` to terminate a publisher if an element isn’t delivered within a timeout interval you specify.
    ///
    /// In the example below, a ``PassthroughSubject`` publishes <doc://com.apple.documentation/documentation/Swift/String> elements and is configured to time out if no new elements are received within its `TIME_OUT` window of 5 seconds. A single value is published after the specified 2-second `WAIT_TIME`, after which no more elements are available; the publisher then times out and completes normally.
    ///
    ///     var WAIT_TIME : Int = 2
    ///     var TIMEOUT_TIME : Int = 5
    ///
    ///     let subject = PassthroughSubject<String, Never>()
    ///     let cancellable = subject
    ///         .timeout(.seconds(TIMEOUT_TIME), scheduler: DispatchQueue.main, options: nil, customError:nil)
    ///         .sink(
    ///               receiveCompletion: { print ("completion: \($0) at \(Date())") },
    ///               receiveValue: { print ("value: \($0) at \(Date())") }
    ///          )
    ///
    ///     DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(WAIT_TIME),
    ///                                   execute: { subject.send("Some data - sent after a delay of \(WAIT_TIME) seconds") } )
    ///
    ///     // Prints: value: Some data - sent after a delay of 2 seconds at 2020-03-10 23:47:59 +0000
    ///     //         completion: finished at 2020-03-10 23:48:04 +0000
    ///
    ///
    /// If `customError` is `nil`, the publisher completes normally; if you provide a closure for the `customError` argument, the upstream publisher is instead terminated upon timeout, and the error is delivered to the downstream.
    ///
    /// - Parameters:
    ///   - interval: The maximum time interval the publisher can go without emitting an element, expressed in the time system of the scheduler.
    ///   - scheduler: The scheduler on which to deliver events.
    ///   - options: Scheduler options that customize the delivery of elements.
    ///   - customError: A closure that executes if the publisher times out. The publisher sends the failure returned by this closure to the subscriber as the reason for termination.
    /// - Returns: A publisher that terminates if the specified interval elapses with no events received from the upstream publisher.
    public func czTimeout<S>(_ interval: S.SchedulerTimeType.Stride, scheduler: S, options: S.SchedulerOptions? = nil, customError: (() -> Self.Failure)? = nil) -> Publishers.CZTimeout<Self, S> where S : Scheduler {
        return Publishers.CZTimeout(inner: self.timeout(interval, scheduler: scheduler, options: options, customError: customError), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Buffers elements received from an upstream publisher.
    ///
    /// Use ``Publisher/buffer(size:prefetch:whenFull:)`` to collect a specific number of elements from an upstream publisher before republishing them to the downstream subscriber according to the ``Publishers/BufferingStrategy`` and ``Publishers/PrefetchStrategy`` strategy you specify.
    ///
    /// If the publisher completes before reaching the `size` threshold, it buffers the elements and publishes them downstream prior to completion.
    ///
    /// - Parameters:
    ///   - size: The maximum number of elements to store.
    ///   - prefetch: The strategy to initially populate the buffer.
    ///   - whenFull: The action to take when the buffer becomes full.
    /// - Returns: A publisher that buffers elements received from an upstream publisher.
    public func czBuffer(size: Int, prefetch: Publishers.PrefetchStrategy, whenFull: Publishers.BufferingStrategy<Self.Failure>) -> Publishers.CZBuffer<Self> {
        return Publishers.CZBuffer(inner: self.buffer(size: size, prefetch: prefetch, whenFull: whenFull), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Combines elements from another publisher and deliver pairs of elements as tuples.
    ///
    /// Use ``Publisher/zip(_:)`` to combine the latest elements from two publishers and emit a tuple to the downstream. The returned publisher waits until both publishers have emitted an event, then delivers the oldest unconsumed event from each publisher together as a tuple to the subscriber.
    ///
    /// Much like a zipper or zip fastener on a piece of clothing pulls together rows of teeth to link the two sides, ``Publisher/zip(_:)`` combines streams from two different publishers by linking pairs of elements from each side.
    ///
    /// In this example, `numbers` and `letters` are ``PassthroughSubject``s that emit values; once ``Publisher/zip(_:)`` receives one value from each, it publishes the pair as a tuple to the downstream subscriber. It then waits for the next pair of values.
    ///
    ///      let numbersPub = PassthroughSubject<Int, Never>()
    ///      let lettersPub = PassthroughSubject<String, Never>()
    ///
    ///      cancellable = numbersPub
    ///          .zip(lettersPub)
    ///          .sink { print("\($0)") }
    ///      numbersPub.send(1)    // numbersPub: 1      lettersPub:        zip output: <none>
    ///      numbersPub.send(2)    // numbersPub: 1,2    lettersPub:        zip output: <none>
    ///      letters.send("A")     // numbers: 1,2       letters:"A"        zip output: <none>
    ///      numbers.send(3)       // numbers: 1,2,3     letters:           zip output: (1,"A")
    ///      letters.send("B")     // numbers: 1,2,3     letters: "B"       zip output: (2,"B")
    ///
    ///      // Prints:
    ///      //  (1, "A")
    ///      //  (2, "B")
    ///
    /// If either upstream publisher finishes successfully or fails with an error, the zipped publisher does the same.
    ///
    /// - Parameter other: Another publisher.
    /// - Returns: A publisher that emits pairs of elements from the upstream publishers as tuples.
    public func czZip<P>(_ other: P) -> Publishers.CZZip<Self, P> where P : Publisher, Self.Failure == P.Failure {
        return Publishers.CZZip(inner: self.zip(other), uuid: self.generateUUID())
    }

    /// Combines elements from another publisher and delivers a transformed output.
    ///
    /// Use ``Publisher/zip(_:_:)-4xn21`` to return a new publisher that combines the elements from two publishers using a transformation you specify to publish a new value to the downstream.  The returned publisher waits until both publishers have emitted an event, then delivers the oldest unconsumed event from each publisher together that the operator uses in the transformation.
    ///
    /// In this example, ``PassthroughSubject`` instances `numbersPub` and `lettersPub` emit values; ``Publisher/zip(_:_:)-4xn21`` receives the oldest value from each publisher, uses the `Int` from `numbersPub` and publishes a string that repeats the <doc://com.apple.documentation/documentation/Swift/String> from `lettersPub` that many times.
    ///
    ///     let numbersPub = PassthroughSubject<Int, Never>()
    ///     let lettersPub = PassthroughSubject<String, Never>()
    ///     cancellable = numbersPub
    ///         .zip(lettersPub) { anInt, aLetter in
    ///             String(repeating: aLetter, count: anInt)
    ///         }
    ///         .sink { print("\($0)") }
    ///     numbersPub.send(1)     // numbersPub: 1      lettersPub:       zip output: <none>
    ///     numbersPub.send(2)     // numbersPub: 1,2    lettersPub:       zip output: <none>
    ///     numbersPub.send(3)     // numbersPub: 1,2,3  lettersPub:       zip output: <none>
    ///     lettersPub.send("A")   // numbersPub: 1,2,3  lettersPub: "A"   zip output: "A"
    ///     lettersPub.send("B")   // numbersPub: 2,3    lettersPub: "B"   zip output: "BB"
    ///     // Prints:
    ///     //  A
    ///     //  BB
    ///
    /// If either upstream publisher finishes successfully or fails with an error, the zipped publisher does the same.
    ///
    /// - Parameters:
    ///   - other: Another publisher.
    ///   - transform: A closure that receives the most-recent value from each publisher and returns a new value to publish.
    /// - Returns: A publisher that uses the `transform` closure to emit new elements, produced by combining the most recent value from two upstream publishers.
    public func czZip<P, T>(_ other: P, _ transform: @escaping (Self.Output, P.Output) -> T) -> Publishers.CZMap<Publishers.Zip<Self, P>, T> where P : Publisher, Self.Failure == P.Failure {
        return Publishers.CZMap(inner: self.zip(other, transform), uuid: self.generateUUID())
    }

    /// Combines elements from two other publishers and delivers groups of elements as tuples.
    ///
    /// Use ``Publisher/zip(_:_:)-8d7k7`` to return a new publisher that combines the elements from two additional publishers to publish a tuple to the downstream. The returned publisher waits until all three publishers have emitted an event, then delivers the oldest unconsumed event from each publisher as a tuple to the subscriber.
    ///
    /// In this example, `numbersPub`, `lettersPub` and `emojiPub` are each a ``PassthroughSubject``;
    /// ``Publisher/zip(_:_:)-8d7k7`` receives the oldest unconsumed value from each publisher and combines them into a tuple that it republishes to the downstream:
    ///
    ///     let numbersPub = PassthroughSubject<Int, Never>()
    ///     let lettersPub = PassthroughSubject<String, Never>()
    ///     let emojiPub = PassthroughSubject<String, Never>()
    ///
    ///     cancellable = numbersPub
    ///         .zip(lettersPub, emojiPub)
    ///         .sink { print("\($0)") }
    ///     numbersPub.send(1)     // numbersPub: 1      lettersPub:          emojiPub:        zip output: <none>
    ///     numbersPub.send(2)     // numbersPub: 1,2    lettersPub:          emojiPub:        zip output: <none>
    ///     numbersPub.send(3)     // numbersPub: 1,2,3  lettersPub:          emojiPub:        zip output: <none>
    ///     lettersPub.send("A")   // numbersPub: 1,2,3  lettersPub: "A"      emojiPub:        zip output: <none>
    ///     emojiPub.send("😀")    // numbersPub: 2,3    lettersPub: "A"      emojiPub: "😀"   zip output: (1, "A", "😀")
    ///     lettersPub.send("B")   // numbersPub: 2,3    lettersPub: "B"      emojiPub:        zip output: <none>
    ///     emojiPub.send("🥰")    // numbersPub: 3      lettersPub:          emojiPub:        zip output: (2, "B", "🥰")
    ///
    ///     // Prints:
    ///     //  (1, "A", "😀")
    ///     //  (2, "B", "🥰")
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    ///
    /// - Parameters:
    ///   - publisher1: A second publisher.
    ///   - publisher2: A third publisher.
    /// - Returns: A publisher that emits groups of elements from the upstream publishers as tuples.
    public func czZip<P, Q>(_ publisher1: P, _ publisher2: Q) -> Publishers.CZZip3<Self, P, Q> where P : Publisher, Q : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure {
        return Publishers.CZZip3(inner: self.zip(publisher1, publisher2), uuid: self.generateUUID())
    }

    /// Combines elements from two other publishers and delivers a transformed output.
    ///
    /// Use ``Publisher/zip(_:_:_:)-9yqi1`` to return a new publisher that combines the elements from two other publishers using a transformation you specify to publish a new value to the downstream subscriber. The returned publisher waits until all three publishers have emitted an event, then delivers the oldest unconsumed event from each publisher together that the operator uses in the transformation.
    ///
    /// In this example, `numbersPub`, `lettersPub` and `emojiPub` are each a ``PassthroughSubject`` that emit values; ``Publisher/zip(_:_:_:)-9yqi1`` receives the oldest value from each publisher and uses the `Int` from `numbersPub` and publishes a string that repeats the <doc://com.apple.documentation/documentation/Swift/String> from `lettersPub` and `emojiPub` that many times.
    ///
    ///     let numbersPub = PassthroughSubject<Int, Never>()
    ///     let lettersPub = PassthroughSubject<String, Never>()
    ///     let emojiPub = PassthroughSubject<String, Never>()
    ///
    ///     cancellable = numbersPub
    ///         .zip(letters, emoji) { anInt, aLetter, anEmoji in
    ///             ("\(String(repeating: anEmoji, count: anInt)) \(String(repeating: aLetter, count: anInt))")
    ///         }
    ///         .sink { print("\($0)") }
    ///
    ///     numbersPub.send(1)     // numbersPub: 1      lettersPub:        emojiPub:            zip output: <none>
    ///     numbersPub.send(2)     // numbersPub: 1,2    lettersPub:        emojiPub:            zip output: <none>
    ///     numbersPub.send(3)     // numbersPub: 1,2,3  lettersPub:        emojiPub:            zip output: <none>
    ///     lettersPub.send("A")   // numbersPub: 1,2,3  lettersPub: "A"    emojiPub:            zip output: <none>
    ///     emojiPub.send("😀")    // numbersPub: 2,3    lettersPub: "A"    emojiPub:"😀"        zip output: "😀 A"
    ///     lettersPub.send("B")   // numbersPub: 2,3    lettersPub: "B"    emojiPub:            zip output: <none>
    ///     emojiPub.send("🥰")    // numbersPub: 3      lettersPub:        emojiPub:"😀", "🥰"  zip output: "🥰🥰 BB"
    ///
    ///     // Prints:
    ///     // 😀 A
    ///     // 🥰🥰 BB
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    ///
    /// - Parameters:
    ///   - publisher1: A second publisher.
    ///   - publisher2: A third publisher.
    ///   - transform: A closure that receives the most-recent value from each publisher and returns a new value to publish.
    /// - Returns: A publisher that uses the `transform` closure to emit new elements, produced by combining the most recent value from three upstream publishers.
    public func czZip<P, Q, T>(_ publisher1: P, _ publisher2: Q, _ transform: @escaping (Self.Output, P.Output, Q.Output) -> T) -> Publishers.CZMap<Publishers.Zip3<Self, P, Q>, T> where P : Publisher, Q : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure {
        return Publishers.CZMap(inner: self.zip(publisher1, publisher2, transform), uuid: self.generateUUID())
    }

    /// Combines elements from three other publishers and delivers groups of elements as tuples.
    ///
    /// Use ``Publisher/zip(_:_:_:)-16rcy`` to return a new publisher that combines the elements from three other publishers to publish a tuple to the downstream subscriber. The returned publisher waits until all four publishers have emitted an event, then delivers the oldest unconsumed event from each publisher as a tuple to the subscriber.
    ///
    /// In this example, several ``PassthroughSubject`` instances emit values; ``Publisher/zip(_:_:_:)-16rcy`` receives the oldest unconsumed value from each publisher and combines them into a tuple that it republishes to the downstream:
    ///
    ///     let numbersPub = PassthroughSubject<Int, Never>()
    ///     let lettersPub = PassthroughSubject<String, Never>()
    ///     let emojiPub = PassthroughSubject<String, Never>()
    ///     let fractionsPub  = PassthroughSubject<Double, Never>()
    ///
    ///     cancellable = numbersPub
    ///         .zip(lettersPub, emojiPub, fractionsPub)
    ///         .sink { print("\($0)") }
    ///     numbersPub.send(1)         // numbersPub: 1       lettersPub:        emojiPub:       fractionsPub:         zip output: <none>
    ///     numbersPub.send(2)         // numbersPub: 1,2     lettersPub:        emojiPub:       fractionsPub:         zip output: <none>
    ///     numbersPub.send(3)         // numbersPub: 1,2,3   lettersPub:        emojiPub:       fractionsPub:         zip output: <none>
    ///     fractionsPub.send(0.1)     // numbersPub: 1,2,3   lettersPub: "A"    emojiPub:       fractionsPub: 0.1     zip output: <none>
    ///     lettersPub.send("A")       // numbersPub: 1,2,3   lettersPub: "A"    emojiPub:       fractionsPub: 0.1     zip output: <none>
    ///     emojiPub.send("😀")        // numbersPub: 2,3     lettersPub: "A"    emojiPub: "😀"  fractionsPub: 0.1     zip output: (1, "A", "😀", 0.1)
    ///     lettersPub.send("B")       // numbersPub: 2,3     lettersPub: "B"    emojiPub:       fractionsPub:         zip output: <none>
    ///     fractionsPub.send(0.8)     // numbersPub: 2,3     lettersPub: "B"    emojiPub:       fractionsPub: 0.8     zip output: <none>
    ///     emojiPub.send("🥰")        // numbersPub: 3       lettersPub: "B"    emojiPub:       fractionsPub: 0.8     zip output: (2, "B", "🥰", 0.8)
    ///     // Prints:
    ///     //  (1, "A", "😀", 0.1)
    ///     //  (2, "B", "🥰", 0.8)
    ///
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    ///
    /// - Parameters:
    ///   - publisher1: A second publisher.
    ///   - publisher2: A third publisher.
    ///   - publisher3: A fourth publisher.
    /// - Returns: A publisher that emits groups of elements from the upstream publishers as tuples.
    public func czZip<P, Q, R>(_ publisher1: P, _ publisher2: Q, _ publisher3: R) -> Publishers.CZZip4<Self, P, Q, R> where P : Publisher, Q : Publisher, R : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure, Q.Failure == R.Failure {
        return Publishers.CZZip4(inner: self.zip(publisher1, publisher2, publisher3), uuid: self.generateUUID())
    }

    /// Combines elements from three other publishers and delivers a transformed output.
    ///
    /// Use ``Publisher/zip(_:_:_:_:)`` to return a new publisher that combines the elements from three other publishers using a transformation you specify to publish a new value to the downstream subscriber. The returned publisher waits until all four publishers have emitted an event, then delivers the oldest unconsumed event from each publisher together that the operator uses in the transformation.
    ///
    /// In this example, the ``PassthroughSubject`` publishers, `numbersPub`,
    /// `fractionsPub`, `lettersPub`, and `emojiPub` emit values. The ``Publisher/zip(_:_:_:_:)`` operator receives the oldest value from each publisher and uses the `Int` from `numbersPub` and publishes a string that repeats the <doc://com.apple.documentation/documentation/Swift/String> from `lettersPub` and `emojiPub` that many times and prints out the value in `fractionsPub`.
    ///
    ///     let numbersPub = PassthroughSubject<Int, Never>()      // first publisher
    ///     let lettersPub = PassthroughSubject<String, Never>()   // second
    ///     let emojiPub = PassthroughSubject<String, Never>()     // third
    ///     let fractionsPub  = PassthroughSubject<Double, Never>()// fourth
    ///
    ///     cancellable = numbersPub
    ///         .zip(lettersPub, emojiPub, fractionsPub) { anInt, aLetter, anEmoji, aFraction  in
    ///             ("\(String(repeating: anEmoji, count: anInt)) \(String(repeating: aLetter, count: anInt)) \(aFraction)")
    ///         }
    ///         .sink { print("\($0)") }
    ///
    ///     numbersPub.send(1)         // numbersPub: 1       lettersPub:          emojiPub:          zip output: <none>
    ///     numbersPub.send(2)         // numbersPub: 1,2     lettersPub:          emojiPub:          zip output: <none>
    ///     numbersPub.send(3)         // numbersPub: 1,2,3   lettersPub:          emojiPub:          zip output: <none>
    ///     fractionsPub.send(0.1)     // numbersPub: 1,2,3   lettersPub: "A"      emojiPub:          zip output: <none>
    ///     lettersPub.send("A")       // numbersPub: 1,2,3   lettersPub: "A"      emojiPub:          zip output: <none>
    ///     emojiPub.send("😀")        // numbersPub: 1,2,3   lettersPub: "A"      emojiPub:"😀"      zip output: "😀 A"
    ///     lettersPub.send("B")       // numbersPub: 2,3     lettersPub: "B"      emojiPub:          zip output: <none>
    ///     fractionsPub.send(0.8)     // numbersPub: 2,3     lettersPub: "A"      emojiPub:          zip output: <none>
    ///     emojiPub.send("🥰")        // numbersPub: 3       lettersPub: "B"      emojiPub:          zip output: "🥰🥰 BB"
    ///     // Prints:
    ///     //1 😀 A 0.1
    ///     //2 🥰🥰 BB 0.8
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    ///
    /// - Parameters:
    ///   - publisher1: A second publisher.
    ///   - publisher2: A third publisher.
    ///   - publisher3: A fourth publisher.
    ///   - transform: A closure that receives the most-recent value from each publisher and returns a new value to publish.
    /// - Returns: A publisher that uses the `transform` closure to emit new elements, produced by combining the most recent value from four upstream publishers.
    public func czZip<P, Q, R, T>(_ publisher1: P, _ publisher2: Q, _ publisher3: R, _ transform: @escaping (Self.Output, P.Output, Q.Output, R.Output) -> T) -> Publishers.CZMap<Publishers.Zip4<Self, P, Q, R>, T> where P : Publisher, Q : Publisher, R : Publisher, Self.Failure == P.Failure, P.Failure == Q.Failure, Q.Failure == R.Failure {
        return Publishers.CZMap(inner: self.zip(publisher1, publisher2, publisher3, transform), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes a specific element, indicated by its index in the sequence of published elements.
    ///
    /// Use ``Publisher/output(at:)`` when you need to republish a specific element specified by its position in the stream. If the publisher completes normally or with an error before publishing the specified element, then the publisher doesn’t produce any elements.
    ///
    /// In the example below, the array publisher emits the fifth element in the sequence of published elements:
    ///
    ///     let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ///     numbers.publisher
    ///         .output(at: 5)
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "6"
    ///
    /// - Parameter index: The index that indicates the element to publish.
    /// - Returns: A publisher that publishes a specific indexed element.
    public func czOutput(at index: Int) -> Publishers.CZOutput<Self> {
        return Publishers.CZOutput(inner: self.output(at: index), uuid: self.generateUUID())
    }

    /// Publishes elements specified by their range in the sequence of published elements.
    ///
    /// Use ``Publisher/output(in:)`` to republish a range indices you specify in the published stream. After publishing all elements, the publisher finishes normally. If the publisher completes normally or with an error before producing all the elements in the range, it doesn’t publish the remaining elements.
    ///
    /// In the example below, an array publisher emits the subset of elements at the indices in the specified range:
    ///
    ///     let numbers = [1, 1, 2, 2, 2, 3, 4, 5, 6]
    ///     numbers.publisher
    ///         .output(in: (3...5))
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "2 2 3"
    ///
    /// - Parameter range: A range that indicates which elements to publish.
    /// - Returns: A publisher that publishes elements specified by a range.
    public func czOutput<R>(in range: R) -> Publishers.CZOutput<Self> where R : RangeExpression, R.Bound == Int {
        return Publishers.CZOutput(inner: self.output(in: range), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Handles errors from an upstream publisher by replacing it with another publisher.
    ///
    /// Use `catch()` to replace an error from an upstream publisher with a new publisher.
    ///
    /// In the example below, the `catch()` operator handles the `SimpleError` thrown by the upstream publisher by replacing the error with a `Just` publisher. This continues the stream by publishing a single value and completing normally.
    ///
    ///     struct SimpleError: Error {}
    ///     let numbers = [5, 4, 3, 2, 1, 0, 9, 8, 7, 6]
    ///     cancellable = numbers.publisher
    ///         .tryLast(where: {
    ///             guard $0 != 0 else {throw SimpleError()}
    ///             return true
    ///         })
    ///         .catch({ (error) in
    ///             Just(-1)
    ///         })
    ///         .sink { print("\($0)") }
    ///         // Prints: -1
    ///
    /// Backpressure note: This publisher passes through `request` and `cancel` to the upstream. After receiving an error, the publisher sends sends any unfulfilled demand to the new `Publisher`.
    /// SeeAlso: `replaceError`
    /// - Parameter handler: A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
    /// - Returns: A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
    public func czCatch<P>(_ handler: @escaping (Self.Failure) -> P) -> Publishers.CZCatch<Self, P> where P : Publisher, Self.Output == P.Output {
        return Publishers.CZCatch(inner: self.catch(handler), uuid: self.generateUUID())
    }

    /// Handles errors from an upstream publisher by either replacing it with another publisher or throwing a new error.
    ///
    /// Use ``Publisher/tryCatch(_:)`` to decide how to handle from an upstream publisher by either replacing the publisher with a new publisher, or throwing a new error.
    ///
    /// In the example below, an array publisher emits values that a ``Publisher/tryMap(_:)`` operator evaluates to ensure the values are greater than zero. If the values aren’t greater than zero, the operator throws an error to the downstream subscriber to let it know there was a problem. The subscriber, ``Publisher/tryCatch(_:)``, replaces the error with a new publisher using ``Just`` to publish a final value before the stream ends normally.
    ///
    ///     enum SimpleError: Error { case error }
    ///     var numbers = [5, 4, 3, 2, 1, -1, 7, 8, 9, 10]
    ///
    ///     cancellable = numbers.publisher
    ///        .tryMap { v in
    ///             if v > 0 {
    ///                 return v
    ///             } else {
    ///                 throw SimpleError.error
    ///             }
    ///     }
    ///       .tryCatch { error in
    ///           Just(0) // Send a final value before completing normally.
    ///                   // Alternatively, throw a new error to terminate the stream.
    ///     }
    ///       .sink(receiveCompletion: { print ("Completion: \($0).") },
    ///             receiveValue: { print ("Received \($0).") }
    ///       )
    ///     //    Received 5.
    ///     //    Received 4.
    ///     //    Received 3.
    ///     //    Received 2.
    ///     //    Received 1.
    ///     //    Received 0.
    ///     //    Completion: finished.
    ///
    /// - Parameter handler: A throwing closure that accepts the upstream failure as input. This closure can either replace the upstream publisher with a new one, or throw a new error to the downstream subscriber.
    /// - Returns: A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher, or an error.
    public func czTryCatch<P>(_ handler: @escaping (Self.Failure) throws -> P) -> Publishers.CZTryCatch<Self, P> where P : Publisher, Self.Output == P.Output {
        return Publishers.CZTryCatch(inner: self.tryCatch(handler), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Transforms all elements from an upstream publisher into a new publisher up to a maximum number of publishers you specify.
    ///
    /// Combine‘s `flatMap(maxPublishers:_:)` operator performs a similar function to the <doc://com.apple.documentation/documentation/Swift/Sequence/2905332-flatmap> operator in the Swift standard library, but turns the elements from one kind of publisher into a new publisher that is sent to subscribers. Use `flatMap(maxPublishers:_:)` when you want to create a new series of events for downstream subscribers based on the received value. The closure creates the new ``Publisher`` based on the received value. The new ``Publisher`` can emit more than one event, and successful completion of the new ``Publisher`` does not complete the overall stream. Failure of the new ``Publisher`` causes the overall stream to fail.
    ///
    /// In the example below, a ``PassthroughSubject`` publishes `WeatherStation` elements. The `flatMap(maxPublishers:_:)` receives each element, creates a <doc://com.apple.documentation/documentation/Foundation/URL> from it, and produces a new <doc://com.apple.documentation/documentation/Foundation/URLSession/DataTaskPublisher>, which will publish the data loaded from that <doc://com.apple.documentation/documentation/Foundation/URL>.
    ///
    ///     public struct WeatherStation {
    ///         public let stationID: String
    ///     }
    ///
    ///     var weatherPublisher = PassthroughSubject<WeatherStation, URLError>()
    ///
    ///     cancellable = weatherPublisher.flatMap { station -> URLSession.DataTaskPublisher in
    ///         let url = URL(string:"https://weatherapi.example.com/stations/\(station.stationID)/observations/latest")!
    ///         return URLSession.shared.dataTaskPublisher(for: url)
    ///     }
    ///     .sink(
    ///         receiveCompletion: { completion in
    ///             // Handle publisher completion (normal or error).
    ///         },
    ///         receiveValue: {
    ///             // Process the received data.
    ///         }
    ///      )
    ///
    ///     weatherPublisher.send(WeatherStation(stationID: "KSFO")) // San Francisco, CA
    ///     weatherPublisher.send(WeatherStation(stationID: "EGLC")) // London, UK
    ///     weatherPublisher.send(WeatherStation(stationID: "ZBBB")) // Beijing, CN
    ///
    /// - Parameters:
    ///   - maxPublishers: Specifies the maximum number of concurrent publisher subscriptions, or ``Combine/Subscribers/Demand/unlimited`` if unspecified.
    ///   - transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
    /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element’s type.
    public func czFlatMap<T, P>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Self.Output) -> P) -> Publishers.CZFlatMap<P, Self> where T == P.Output, P : Publisher, Self.Failure == P.Failure {
        return Publishers.CZFlatMap(inner: self.flatMap(maxPublishers: maxPublishers, transform), uuid: self.generateUUID())
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Publisher where Self.Failure == Never {

    /// Transforms all elements from an upstream publisher into a new publisher up to a maximum number of publishers you specify.
    ///
    /// - Parameters:
    ///   - maxPublishers: Specifies the maximum number of concurrent publisher subscriptions, or ``Combine/Subscribers/Demand/unlimited`` if unspecified.
    ///   - transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
    /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element’s type.
    public func czFlatMap<P>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Self.Output) -> P) -> Publishers.CZFlatMap<P, Publishers.SetFailureType<Self, P.Failure>> where P : Publisher {
        return Publishers.CZFlatMap(inner: self.flatMap(maxPublishers: maxPublishers, transform), uuid: self.generateUUID())
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Publisher where Self.Failure == Never {

    /// Transforms all elements from an upstream publisher into a new publisher up to a maximum number of publishers you specify.
    ///
    /// - Parameters:
    ///   - maxPublishers: Specifies the maximum number of concurrent publisher subscriptions, or ``Combine/Subscribers/Demand/unlimited`` if unspecified.
    ///   - transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
    /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element’s type.
    public func czFlatMap<P>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Self.Output) -> P) -> Publishers.CZFlatMap<P, Self> where P : Publisher, P.Failure == Never {
        return Publishers.CZFlatMap(inner: self.flatMap(maxPublishers: maxPublishers, transform), uuid: self.generateUUID())
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Publisher {

    /// Transforms all elements from an upstream publisher into a new publisher up to a maximum number of publishers you specify.
    ///
    /// - Parameters:
    ///   - maxPublishers: Specifies the maximum number of concurrent publisher subscriptions, or ``Combine/Subscribers/Demand/unlimited`` if unspecified.
    ///   - transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
    /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element’s type.
    public func czFlatMap<P>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Self.Output) -> P) -> Publishers.CZFlatMap<Publishers.SetFailureType<P, Self.Failure>, Self> where P : Publisher, P.Failure == Never {
        return Publishers.CZFlatMap(inner: self.flatMap(maxPublishers: maxPublishers, transform), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Delays delivery of all output to the downstream receiver by a specified amount of time on a particular scheduler.
    ///
    /// Use ``Publisher/delay(for:tolerance:scheduler:options:)`` when you need to delay the delivery of elements to a downstream by a specified amount of time.
    ///
    /// In this example, a <doc://com.apple.documentation/documentation/Foundation/Timer> publishes an event every second. The ``Publisher/delay(for:tolerance:scheduler:options:)`` operator holds the delivery of the initial element for 3 seconds (±0.5 seconds), after which each element is delivered to the downstream on the main run loop after the specified delay:
    ///
    ///     let df = DateFormatter()
    ///     df.dateStyle = .none
    ///     df.timeStyle = .long
    ///     cancellable = Timer.publish(every: 1.0, on: .main, in: .default)
    ///         .autoconnect()
    ///         .handleEvents(receiveOutput: { date in
    ///             print ("Sending Timestamp \'\(df.string(from: date))\' to delay()")
    ///         })
    ///         .delay(for: .seconds(3), scheduler: RunLoop.main, options: .none)
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)", terminator: "\n") },
    ///             receiveValue: { value in
    ///                 let now = Date()
    ///                 print ("At \(df.string(from: now)) received  Timestamp \'\(df.string(from: value))\' sent: \(String(format: "%.2f", now.timeIntervalSince(value))) secs ago", terminator: "\n")
    ///             }
    ///         )
    ///
    ///     // Prints:
    ///     //    Sending Timestamp '5:02:33 PM PDT' to delay()
    ///     //    Sending Timestamp '5:02:34 PM PDT' to delay()
    ///     //    Sending Timestamp '5:02:35 PM PDT' to delay()
    ///     //    Sending Timestamp '5:02:36 PM PDT' to delay()
    ///     //    At 5:02:36 PM PDT received  Timestamp '5:02:33 PM PDT' sent: 3.00 secs ago
    ///     //    Sending Timestamp '5:02:37 PM PDT' to delay()
    ///     //    At 5:02:37 PM PDT received  Timestamp '5:02:34 PM PDT' sent: 3.00 secs ago
    ///     //    Sending Timestamp '5:02:38 PM PDT' to delay()
    ///     //    At 5:02:38 PM PDT received  Timestamp '5:02:35 PM PDT' sent: 3.00 secs ago
    ///
    /// The delay affects the delivery of elements and completion, but not of the original subscription.
    ///
    /// - Parameters:
    ///   - interval: The amount of time to delay.
    ///   - tolerance: The allowed tolerance in delivering delayed events. The `Delay` publisher may deliver elements this much sooner or later than the interval specifies.
    ///   - scheduler: The scheduler to deliver the delayed events.
    ///   - options: Options relevant to the scheduler’s behavior.
    /// - Returns: A publisher that delays delivery of elements and completion to the downstream receiver.
    public func czDelay<S>(for interval: S.SchedulerTimeType.Stride, tolerance: S.SchedulerTimeType.Stride? = nil, scheduler: S, options: S.SchedulerOptions? = nil) -> Publishers.CZDelay<Self, S> where S : Scheduler {
        return Publishers.CZDelay(inner: self.delay(for: interval, tolerance: tolerance, scheduler: scheduler, options: options), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Omits the specified number of elements before republishing subsequent elements.
    ///
    /// Use ``Publisher/dropFirst(_:)`` when you want to drop the first `n` elements from the upstream publisher, and republish the remaining elements.
    ///
    /// The example below drops the first five elements from the stream:
    ///
    ///     let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ///     cancellable = numbers.publisher
    ///         .dropFirst(5)
    ///         .sink { print("\($0)", terminator: " ") }
    ///
    ///     // Prints: "6 7 8 9 10 "
    ///
    /// - Parameter count: The number of elements to omit. The default is `1`.
    /// - Returns: A publisher that doesn’t republish the first `count` elements.
    public func czDropFirst(_ count: Int = 1) -> Publishers.CZDrop<Self> {
        return Publishers.CZDrop(inner: self.dropFirst(count), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Wraps this publisher with a type eraser.
    ///
    /// Use ``Publisher/eraseToAnyPublisher()`` to expose an instance of ``AnyPublisher`` to the downstream subscriber, rather than this publisher’s actual type.
    /// This form of _type erasure_ preserves abstraction across API boundaries, such as different modules.
    /// When you expose your publishers as the ``AnyPublisher`` type, you can change the underlying implementation over time without affecting existing clients.
    ///
    /// The following example shows two types that each have a `publisher` property. `TypeWithSubject` exposes this property as its actual type, ``PassthroughSubject``, while `TypeWithErasedSubject` uses ``Publisher/eraseToAnyPublisher()`` to expose it as an ``AnyPublisher``. As seen in the output, a caller from another module can access `TypeWithSubject.publisher` as its native type. This means you can’t change your publisher to a different type without breaking the caller. By comparison, `TypeWithErasedSubject.publisher` appears to callers as an ``AnyPublisher``, so you can change the underlying publisher type at will.
    ///
    ///     public class TypeWithSubject {
    ///         public let publisher: some Publisher = PassthroughSubject<Int,Never>()
    ///     }
    ///     public class TypeWithErasedSubject {
    ///         public let publisher: some Publisher = PassthroughSubject<Int,Never>()
    ///             .eraseToAnyPublisher()
    ///     }
    ///
    ///     // In another module:
    ///     let nonErased = TypeWithSubject()
    ///     if let subject = nonErased.publisher as? PassthroughSubject<Int,Never> {
    ///         print("Successfully cast nonErased.publisher.")
    ///     }
    ///     let erased = TypeWithErasedSubject()
    ///     if let subject = erased.publisher as? PassthroughSubject<Int,Never> {
    ///         print("Successfully cast erased.publisher.")
    ///     }
    ///
    ///     // Prints "Successfully cast nonErased.publisher."
    ///
    /// - Returns: An ``AnyPublisher`` wrapping this publisher.
    public func czEraseToAnyPublisher() -> CZAnyPublisher<Self.Output, Self.Failure> {
        return CZAnyPublisher(inner: self.eraseToAnyPublisher(), uuid: self.generateUUID())
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Publishes the first element of a stream, then finishes.
    ///
    /// Use ``Publisher/first()`` to publish just the first element from an upstream publisher, then finish normally. The ``Publisher/first()`` operator requests ``Subscribers/Demand/unlimited`` from its upstream as soon as downstream requests at least one element. If the upstream completes before ``Publisher/first()`` receives any elements, it completes without emitting any values.
    ///
    /// In this example, the ``Publisher/first()`` publisher republishes the first element received from the sequence publisher, `-10`, then finishes normally.
    ///
    ///     let numbers = (-10...10)
    ///     cancellable = numbers.publisher
    ///         .first()
    ///         .sink { print("\($0)") }
    ///
    ///     // Print: "-10"
    ///
    /// - Returns: A publisher that only publishes the first element of a stream.
    public func czFirst() -> Publishers.CZFirst<Self> {
        return Publishers.CZFirst(inner: self.first(), uuid: self.generateUUID())
    }

    /// Publishes the first element of a stream to satisfy a predicate closure, then finishes normally.
    ///
    /// Use ``Publisher/first(where:)`` to republish only the first element of a stream that satisfies a closure you specify. The publisher ignores all elements after the first element that satisfies the closure and finishes normally.
    /// If this publisher doesn’t receive any elements, it finishes without publishing.
    ///
    /// In the example below, the provided closure causes the ``Publishers/FirstWhere`` publisher to republish the first received element that’s greater than `0`, then finishes normally.
    ///
    ///     let numbers = (-10...10)
    ///     cancellable = numbers.publisher
    ///         .first { $0 > 0 }
    ///         .sink { print("\($0)") }
    ///
    ///     // Prints: "1"
    ///
    /// - Parameter predicate: A closure that takes an element as a parameter and returns a Boolean value that indicates whether to publish the element.
    /// - Returns: A publisher that only publishes the first element of a stream that satisfies the predicate.
    public func czFirst(where predicate: @escaping (Self.Output) -> Bool) -> Publishers.CZFirstWhere<Self> {
        return Publishers.CZFirstWhere(inner: self.first(where: predicate), uuid: self.generateUUID())
    }

    /// Publishes the first element of a stream to satisfy a throwing predicate closure, then finishes normally.
    ///
    /// Use ``Publisher/tryFirst(where:)`` when you need to republish only the first element of a stream that satisfies an error-throwing closure you specify.
    /// The publisher ignores all elements after the first. If this publisher doesn’t receive any elements, it finishes without publishing. If the predicate closure throws an error, the publisher fails.
    ///
    /// In the example below, a range publisher emits the first element in the range then finishes normally:
    ///
    ///     let numberRange: ClosedRange<Int> = (-1...50)
    ///     numberRange.publisher
    ///         .tryFirst {
    ///             guard $0 < 99 else {throw RangeError()}
    ///             return true
    ///         }
    ///         .sink(
    ///             receiveCompletion: { print ("completion: \($0)", terminator: " ") },
    ///             receiveValue: { print ("\($0)", terminator: " ") }
    ///          )
    ///
    ///     // Prints: "-1 completion: finished"
    ///     // If instead the number range were ClosedRange<Int> = (100...200), the tryFirst operator would terminate publishing with a RangeError.
    ///
    /// - Parameter predicate: A closure that takes an element as a parameter and returns a Boolean value that indicates whether to publish the element.
    /// - Returns: A publisher that only publishes the first element of a stream that satisfies the predicate.
    public func czTryFirst(where predicate: @escaping (Self.Output) throws -> Bool) -> Publishers.CZTryFirstWhere<Self> {
        return Publishers.CZTryFirstWhere(inner: self.tryFirst(where: predicate), uuid: self.generateUUID())
    }
}
