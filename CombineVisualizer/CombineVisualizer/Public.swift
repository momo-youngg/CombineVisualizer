//
//  Public.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/04.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that uses a subject to deliver elements to multiple subscribers.
    ///
    /// Use a multicast publisher when you have multiple downstream subscribers, but you want upstream publishers to only process one ``Subscriber/receive(_:)`` call per event.
    final public class Multicast<Upstream, SubjectType> : ConnectablePublisher where Upstream : Publisher, SubjectType : Subject, Upstream.Failure == SubjectType.Failure, Upstream.Output == SubjectType.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives its elements.
        final public let upstream: Upstream

        /// A closure that returns a subject each time a subscriber attaches to the multicast publisher.
        final public let createSubject: () -> SubjectType

        /// Creates a multicast publisher that applies a closure to create a subject that delivers elements to subscribers.
        ///
        /// - Parameter createSubject: A closure that returns a ``Subject`` each time a subscriber attaches to the multicast publisher.
        public init(upstream: Upstream, createSubject: @escaping () -> SubjectType)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        final public func receive<S>(subscriber: S) where S : Subscriber, SubjectType.Failure == S.Failure, SubjectType.Output == S.Input

        /// Connects to the publisher, allowing it to produce elements, and returns an instance with which to cancel publishing.
        ///
        /// - Returns: A ``Cancellable`` instance that you use to cancel publishing.
        final public func connect() -> Cancellable
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that receives elements from an upstream publisher on a specific scheduler.
    public struct SubscribeOn<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The scheduler the publisher should use to receive elements.
        public let scheduler: Context

        /// Scheduler options that customize the delivery of elements.
        public let options: Context.SchedulerOptions?

        /// Creates a publisher that receives elements from an upstream publisher on a specific scheduler.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - scheduler: The scheduler the publisher should use to receive elements.
        ///   - options: Scheduler options that customize the delivery of elements.
        public init(upstream: Upstream, scheduler: Context, options: Context.SchedulerOptions?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that measures and emits the time interval between events received from an upstream publisher.
    public struct MeasureInterval<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces elements of the provided scheduler's time type's stride.
        public typealias Output = Context.SchedulerTimeType.Stride

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The scheduler used for tracking the timing of events.
        public let scheduler: Context

        /// Creates a publisher that measures and emits the time interval between events received from an upstream publisher.
        ///
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - scheduler: A scheduler to use for tracking the timing of events.
        public init(upstream: Upstream, scheduler: Context)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == Context.SchedulerTimeType.Stride
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that omits elements from an upstream publisher until a given closure returns false.
    public struct DropWhile<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that indicates whether to drop the element.
        public let predicate: (Publishers.DropWhile<Upstream>.Output) -> Bool

        /// Creates a publisher that omits elements from an upstream publisher until a given closure returns false.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The closure that indicates whether to drop the element.
        public init(upstream: Upstream, predicate: @escaping (Publishers.DropWhile<Upstream>.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that omits elements from an upstream publisher until a given error-throwing closure returns false.
    public struct TryDropWhile<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The error-throwing closure that indicates whether to drop the element.
        public let predicate: (Publishers.TryDropWhile<Upstream>.Output) throws -> Bool

        /// Creates a publisher that omits elements from an upstream publisher until a given error-throwing closure returns false.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The error-throwing closure that indicates whether to drop the element.
        public init(upstream: Upstream, predicate: @escaping (Publishers.TryDropWhile<Upstream>.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes all elements that match a provided closure.
    public struct Filter<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// A closure that indicates whether to republish an element.
        public let isIncluded: (Upstream.Output) -> Bool

        /// Creates a publisher that republishes all elements that match a provided closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - isIncluded: A closure that indicates whether to republish an element.
        public init(upstream: Upstream, isIncluded: @escaping (Upstream.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that republishes all elements that match a provided error-throwing closure.
    public struct TryFilter<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// An error-throwing closure that indicates whether this filter should republish an element.
        public let isIncluded: (Upstream.Output) throws -> Bool

        /// Creates a publisher that republishes all elements that match a provided error-throwing closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - isIncluded: An error-throwing closure that indicates whether this filter should republish an element.
        public init(upstream: Upstream, isIncluded: @escaping (Upstream.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that raises a debugger signal when a provided closure needs to stop the process in the debugger.
    ///
    /// When any of the provided closures returns `true`, this publisher raises the `SIGTRAP` signal to stop the process in the debugger.
    /// Otherwise, this publisher passes through values and completions as-is.
    public struct Breakpoint<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// A closure that executes when the publisher receives a subscription, and can raise a debugger signal by returning a true Boolean value.
        public let receiveSubscription: ((Subscription) -> Bool)?

        /// A closure that executes when the publisher receives output from the upstream publisher, and can raise a debugger signal by returning a true Boolean value.
        public let receiveOutput: ((Upstream.Output) -> Bool)?

        /// A closure that executes when the publisher receives completion, and can raise a debugger signal by returning a true Boolean value.
        public let receiveCompletion: ((Subscribers.Completion<Publishers.Breakpoint<Upstream>.Failure>) -> Bool)?

        /// Creates a breakpoint publisher with the provided upstream publisher and breakpoint-raising closures.
        ///
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - receiveSubscription: A closure that executes when the publisher receives a subscription, and can raise a debugger signal by returning a true Boolean value.
        ///   - receiveOutput: A closure that executes when the publisher receives output from the upstream publisher, and can raise a debugger signal by returning a true Boolean value.
        ///   - receiveCompletion: A closure that executes when the publisher receives completion, and can raise a debugger signal by returning a true Boolean value.
        public init(upstream: Upstream, receiveSubscription: ((Subscription) -> Bool)? = nil, receiveOutput: ((Upstream.Output) -> Bool)? = nil, receiveCompletion: ((Subscribers.Completion<Publishers.Breakpoint<Upstream>.Failure>) -> Bool)? = nil)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes a single Boolean value that indicates whether all received elements pass a given predicate.
    public struct AllSatisfy<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces Boolean elements.
        public typealias Output = Bool

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// A closure that evaluates each received element.
        ///
        /// Return `true` to continue, or `false` to cancel the upstream and finish.
        public let predicate: (Upstream.Output) -> Bool

        /// Creates a publisher that publishes a single Boolean value that indicates whether all received elements pass a given predicate.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: A closure that evaluates each received element.
        public init(upstream: Upstream, predicate: @escaping (Upstream.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == Bool
    }

    /// A publisher that publishes a single Boolean value that indicates whether all received elements pass a given error-throwing predicate.
    public struct TryAllSatisfy<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces Boolean elements.
        public typealias Output = Bool

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// A closure that evaluates each received element.
        ///
        /// Return `true` to continue, or `false` to cancel the upstream and complete. The closure may throw, in which case the publisher cancels the upstream publisher and fails with the thrown error.
        public let predicate: (Upstream.Output) throws -> Bool

        /// Returns a publisher that publishes a single Boolean value that indicates whether all received elements pass a given error-throwing predicate.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: A closure that evaluates each received element.
        public init(upstream: Upstream, predicate: @escaping (Upstream.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Error, S.Input == Bool
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes only elements that don’t match the previous element.
    public struct RemoveDuplicates<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The predicate closure used to evaluate whether two elements are duplicates.
        public let predicate: (Publishers.RemoveDuplicates<Upstream>.Output, Publishers.RemoveDuplicates<Upstream>.Output) -> Bool

        /// Creates a publisher that publishes only elements that don’t match the previous element, as evaluated by a provided closure.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        /// - Parameter predicate: A closure to evaluate whether two elements are equivalent, for purposes of filtering. Return `true` from this closure to indicate that the second element is a duplicate of the first.
        public init(upstream: Upstream, predicate: @escaping (Publishers.RemoveDuplicates<Upstream>.Output, Publishers.RemoveDuplicates<Upstream>.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that publishes only elements that don’t match the previous element, as evaluated by a provided error-throwing closure.
    public struct TryRemoveDuplicates<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// Use `Never` if this `Publisher` does not publish errors.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// An error-throwing closure to evaluate whether two elements are equivalent, for purposes of filtering.
        public let predicate: (Publishers.TryRemoveDuplicates<Upstream>.Output, Publishers.TryRemoveDuplicates<Upstream>.Output) throws -> Bool

        /// Creates a publisher that publishes only elements that don’t match the previous element, as evaluated by a provided error-throwing closure.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        /// - Parameter predicate: An error-throwing closure to evaluate whether two elements are equivalent, for purposes of filtering. Return `true` from this closure to indicate that the second element is a duplicate of the first. If this closure throws an error, the publisher terminates with the thrown error.
        public init(upstream: Upstream, predicate: @escaping (Publishers.TryRemoveDuplicates<Upstream>.Output, Publishers.TryRemoveDuplicates<Upstream>.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that decodes elements received from an upstream publisher, using a given decoder.
    public struct Decode<Upstream, Output, Coder> : Publisher where Upstream : Publisher, Output : Decodable, Coder : TopLevelDecoder, Upstream.Output == Coder.Input {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        public let upstream: Upstream

        /// Creates a publisher that decodes elements received from an upstream publisher, using a given decoder.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - decoder: The decoder that decodes elements received from the upstream publisher.
        public init(upstream: Upstream, decoder: Coder)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Error
    }

    /// A publisher that encodes elements received from an upstream publisher, using a given encoder.
    public struct Encode<Upstream, Coder> : Publisher where Upstream : Publisher, Coder : TopLevelEncoder, Upstream.Output : Encodable {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses the encoder's output type.
        public typealias Output = Coder.Output

        public let upstream: Upstream

        /// Creates a publisher that decodes elements received from an upstream publisher, using a given decoder.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - encoder: The encoder that decodes elements received from the upstream publisher.
        public init(upstream: Upstream, encoder: Coder)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Coder.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that emits a Boolean value when it receives a specific element from its upstream publisher.
    public struct Contains<Upstream> : Publisher where Upstream : Publisher, Upstream.Output : Equatable {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces Boolean elements.
        public typealias Output = Bool

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The element to match in the upstream publisher.
        public let output: Upstream.Output

        /// Creates a publisher that emits a Boolean value when it receives a specific element from its upstream publisher.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - output: The element to match in the upstream publisher.
        public init(upstream: Upstream, output: Upstream.Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == Bool
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that receives and combines the latest elements from two publishers.
    public struct CombineLatest<A, B> : Publisher where A : Publisher, B : Publisher, A.Failure == B.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces two-element tuples of the upstream publishers' output types.
        public typealias Output = (A.Output, B.Output)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the failure type shared by its upstream publishers.
        public typealias Failure = A.Failure

        public let a: A

        public let b: B

        /// Creates a publisher that receives and combines the latest elements from two publishers.
        /// - Parameters:
        ///   - a: The first upstream publisher.
        ///   - b: The second upstream publisher.
        public init(_ a: A, _ b: B)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, B.Failure == S.Failure, S.Input == (A.Output, B.Output)
    }

    /// A publisher that receives and combines the latest elements from three publishers.
    public struct CombineLatest3<A, B, C> : Publisher where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, B.Failure == C.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces three-element tuples of the upstream publishers' output types.
        public typealias Output = (A.Output, B.Output, C.Output)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the failure type shared by its upstream publishers.
        public typealias Failure = A.Failure

        public let a: A

        public let b: B

        public let c: C

        public init(_ a: A, _ b: B, _ c: C)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, C.Failure == S.Failure, S.Input == (A.Output, B.Output, C.Output)
    }

    /// A publisher that receives and combines the latest elements from four publishers.
    public struct CombineLatest4<A, B, C, D> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces four-element tuples of the upstream publishers' output types.
        public typealias Output = (A.Output, B.Output, C.Output, D.Output)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the failure type shared by its upstream publishers.
        public typealias Failure = A.Failure

        public let a: A

        public let b: B

        public let c: C

        public let d: D

        public init(_ a: A, _ b: B, _ c: C, _ d: D)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, D.Failure == S.Failure, S.Input == (A.Output, B.Output, C.Output, D.Output)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that automatically connects to an upstream connectable publisher.
    ///
    /// This publisher calls ``ConnectablePublisher/connect()`` on the upstream ``ConnectablePublisher`` when first attached to by a subscriber.
    public class Autoconnect<Upstream> : Publisher where Upstream : ConnectablePublisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstram publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        final public let upstream: Upstream

        /// Creates a publisher that automatically connects to an upstream connectable publisher.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that prints log messages for all publishing events, optionally prefixed with a given string.
    ///
    /// This publisher prints log messages when receiving the following events:
    ///
    /// - subscription
    /// - value
    /// - normal completion
    /// - failure
    /// - cancellation
    public struct Print<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// A string with which to prefix all log messages.
        public let prefix: String

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        public let stream: TextOutputStream?

        /// Creates a publisher that prints log messages for all publishing events.
        ///
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - prefix: A string with which to prefix all log messages.
        public init(upstream: Upstream, prefix: String, to stream: TextOutputStream? = nil)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes elements while a predicate closure indicates publishing should continue.
    public struct PrefixWhile<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that determines whether publishing should continue.
        public let predicate: (Publishers.PrefixWhile<Upstream>.Output) -> Bool

        /// Creates a publisher that republishes elements while a predicate closure indicates publishing should continue.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The closure that determines whether publishing should continue.
        public init(upstream: Upstream, predicate: @escaping (Publishers.PrefixWhile<Upstream>.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that republishes elements while an error-throwing predicate closure indicates publishing should continue.
    public struct TryPrefixWhile<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The error-throwing closure that determines whether publishing should continue.
        public let predicate: (Publishers.TryPrefixWhile<Upstream>.Output) throws -> Bool

        /// Creates a publisher that republishes elements while an error-throwing predicate closure indicates publishing should continue.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The error-throwing closure that determines whether publishing should continue.
        public init(upstream: Upstream, predicate: @escaping (Publishers.TryPrefixWhile<Upstream>.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that appears to send a specified failure type.
    ///
    /// The publisher can't actually fail with the specified type and finishes normally. Use this publisher type when you need to match the error types for two mismatched publishers.
    public struct SetFailureType<Upstream, Failure> : Publisher where Upstream : Publisher, Failure : Error, Upstream.Failure == Never {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that appears to send a specified failure type.
        ///
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Failure == S.Failure, S : Subscriber, Upstream.Output == S.Input

        public func setFailureType<E>(to failure: E.Type) -> Publishers.SetFailureType<Upstream, E> where E : Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that emits a Boolean value upon receiving an element that satisfies the predicate closure.
    public struct ContainsWhere<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces Boolean elements.
        public typealias Output = Bool

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that determines whether the publisher should consider an element as a match.
        public let predicate: (Upstream.Output) -> Bool

        /// Creates a publisher that emits a Boolean value upon receiving an element that satisfies the predicate closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The closure that determines whether the publisher should consider an element as a match.
        public init(upstream: Upstream, predicate: @escaping (Upstream.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == Bool
    }

    /// A publisher that emits a Boolean value upon receiving an element that satisfies the throwing predicate closure.
    public struct TryContainsWhere<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces Boolean elements.
        public typealias Output = Bool

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The error-throwing closure that determines whether this publisher should emit a Boolean true element.
        public let predicate: (Upstream.Output) throws -> Bool

        /// Creates a publisher that emits a Boolean value upon receiving an element that satisfies the throwing predicate closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The error-throwing closure that determines whether this publisher should emit a Boolean true element.
        public init(upstream: Upstream, predicate: @escaping (Upstream.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Error, S.Input == Bool
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that provides explicit connectability to another publisher.
    ///
    /// ``Publishers/MakeConnectable`` is a ``ConnectablePublisher``, which allows you to perform configuration before publishing any elements. Call ``ConnectablePublisher/connect()`` on this publisher when you want to attach to its upstream publisher and start producing elements.
    ///
    /// Use the ``Publisher/makeConnectable()`` operator to wrap an upstream publisher with an instance of this publisher.
    public struct MakeConnectable<Upstream> : ConnectablePublisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// Creates a connectable publisher, attached to the provide upstream publisher.
        ///
        /// - Parameter upstream: The publisher from which to receive elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input

        /// Connects to the publisher, allowing it to produce elements, and returns an instance with which to cancel publishing.
        ///
        /// - Returns: A ``Cancellable`` instance that you use to cancel publishing.
        public func connect() -> Cancellable
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A strategy for collecting received elements.
    public enum TimeGroupingStrategy<Context> where Context : Scheduler {

        /// A grouping that collects and periodically publishes items.
        case byTime(Context, Context.SchedulerTimeType.Stride)

        /// A grouping that collects and publishes items periodically or when a buffer reaches a maximum size.
        case byTimeOrCount(Context, Context.SchedulerTimeType.Stride, Int)
    }

    /// A publisher that buffers and periodically publishes its items.
    public struct CollectByTime<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher publishes arrays of its upstream publisher's output type.
        public typealias Output = [Upstream.Output]

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream

        /// The strategy with which to collect and publish elements.
        public let strategy: Publishers.TimeGroupingStrategy<Context>

        /// Scheduler options to use for the strategy.
        public let options: Context.SchedulerOptions?

        /// Creates a publisher that buffers and periodically publishes its items.
        /// - Parameters:
        ///   - upstream: The publisher that this publisher receives elements from.
        ///   - strategy: The strategy with which to collect and publish elements.
        ///   - options: `Scheduler` options to use for the strategy.
        public init(upstream: Upstream, strategy: Publishers.TimeGroupingStrategy<Context>, options: Context.SchedulerOptions?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == [Upstream.Output]
    }

    /// A publisher that buffers items.
    public struct Collect<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher publishes arrays of its upstream publisher's output type.
        public typealias Output = [Upstream.Output]

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream

        /// Creates a publisher that buffers items.
        /// - Parameter upstream: The publisher that this publisher receives elements from.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == [Upstream.Output]
    }

    /// A publisher that buffers a maximum number of items.
    public struct CollectByCount<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher publishes arrays of its upstream publisher's output type.
        public typealias Output = [Upstream.Output]

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream

        /// The maximum number of received elements to buffer before publishing.
        public let count: Int

        /// Creates a publisher that buffers a maximum number of items.
        /// - Parameters:
        ///   - upstream: The publisher that this publisher receives elements from.
        ///   - count: The maximum number of received elements to buffer before publishing.
        public init(upstream: Upstream, count: Int)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == [Upstream.Output]
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that delivers elements to its downstream subscriber on a specific scheduler.
    public struct ReceiveOn<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The scheduler the publisher uses to deliver elements.
        public let scheduler: Context

        /// Scheduler options used to customize element delivery.
        public let options: Context.SchedulerOptions?

        /// Creates a publisher that delivers elements to its downstream subscriber on a specific scheduler.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - scheduler: The scheduler the publisher uses to deliver elements.
        ///   - options: Scheduler options used to customize element delivery.
        public init(upstream: Upstream, scheduler: Context, options: Context.SchedulerOptions?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes the value of a key path.
    public struct MapKeyPath<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The key path of a property to publish.
        public let keyPath: KeyPath<Upstream.Output, Output>

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, Upstream.Failure == S.Failure
    }

    /// A publisher that publishes the values of two key paths as a tuple.
    public struct MapKeyPath2<Upstream, Output0, Output1> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces two-element tuples, where each menber's type matches the type of the corresponding key path's property.
        public typealias Output = (Output0, Output1)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The key path of a property to publish.
        public let keyPath0: KeyPath<Upstream.Output, Output0>

        /// The key path of a second property to publish.
        public let keyPath1: KeyPath<Upstream.Output, Output1>

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == (Output0, Output1)
    }

    /// A publisher that publishes the values of three key paths as a tuple.
    public struct MapKeyPath3<Upstream, Output0, Output1, Output2> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces three-element tuples, where each menber's type matches the type of the corresponding key path's property.
        public typealias Output = (Output0, Output1, Output2)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The key path of a property to publish.
        public let keyPath0: KeyPath<Upstream.Output, Output0>

        /// The key path of a second property to publish.
        public let keyPath1: KeyPath<Upstream.Output, Output1>

        /// The key path of a third property to publish.
        public let keyPath2: KeyPath<Upstream.Output, Output2>

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == (Output0, Output1, Output2)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes elements until another publisher emits an element.
    public struct PrefixUntilOutput<Upstream, Other> : Publisher where Upstream : Publisher, Other : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Another publisher, whose first output causes this publisher to finish.
        public let other: Other

        /// Creates a publisher that republishes elements until another publisher emits an element.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - other: Another publisher, the first output from which causes this publisher to finish.
        public init(upstream: Upstream, other: Other)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that applies a closure to all received elements and produces an accumulated value when the upstream publisher finishes.
    public struct Reduce<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The initial value provided on the first invocation of the closure.
        public let initial: Output

        /// A closure that takes the previously-accumulated value and the next element from the upstream publisher to produce a new value.
        public let nextPartialResult: (Output, Upstream.Output) -> Output

        /// Creates a publisher that applies a closure to all received elements and produces an accumulated value when the upstream publisher finishes.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - initial: The initial value provided on the first invocation of the closure.
        ///   - nextPartialResult: A closure that takes the previously-accumulated value and the next element from the upstream publisher to produce a new value.
        public init(upstream: Upstream, initial: Output, nextPartialResult: @escaping (Output, Upstream.Output) -> Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, Upstream.Failure == S.Failure
    }

    /// A publisher that applies an error-throwing closure to all received elements and produces an accumulated value when the upstream publisher finishes.
    public struct TryReduce<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The initial value provided on the first-use of the closure.
        public let initial: Output

        /// An error-throwing closure that takes the previously-accumulated value and the next element from the upstream to produce a new value.
        ///
        /// If this closure throws an error, the publisher fails and passes the error to its subscriber.
        public let nextPartialResult: (Output, Upstream.Output) throws -> Output

        /// Creates a publisher that applies an error-throwing closure to all received elements and produces an accumulated value when the upstream publisher finishes.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - initial: The initial value provided on the first-use of the closure.
        ///   - nextPartialResult: An error-throwing closure that takes the previously-accumulated value and the next element from the upstream to produce a new value. If this closure throws an error, the publisher fails and passes the error to its subscriber.
        public init(upstream: Upstream, initial: Output, nextPartialResult: @escaping (Output, Upstream.Output) throws -> Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes all non-nil results of calling a closure with each received element.
    public struct CompactMap<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// A closure that receives values from the upstream publisher and returns optional values.
        public let transform: (Upstream.Output) -> Output?

        /// Creates a publisher that republishes all non-`nil` results of calling a closure with each received element.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - transform: A closure that receives values from the upstream publisher and returns optional values.
        public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, Upstream.Failure == S.Failure
    }

    /// A publisher that republishes all non-nil results of calling an error-throwing closure with each received element.
    public struct TryCompactMap<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// An error-throwing closure that receives values from the upstream publisher and returns optional values.
        ///
        /// If this closure throws an error, the publisher fails.
        public let transform: (Upstream.Output) throws -> Output?

        public init(upstream: Upstream, transform: @escaping (Upstream.Output) throws -> Output?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher created by applying the merge function to two upstream publishers.
    public struct Merge<A, B> : Publisher where A : Publisher, B : Publisher, A.Failure == B.Failure, A.Output == B.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = A.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to merge.
        public let a: A

        /// A second publisher to merge.
        public let b: B

        /// Creates a publisher created by applying the merge function to two upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to merge
        ///   - b: A second publisher to merge.
        public init(_ a: A, _ b: B)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, B.Failure == S.Failure, B.Output == S.Input

        public func merge<P>(with other: P) -> Publishers.Merge3<A, B, P> where P : Publisher, B.Failure == P.Failure, B.Output == P.Output

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.Merge4<A, B, Z, Y> where Z : Publisher, Y : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.Merge5<A, B, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output

        public func merge<Z, Y, X, W>(with z: Z, _ y: Y, _ x: X, _ w: W) -> Publishers.Merge6<A, B, Z, Y, X, W> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output

        public func merge<Z, Y, X, W, V>(with z: Z, _ y: Y, _ x: X, _ w: W, _ v: V) -> Publishers.Merge7<A, B, Z, Y, X, W, V> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, V : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output, W.Failure == V.Failure, W.Output == V.Output

        public func merge<Z, Y, X, W, V, U>(with z: Z, _ y: Y, _ x: X, _ w: W, _ v: V, _ u: U) -> Publishers.Merge8<A, B, Z, Y, X, W, V, U> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, V : Publisher, U : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output, W.Failure == V.Failure, W.Output == V.Output, V.Failure == U.Failure, V.Output == U.Output
    }

    /// A publisher created by applying the merge function to three upstream publishers.
    public struct Merge3<A, B, C> : Publisher where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = A.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to merge.
        public let a: A

        /// A second publisher to merge.
        public let b: B

        /// A third publisher to merge.
        public let c: C

        /// Creates a publisher created by applying the merge function to three upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to merge
        ///   - b: A second publisher to merge.
        ///   - c: A third publisher to merge.
        public init(_ a: A, _ b: B, _ c: C)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, C.Failure == S.Failure, C.Output == S.Input

        public func merge<P>(with other: P) -> Publishers.Merge4<A, B, C, P> where P : Publisher, C.Failure == P.Failure, C.Output == P.Output

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.Merge5<A, B, C, Z, Y> where Z : Publisher, Y : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.Merge6<A, B, C, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output

        public func merge<Z, Y, X, W>(with z: Z, _ y: Y, _ x: X, _ w: W) -> Publishers.Merge7<A, B, C, Z, Y, X, W> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output

        public func merge<Z, Y, X, W, V>(with z: Z, _ y: Y, _ x: X, _ w: W, _ v: V) -> Publishers.Merge8<A, B, C, Z, Y, X, W, V> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, V : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output, W.Failure == V.Failure, W.Output == V.Output
    }

    /// A publisher created by applying the merge function to four upstream publishers.
    public struct Merge4<A, B, C, D> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = A.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to merge.
        public let a: A

        /// A second publisher to merge.
        public let b: B

        /// A third publisher to merge.
        public let c: C

        /// A fourth publisher to merge.
        public let d: D

        /// Creates a publisher created by applying the merge function to four upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to merge
        ///   - b: A second publisher to merge.
        ///   - c: A third publisher to merge.
        ///   - d: A fourth publisher to merge.
        public init(_ a: A, _ b: B, _ c: C, _ d: D)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, D.Failure == S.Failure, D.Output == S.Input

        public func merge<P>(with other: P) -> Publishers.Merge5<A, B, C, D, P> where P : Publisher, D.Failure == P.Failure, D.Output == P.Output

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.Merge6<A, B, C, D, Z, Y> where Z : Publisher, Y : Publisher, D.Failure == Z.Failure, D.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.Merge7<A, B, C, D, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, D.Failure == Z.Failure, D.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output

        public func merge<Z, Y, X, W>(with z: Z, _ y: Y, _ x: X, _ w: W) -> Publishers.Merge8<A, B, C, D, Z, Y, X, W> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, D.Failure == Z.Failure, D.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output
    }

    /// A publisher created by applying the merge function to five upstream publishers.
    public struct Merge5<A, B, C, D, E> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = A.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to merge.
        public let a: A

        /// A second publisher to merge.
        public let b: B

        /// A third publisher to merge.
        public let c: C

        /// A fourth publisher to merge.
        public let d: D

        /// A fifth publisher to merge.
        public let e: E

        /// Creates a publisher created by applying the merge function to five upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to merge
        ///   - b: A second publisher to merge.
        ///   - c: A third publisher to merge.
        ///   - d: A fourth publisher to merge.
        ///   - e: A fifth publisher to merge.
        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, E.Failure == S.Failure, E.Output == S.Input

        public func merge<P>(with other: P) -> Publishers.Merge6<A, B, C, D, E, P> where P : Publisher, E.Failure == P.Failure, E.Output == P.Output

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.Merge7<A, B, C, D, E, Z, Y> where Z : Publisher, Y : Publisher, E.Failure == Z.Failure, E.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.Merge8<A, B, C, D, E, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, E.Failure == Z.Failure, E.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output
    }

    /// A publisher created by applying the merge function to six upstream publishers.
    public struct Merge6<A, B, C, D, E, F> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = A.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to merge.
        public let a: A

        /// A second publisher to merge.
        public let b: B

        /// A third publisher to merge.
        public let c: C

        /// A fourth publisher to merge.
        public let d: D

        /// A fifth publisher to merge.
        public let e: E

        /// A sixth publisher to merge.
        public let f: F

        /// publisher created by applying the merge function to six upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to merge
        ///   - b: A second publisher to merge.
        ///   - c: A third publisher to merge.
        ///   - d: A fourth publisher to merge.
        ///   - e: A fifth publisher to merge.
        ///   - f: A sixth publisher to merge.
        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, F.Failure == S.Failure, F.Output == S.Input

        public func merge<P>(with other: P) -> Publishers.Merge7<A, B, C, D, E, F, P> where P : Publisher, F.Failure == P.Failure, F.Output == P.Output

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.Merge8<A, B, C, D, E, F, Z, Y> where Z : Publisher, Y : Publisher, F.Failure == Z.Failure, F.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output
    }

    /// A publisher created by applying the merge function to seven upstream publishers.
    public struct Merge7<A, B, C, D, E, F, G> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, G : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output, F.Failure == G.Failure, F.Output == G.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = A.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to merge.
        public let a: A

        /// A second publisher to merge.
        public let b: B

        /// A third publisher to merge.
        public let c: C

        /// A fourth publisher to merge.
        public let d: D

        /// A fifth publisher to merge.
        public let e: E

        /// A sixth publisher to merge.
        public let f: F

        /// An seventh publisher to merge.
        public let g: G

        /// Creates a publisher created by applying the merge function to seven upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to merge
        ///   - b: A second publisher to merge.
        ///   - c: A third publisher to merge.
        ///   - d: A fourth publisher to merge.
        ///   - e: A fifth publisher to merge.
        ///   - f: A sixth publisher to merge.
        ///   - g: An seventh publisher to merge.
        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, G.Failure == S.Failure, G.Output == S.Input

        public func merge<P>(with other: P) -> Publishers.Merge8<A, B, C, D, E, F, G, P> where P : Publisher, G.Failure == P.Failure, G.Output == P.Output
    }

    /// A publisher created by applying the merge function to eight upstream publishers.
    public struct Merge8<A, B, C, D, E, F, G, H> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, G : Publisher, H : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output, F.Failure == G.Failure, F.Output == G.Output, G.Failure == H.Failure, G.Output == H.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = A.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to merge.
        public let a: A

        /// A second publisher to merge.
        public let b: B

        /// A third publisher to merge.
        public let c: C

        /// A fourth publisher to merge.
        public let d: D

        /// A fifth publisher to merge.
        public let e: E

        /// A sixth publisher to merge.
        public let f: F

        /// An seventh publisher to merge.
        public let g: G

        /// A eighth publisher to merge.
        public let h: H

        /// Creates a publisher created by applying the merge function to eight upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to merge
        ///   - b: A second publisher to merge.
        ///   - c: A third publisher to merge.
        ///   - d: A fourth publisher to merge.
        ///   - e: A fifth publisher to merge.
        ///   - f: A sixth publisher to merge.
        ///   - g: An seventh publisher to merge.
        ///   - h: An eighth publisher to merge.
        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, H.Failure == S.Failure, H.Output == S.Input
    }

    /// A publisher created by applying the merge function to an arbitrary number of upstream publishers.
    public struct MergeMany<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publishers' common output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = Upstream.Failure

        /// The array of upstream publishers that this publisher merges together.
        public let publishers: [Upstream]

        /// Creates a publisher created by applying the merge function to an arbitrary number of upstream publishers.
        /// - Parameter upstream: A variadic parameter containing zero or more publishers to merge with this publisher.
        public init(_ upstream: Upstream...)

        /// Creates a publisher created by applying the merge function to a sequence of upstream publishers.
        /// - Parameter upstream: A sequence containing zero or more publishers to merge with this publisher.
        public init<S>(_ upstream: S) where Upstream == S.Element, S : Sequence

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input

        public func merge(with other: Upstream) -> Publishers.MergeMany<Upstream>
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.
    public struct Scan<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream

        /// The previous result returned by the `nextPartialResult` closure.
        public let initialResult: Output

        ///  An error-throwing closure that takes as its arguments the previous value returned by the closure and the next element emitted from the upstream publisher.
        public let nextPartialResult: (Output, Upstream.Output) -> Output

        /// Creates a publisher that transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.
        /// - Parameters:
        ///   - upstream: The publisher that this publisher receives elements from.
        ///   - initialResult: The previous result returned by the `nextPartialResult` closure.
        ///   - nextPartialResult: A closure that takes as its arguments the previous value returned by the closure and the next element emitted from the upstream publisher.
        public init(upstream: Upstream, initialResult: Output, nextPartialResult: @escaping (Output, Upstream.Output) -> Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, Upstream.Failure == S.Failure
    }

    /// A publisher that transforms elements from the upstream publisher by providing the current element to a failable closure along with the last value returned by the closure.
    public struct TryScan<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream

        /// The previous result returned by the `nextPartialResult` closure.
        public let initialResult: Output

        /// An error-throwing closure that takes as its arguments the previous value returned by the closure and the next element emitted from the upstream publisher.
        public let nextPartialResult: (Output, Upstream.Output) throws -> Output

        /// Creates a publisher that transforms elements from the upstream publisher by providing the current element to a failable closure along with the last value returned by the closure.
        /// - Parameters:
        ///   - upstream: The publisher that this publisher receives elements from.
        ///   - initialResult: The previous result returned by the `nextPartialResult` closure.
        ///   - nextPartialResult: An error-throwing closure that takes as its arguments the previous value returned by the closure and the next element emitted from the upstream publisher.
        public init(upstream: Upstream, initialResult: Output, nextPartialResult: @escaping (Output, Upstream.Output) throws -> Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes the number of elements received from the upstream publisher.
    public struct Count<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces integer elements.
        public typealias Output = Int

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that publishes the number of elements received from the upstream publisher.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == Int
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies a predicate closure.
    public struct LastWhere<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that determines whether to publish an element.
        public let predicate: (Publishers.LastWhere<Upstream>.Output) -> Bool

        /// Creates a publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies a predicate closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The closure that determines whether to publish an element.
        public init(upstream: Upstream, predicate: @escaping (Publishers.LastWhere<Upstream>.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies an error-throwing predicate closure.
    public struct TryLastWhere<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The error-throwing closure that determines whether to publish an element.
        public let predicate: (Publishers.TryLastWhere<Upstream>.Output) throws -> Bool

        /// Creates a publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies an error-throwing predicate closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - predicate: The error-throwing closure that determines whether to publish an element.
        public init(upstream: Upstream, predicate: @escaping (Publishers.TryLastWhere<Upstream>.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that ignores all upstream elements, but passes along the upstream publisher's completion state (finished or failed).
    public struct IgnoreOutput<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher never produces elements.
        public typealias Output = Never

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that ignores all upstream elements, but passes along the upstream publisher's completion state (finish or failed).
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, S.Input == Never
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that flattens nested publishers.
    ///
    /// Given a publisher that publishes ``Publisher`` instances, the ``Publishers/SwitchToLatest`` publisher produces a sequence of events from only the most recent one. For example, given the type `AnyPublisher<URLSession.DataTaskPublisher,
    /// NSError>`, calling ``Publisher/switchToLatest()`` results in the type `SwitchToLatest<(Data, URLResponse), URLError>`. The downstream subscriber sees a continuous stream of `(Data, URLResponse)` elements from what looks like a single <doc://com.apple.documentation/documentation/Foundation/URLSession/DataTaskPublisher> even though the elements are coming from different upstream publishers.
    ///
    /// When ``Publishers/SwitchToLatest`` receives a new publisher from the upstream publisher, it cancels its previous subscription. Use this feature to prevent earlier publishers from performing unnecessary work, such as creating network request publishers from frequently-updating user interface publishers.
    public struct SwitchToLatest<P, Upstream> : Publisher where P : Publisher, P == Upstream.Output, Upstream : Publisher, P.Failure == Upstream.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces elements of the type produced by the upstream publisher-of-publishers.
        public typealias Output = P.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces errors of the type produced by the upstream publisher-of-publishers.
        public typealias Failure = P.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that “flattens” nested publishers.
        ///
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, P.Output == S.Input, Upstream.Failure == S.Failure
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that attempts to recreate its subscription to a failed upstream publisher.
    public struct Retry<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The maximum number of retry attempts to perform.
        ///
        /// If `nil`, this publisher attempts to reconnect with the upstream publisher an unlimited number of times.
        public let retries: Int?

        /// Creates a publisher that attempts to recreate its subscription to a failed upstream publisher.
        ///
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives its elements.
        ///   - retries: The maximum number of retry attempts to perform. If `nil`, this publisher attempts to reconnect with the upstream publisher an unlimited number of times.
        public init(upstream: Upstream, retries: Int?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that converts any failure from the upstream publisher into a new error.
    public struct MapError<Upstream, Failure> : Publisher where Upstream : Publisher, Failure : Error {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that converts the upstream failure into a new error.
        public let transform: (Upstream.Failure) -> Failure

        /// Creates a publisher that converts any failure from the upstream publisher into a new error.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - transform: The closure that converts the upstream failure into a new error.
        public init(upstream: Upstream, transform: @escaping (Upstream.Failure) -> Failure)

        public init(upstream: Upstream, _ map: @escaping (Upstream.Failure) -> Failure)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Failure == S.Failure, S : Subscriber, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes either the most-recent or first element published by the upstream publisher in a specified time interval.
    public struct Throttle<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The interval in which to find and emit the most recent element.
        public let interval: Context.SchedulerTimeType.Stride

        /// The scheduler on which to publish elements.
        public let scheduler: Context

        /// A Boolean value indicating whether to publish the most recent element.
        ///
        /// If `false`, the publisher emits the first element received during the interval.
        public let latest: Bool

        /// Creates a publisher that publishes either the most-recent or first element published by the upstream publisher in a specified time interval.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - interval: The interval in which to find and emit the most recent element.
        ///   - scheduler: The scheduler on which to publish elements.
        ///   - latest: A Boolean value indicating whether to publish the most recent element. If `false`, the publisher emits the first element received during the interval.
        public init(upstream: Upstream, interval: Context.SchedulerTimeType.Stride, scheduler: Context, latest: Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that shares the output of an upstream publisher with multiple subscribers.
    ///
    /// This publisher type supports multiple subscribers, all of whom receive unchanged elements and completion states from the upstream publisher.
    ///
    ///  > Tip: ``Publishers/Share`` is effectively a combination of the ``Publishers/Multicast`` and ``PassthroughSubject`` publishers, with an implicit ``ConnectablePublisher/autoconnect()``.
    ///
    /// Be aware that ``Publishers/Share`` is a class rather than a structure like most other publishers. Use this type when you need a publisher instance that uses reference semantics.
    final public class Share<Upstream> : Publisher, Equatable where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        final public let upstream: Upstream

        /// Creates a publisher that shares the output of an upstream publisher with multiple subscribers.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        final public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input

        /// Returns a Boolean value that indicates whether two publishers are equivalent.
        /// - Parameters:
        ///   - lhs: A `Share` publisher to compare for equality.
        ///   - rhs: Another `Share` publisher to compare for equality.
        /// - Returns: `true` if the publishers have reference equality (`===`); otherwise `false`.
        public static func == (lhs: Publishers.Share<Upstream>, rhs: Publishers.Share<Upstream>) -> Bool
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item.
    public struct Comparison<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upsteam publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives its elements.
        public let upstream: Upstream

        /// A closure that receives two elements and returns true if they are in increasing order.
        public let areInIncreasingOrder: (Upstream.Output, Upstream.Output) -> Bool

        /// Creates a publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives its elements.
        ///   - areInIncreasingOrder: A closure that receives two elements and returns true if they are in increasing order.
        public init(upstream: Upstream, areInIncreasingOrder: @escaping (Upstream.Output, Upstream.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item, and fails if the ordering logic throws an error.
    public struct TryComparison<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upsteam publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives its elements.
        public let upstream: Upstream

        /// A closure that receives two elements and returns true if they are in increasing order.
        public let areInIncreasingOrder: (Upstream.Output, Upstream.Output) throws -> Bool

        /// Creates a publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item, and fails if the ordering logic throws an error.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives its elements.
        ///   - areInIncreasingOrder: A closure that receives two elements and returns true if they are in increasing order.
        public init(upstream: Upstream, areInIncreasingOrder: @escaping (Upstream.Output, Upstream.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that replaces an empty stream with a provided element.
    public struct ReplaceEmpty<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The element to deliver when the upstream publisher finishes without delivering any elements.
        public let output: Publishers.ReplaceEmpty<Upstream>.Output

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that replaces an empty stream with a provided element.
        /// - Parameters:
        ///   - upstream: The element to deliver when the upstream publisher finishes without delivering any elements.
        ///   - output: The publisher from which this publisher receives elements.
        public init(upstream: Upstream, output: Publishers.ReplaceEmpty<Upstream>.Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that replaces any errors in the stream with a provided element.
    public struct ReplaceError<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher never fails.
        public typealias Failure = Never

        /// The element with which to replace errors from the upstream publisher.
        public let output: Publishers.ReplaceError<Upstream>.Output

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that replaces any errors in the stream with a provided element.
        /// - Parameters:
        ///   - upstream: The element with which to replace errors from the upstream publisher.
        ///   - output: The publisher from which this publisher receives elements.
        public init(upstream: Upstream, output: Publishers.ReplaceError<Upstream>.Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Never
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that raises a fatal error upon receiving any failure, and otherwise republishes all received input.
    ///
    /// Use this function for internal integrity checks that are active during testing but don't affect performance of shipping code.
    public struct AssertNoFailure<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher never produces errors.
        public typealias Failure = Never

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The string used at the beginning of the fatal error message.
        public let prefix: String

        /// The filename used in the error message.
        public let file: StaticString

        /// The line number used in the error message.
        public let line: UInt

        /// Creates a publisher that raises a fatal error upon receiving any failure, and otherwise republishes all received input.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - prefix: The string used at the beginning of the fatal error message.
        ///   - file: The filename used in the error message.
        ///   - line: The line number used in the error message.
        public init(upstream: Upstream, prefix: String, file: StaticString, line: UInt)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Never
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that ignores elements from the upstream publisher until it receives an element from second publisher.
    public struct DropUntilOutput<Upstream, Other> : Publisher where Upstream : Publisher, Other : Publisher, Upstream.Failure == Other.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives its elements.
        public let upstream: Upstream

        /// A publisher to monitor for its first emitted element.
        public let other: Other

        /// Creates a publisher that ignores elements from the upstream publisher until it receives an element from another publisher.
        ///
        /// - Parameters:
        ///   - upstream: A publisher to drop elements from while waiting for another publisher to emit elements.
        ///   - other: A publisher to monitor for its first emitted element.
        public init(upstream: Upstream, other: Other)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, Other.Failure == S.Failure
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that performs the specified closures when publisher events occur.
    public struct HandleEvents<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// A closure that executes when the publisher receives the subscription from the upstream publisher.
        public var receiveSubscription: ((Subscription) -> Void)?

        /// A closure that executes when the publisher receives a value from the upstream publisher.
        public var receiveOutput: ((Publishers.HandleEvents<Upstream>.Output) -> Void)?

        /// A closure that executes when the upstream publisher finishes normally or terminates with an error.
        public var receiveCompletion: ((Subscribers.Completion<Publishers.HandleEvents<Upstream>.Failure>) -> Void)?

        /// A closure that executes when the downstream receiver cancels publishing.
        public var receiveCancel: (() -> Void)?

        /// A closure that executes when the publisher receives a request for more elements.
        public var receiveRequest: ((Subscribers.Demand) -> Void)?

        /// Creates a publisher that performs the specified closures when publisher events occur.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - receiveSubscription: A closure that executes when the publisher receives the subscription from the upstream publisher.
        ///   - receiveOutput: A closure that executes when the publisher receives a value from the upstream publisher.
        ///   - receiveCompletion: A closure that executes when the publisher receives the completion from the upstream publisher.
        ///   - receiveCancel: A closure that executes when the downstream receiver cancels publishing.
        ///   - receiveRequest: A closure that executes when the publisher receives a request for more elements.
        public init(upstream: Upstream, receiveSubscription: ((Subscription) -> Void)? = nil, receiveOutput: ((Publishers.HandleEvents<Upstream>.Output) -> Void)? = nil, receiveCompletion: ((Subscribers.Completion<Publishers.HandleEvents<Upstream>.Failure>) -> Void)? = nil, receiveCancel: (() -> Void)? = nil, receiveRequest: ((Subscribers.Demand) -> Void)?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that emits all of one publisher’s elements before those from another publisher.
    public struct Concatenate<Prefix, Suffix> : Publisher where Prefix : Publisher, Suffix : Publisher, Prefix.Failure == Suffix.Failure, Prefix.Output == Suffix.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its source publishers' output type.
        public typealias Output = Suffix.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its source publishers' failure type.
        public typealias Failure = Suffix.Failure

        /// The publisher to republish, in its entirety, before republishing elements from `suffix`.
        public let prefix: Prefix

        /// The publisher to republish only after `prefix` finishes.
        public let suffix: Suffix

        /// Creates a publisher that emits all of one publisher’s elements before those from another publisher.
        /// - Parameters:
        ///   - prefix: The publisher to republish, in its entirety, before republishing elements from `suffix`.
        ///   - suffix: The publisher to republish only after `prefix` finishes.
        public init(prefix: Prefix, suffix: Suffix)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Suffix.Failure == S.Failure, Suffix.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes elements only after a specified time interval elapses between events.
    public struct Debounce<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The amount of time the publisher should wait before publishing an element.
        public let dueTime: Context.SchedulerTimeType.Stride

        /// The scheduler on which this publisher delivers elements.
        public let scheduler: Context

        /// Scheduler options that customize this publisher’s delivery of elements.
        public let options: Context.SchedulerOptions?

        /// Creates a publisher that publishes elements only after a specified time interval elapses between events.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - dueTime: The amount of time the publisher should wait before publishing an element.
        ///   - scheduler: The scheduler on which this publisher delivers elements.
        ///   - options: Scheduler options that customize this publisher’s delivery of elements.
        public init(upstream: Upstream, dueTime: Context.SchedulerTimeType.Stride, scheduler: Context, options: Context.SchedulerOptions?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that waits until after the stream finishes, and then publishes the last element of the stream.
    public struct Last<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that waits until after the stream finishes and then publishes the last element of the stream.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that transforms all elements from the upstream publisher with a provided closure.
    public struct Map<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that transforms elements from the upstream publisher.
        public let transform: (Upstream.Output) -> Output

        /// Creates a publisher that transforms all elements from the upstream publisher with a provided closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - transform: The closure that transforms elements from the upstream publisher.
        public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, Upstream.Failure == S.Failure
    }

    /// A publisher that transforms all elements from the upstream publisher with a provided error-throwing closure.
    public struct TryMap<Upstream, Output> : Publisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The error-throwing closure that transforms elements from the upstream publisher.
        public let transform: (Upstream.Output) throws -> Output

        /// Creates a publisher that transforms all elements from the upstream publisher with a provided error-throwing closure.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - transform: The error-throwing closure that transforms elements from the upstream publisher.
        public init(upstream: Upstream, transform: @escaping (Upstream.Output) throws -> Output)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that terminates publishing if the upstream publisher exceeds a specified time interval without producing an element.
    public struct Timeout<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The maximum time interval the publisher can go without emitting an element, expressed in the time system of the scheduler.
        public let interval: Context.SchedulerTimeType.Stride

        /// The scheduler on which to deliver events.
        public let scheduler: Context

        /// Scheduler options that customize the delivery of elements.
        public let options: Context.SchedulerOptions?

        /// A closure that executes if the publisher times out. The publisher sends the failure returned by this closure to the subscriber as the reason for termination.
        public let customError: (() -> Publishers.Timeout<Upstream, Context>.Failure)?

        /// Creates a publisher that terminates publishing if the upstream publisher exceeds the specified time interval without producing an element.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - interval: The maximum time interval the publisher can go without emitting an element, expressed in the time system of the scheduler.
        ///   - scheduler: The scheduler on which to deliver events.
        ///   - options: Scheduler options that customize the delivery of elements.
        ///   - customError: A closure that executes if the publisher times out. The publisher sends the failure returned by this closure to the subscriber as the reason for termination.
        public init(upstream: Upstream, interval: Context.SchedulerTimeType.Stride, scheduler: Context, options: Context.SchedulerOptions?, customError: (() -> Publishers.Timeout<Upstream, Context>.Failure)?)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A strategy for filling a buffer.
    public enum PrefetchStrategy {

        /// A strategy to fill the buffer at subscription time, and keep it full thereafter.
        ///
        /// This strategy starts by making a demand equal to the buffer’s size from the upstream when the subscriber first connects. Afterwards, it continues to demand elements from the upstream to try to keep the buffer full.
        case keepFull

        /// A strategy that avoids prefetching and instead performs requests on demand.
        ///
        /// This strategy just forwards the downstream’s requests to the upstream publisher.
        case byRequest

        /// Returns a Boolean value indicating whether two values are equal.
        ///
        /// Equality is the inverse of inequality. For any values `a` and `b`,
        /// `a == b` implies that `a != b` is `false`.
        ///
        /// - Parameters:
        ///   - lhs: A value to compare.
        ///   - rhs: Another value to compare.
        public static func == (a: Publishers.PrefetchStrategy, b: Publishers.PrefetchStrategy) -> Bool

        /// Hashes the essential components of this value by feeding them into the
        /// given hasher.
        ///
        /// Implement this method to conform to the `Hashable` protocol. The
        /// components used for hashing must be the same as the components compared
        /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
        /// with each of these components.
        ///
        /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
        ///   compile-time error in the future.
        ///
        /// - Parameter hasher: The hasher to use when combining the components
        ///   of this instance.
        public func hash(into hasher: inout Hasher)

        /// The hash value.
        ///
        /// Hash values are not guaranteed to be equal across different executions of
        /// your program. Do not save hash values to use during a future execution.
        ///
        /// - Important: `hashValue` is deprecated as a `Hashable` requirement. To
        ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
        public var hashValue: Int { get }
    }

    /// A strategy that handles exhaustion of a buffer’s capacity.
    public enum BufferingStrategy<Failure> where Failure : Error {

        /// When the buffer is full, discard the newly received element.
        case dropNewest

        /// When the buffer is full, discard the oldest element in the buffer.
        case dropOldest

        /// When the buffer is full, execute the closure to provide a custom error.
        case customError(() -> Failure)
    }

    /// A publisher that buffers elements from an upstream publisher.
    public struct Buffer<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The maximum number of elements to store.
        public let size: Int

        /// The strategy for initially populating the buffer.
        public let prefetch: Publishers.PrefetchStrategy

        /// The action to take when the buffer becomes full.
        public let whenFull: Publishers.BufferingStrategy<Publishers.Buffer<Upstream>.Failure>

        /// Creates a publisher that buffers elements received from an upstream publisher.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        /// - Parameter size: The maximum number of elements to store.
        /// - Parameter prefetch: The strategy for initially populating the buffer.
        /// - Parameter whenFull: The action to take when the buffer becomes full.
        public init(upstream: Upstream, size: Int, prefetch: Publishers.PrefetchStrategy, whenFull: Publishers.BufferingStrategy<Publishers.Buffer<Upstream>.Failure>)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes a given sequence of elements.
    ///
    /// When the publisher exhausts the elements in the sequence, the next request causes the publisher to finish.
    public struct Sequence<Elements, Failure> : Publisher where Elements : Sequence, Failure : Error {

        /// The kind of values published by this publisher.
        public typealias Output = Elements.Element

        /// The sequence of elements to publish.
        public let sequence: Elements

        /// Creates a publisher for a sequence of elements.
        ///
        /// - Parameter sequence: The sequence of elements to publish.
        public init(sequence: Elements)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where Failure == S.Failure, S : Subscriber, Elements.Element == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher created by applying the zip function to two upstream publishers.
    ///
    /// Use `Publishers.Zip` to combine the latest elements from two publishers and emit a tuple to the downstream. The returned publisher waits until both publishers have emitted an event, then delivers the oldest unconsumed event from each publisher together as a tuple to the subscriber.
    ///
    /// Much like a zipper or zip fastener on a piece of clothing pulls together rows of teeth to link the two sides, `Publishers.Zip` combines streams from two different publishers by linking pairs of elements from each side.
    ///
    /// If either upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    public struct Zip<A, B> : Publisher where A : Publisher, B : Publisher, A.Failure == B.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces two-element tuples, whose members' types correspond to the types produced by the upstream publishers.
        public typealias Output = (A.Output, B.Output)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to zip.
        public let a: A

        /// Another publisher to zip.
        public let b: B

        /// Creates a publisher that applies the zip function to two upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to zip.
        ///   - b: Another publisher to zip.
        public init(_ a: A, _ b: B)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, B.Failure == S.Failure, S.Input == (A.Output, B.Output)
    }

    /// A publisher created by applying the zip function to three upstream publishers.
    ///
    /// Use a `Publishers.Zip3` to combine the latest elements from three publishers and emit a tuple to the downstream. The returned publisher waits until all three publishers have emitted an event, then delivers the oldest unconsumed event from each publisher as a tuple to the subscriber.
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    public struct Zip3<A, B, C> : Publisher where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, B.Failure == C.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces three-element tuples, whose members' types correspond to the types produced by the upstream publishers.
        public typealias Output = (A.Output, B.Output, C.Output)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to zip.
        public let a: A

        /// A second publisher to zip.
        public let b: B

        /// A third publisher to zip.
        public let c: C

        /// Creates a publisher that applies the zip function to three upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to zip.
        ///   - b: A second publisher to zip.
        ///   - c: A third publisher to zip.
        public init(_ a: A, _ b: B, _ c: C)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, C.Failure == S.Failure, S.Input == (A.Output, B.Output, C.Output)
    }

    /// A publisher created by applying the zip function to four upstream publishers.
    ///
    /// Use a `Publishers.Zip4` to combine the latest elements from four publishers and emit a tuple to the downstream. The returned publisher waits until all four publishers have emitted an event, then delivers the oldest unconsumed event from each publisher as a tuple to the subscriber.
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    public struct Zip4<A, B, C, D> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher produces four-element tuples, whose members' types correspond to the types produced by the upstream publishers.
        public typealias Output = (A.Output, B.Output, C.Output, D.Output)

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publishers' common failure type.
        public typealias Failure = A.Failure

        /// A publisher to zip.
        public let a: A

        /// A second publisher to zip.
        public let b: B

        /// A third publisher to zip.
        public let c: C

        /// A fourth publisher to zip.
        public let d: D

        /// Creates a publisher created by applying the zip function to four upstream publishers.
        /// - Parameters:
        ///   - a: A publisher to zip.
        ///   - b: A second publisher to zip.
        ///   - c: A third publisher to zip.
        ///   - d: A fourth publisher to zip.
        public init(_ a: A, _ b: B, _ c: C, _ d: D)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, D.Failure == S.Failure, S.Input == (A.Output, B.Output, C.Output, D.Output)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes elements specified by a range in the sequence of published elements.
    public struct Output<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives its elements.
        public let upstream: Upstream

        /// The range of elements to publish.
        public let range: CountableRange<Int>

        /// Creates a publisher that publishes elements specified by a range.
        ///
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives its elements.
        ///   - range: The range of elements to publish.
        public init(upstream: Upstream, range: CountableRange<Int>)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
    public struct Catch<Upstream, NewPublisher> : Publisher where Upstream : Publisher, NewPublisher : Publisher, Upstream.Output == NewPublisher.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses the replacement publisher's failure type.
        public typealias Failure = NewPublisher.Failure

        /// The publisher from which this publisher receives its elements.
        public let upstream: Upstream

        /// A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
        public let handler: (Upstream.Failure) -> NewPublisher

        /// Creates a publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
        ///
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives its elements.
        ///   - handler: A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> NewPublisher)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, NewPublisher.Failure == S.Failure, NewPublisher.Output == S.Input
    }

    /// A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher or producing a new error.
    ///
    /// Because this publisher’s handler can throw an error, ``Publishers/TryCatch`` defines its ``Publisher/Failure`` type as `Error`. This is different from ``Publishers/Catch``, which gets its failure type from the replacement publisher.
    public struct TryCatch<Upstream, NewPublisher> : Publisher where Upstream : Publisher, NewPublisher : Publisher, Upstream.Output == NewPublisher.Output {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives its elements.
        public let upstream: Upstream

        /// A closure that accepts the upstream failure as input and either returns a publisher to replace the upstream publisher or throws an error.
        public let handler: (Upstream.Failure) throws -> NewPublisher

        /// Creates a publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher or by throwing an error.
        ///
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives its elements.
        ///   - handler: A closure that accepts the upstream failure as input and either returns a publisher to replace the upstream publisher. If this closure throws an error, the publisher terminates with the thrown error.
        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) throws -> NewPublisher)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, NewPublisher.Output == S.Input, S.Failure == Error
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that transforms elements from an upstream publisher into a new publisher.
    public struct FlatMap<NewPublisher, Upstream> : Publisher where NewPublisher : Publisher, Upstream : Publisher, NewPublisher.Failure == Upstream.Failure {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses the output type declared by the new publisher.
        public typealias Output = NewPublisher.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The maximum number of concurrent publisher subscriptions
        public let maxPublishers: Subscribers.Demand

        /// A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
        public let transform: (Upstream.Output) -> NewPublisher

        /// Creates a publisher that transforms elements from an upstream publisher into a new publisher.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - maxPublishers: The maximum number of concurrent publisher subscriptions.
        ///   - transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
        public init(upstream: Upstream, maxPublishers: Subscribers.Demand, transform: @escaping (Upstream.Output) -> NewPublisher)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, NewPublisher.Output == S.Input, Upstream.Failure == S.Failure
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that delays delivery of elements and completion to the downstream receiver.
    public struct Delay<Upstream, Context> : Publisher where Upstream : Publisher, Context : Scheduler {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives its elements.
        public let upstream: Upstream

        /// The amount of time to delay.
        public let interval: Context.SchedulerTimeType.Stride

        /// The allowed tolerance in firing delayed events.
        public let tolerance: Context.SchedulerTimeType.Stride

        /// The scheduler to deliver the delayed events.
        public let scheduler: Context

        /// Options relevant to the scheduler’s behavior.
        public let options: Context.SchedulerOptions?

        /// Creates a publisher that delays delivery of elements and completion to the downstream receiver.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives its elements.
        ///   - interval: The amount of time to delay.
        ///   - tolerance: The allowed tolerance in delivering delayed events. The `Delay` publisher may deliver elements this much sooner or later than the interval specifies.
        ///   - scheduler: The scheduler to deliver the delayed events.
        ///   - options: Options relevant to the scheduler’s behavior.
        public init(upstream: Upstream, interval: Context.SchedulerTimeType.Stride, tolerance: Context.SchedulerTimeType.Stride, scheduler: Context, options: Context.SchedulerOptions? = nil)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that omits a specified number of elements before republishing later elements.
    public struct Drop<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The number of elements to drop.
        public let count: Int

        /// Creates a publisher that omits a specified number of elements before republishing later elements.
        /// - Parameters:
        ///   - upstream: The publisher from which this publisher receives elements.
        ///   - count: The number of elements to drop.
        public init(upstream: Upstream, count: Int)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes the first element of a stream, then finishes.
    public struct First<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// Creates a publisher that publishes the first element of a stream, then finishes.
        /// - Parameter upstream: The publisher from which this publisher receives elements.
        public init(upstream: Upstream)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that only publishes the first element of a stream to satisfy a predicate closure.
    public struct FirstWhere<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that determines whether to publish an element.
        public let predicate: (Publishers.FirstWhere<Upstream>.Output) -> Bool

        public init(upstream: Upstream, predicate: @escaping (Publishers.FirstWhere<Upstream>.Output) -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input
    }

    /// A publisher that only publishes the first element of a stream to satisfy a throwing predicate closure.
    public struct TryFirstWhere<Upstream> : Publisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The error-throwing closure that determines whether to publish an element.
        public let predicate: (Publishers.TryFirstWhere<Upstream>.Output) throws -> Bool

        public init(upstream: Upstream, predicate: @escaping (Publishers.TryFirstWhere<Upstream>.Output) throws -> Bool)

        /// Attaches the specified subscriber to this publisher.
        ///
        /// Implementations of ``Publisher`` must implement this method.
        ///
        /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
        ///
        /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, Upstream.Output == S.Input, S.Failure == Error
    }
}
