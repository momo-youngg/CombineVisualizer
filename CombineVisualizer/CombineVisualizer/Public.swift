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
    final public class CZMulticast<Upstream, SubjectType> : CZPublisher where Upstream : Publisher, SubjectType : Subject, Upstream.Failure == SubjectType.Failure, Upstream.Output == SubjectType.Output {

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
        
        public let inner: Multicast<Upstream, SubjectType>
        public let uuid: UUID
        
        public init(inner: Publishers.Multicast<Upstream, SubjectType>, uuid: UUID) {
            self.upstream = inner.upstream
            self.createSubject = inner.createSubject
            self.inner = inner
            self.uuid = uuid
        }
        
        /// Connects to the publisher, allowing it to produce elements, and returns an instance with which to cancel publishing.
        ///
        /// - Returns: A ``Cancellable`` instance that you use to cancel publishing.
        final public func connect() -> Cancellable {
            self.visualize()
            return inner.connect()
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that receives elements from an upstream publisher on a specific scheduler.
    public struct CZSubscribeOn<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: SubscribeOn<Upstream, Context>
        public let uuid: UUID

        public init(inner: SubscribeOn<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.scheduler = inner.scheduler
            self.options = inner.options
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that measures and emits the time interval between events received from an upstream publisher.
    public struct CZMeasureInterval<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: MeasureInterval<Upstream, Context>
        public let uuid: UUID

        public init(inner: MeasureInterval<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.scheduler = inner.scheduler
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that omits elements from an upstream publisher until a given closure returns false.
    public struct CZDropWhile<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: DropWhile<Upstream>
        public let uuid: UUID

        public init(inner: DropWhile<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that omits elements from an upstream publisher until a given error-throwing closure returns false.
    public struct CZTryDropWhile<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryDropWhile<Upstream>
        public let uuid: UUID

        public init(inner: TryDropWhile<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes all elements that match a provided closure.
    public struct CZFilter<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Filter<Upstream>
        public let uuid: UUID

        public init(inner: Filter<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.isIncluded = inner.isIncluded
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that republishes all elements that match a provided error-throwing closure.
    public struct CZTryFilter<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryFilter<Upstream>
        public let uuid: UUID

        public init(inner: TryFilter<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.isIncluded = inner.isIncluded
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that raises a debugger signal when a provided closure needs to stop the process in the debugger.
    ///
    /// When any of the provided closures returns `true`, this publisher raises the `SIGTRAP` signal to stop the process in the debugger.
    /// Otherwise, this publisher passes through values and completions as-is.
    public struct CZBreakpoint<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Breakpoint<Upstream>
        public let uuid: UUID

        public init(inner: Breakpoint<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.receiveSubscription = inner.receiveSubscription
            self.receiveOutput = inner.receiveOutput
            self.receiveCompletion = inner.receiveCompletion
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes a single Boolean value that indicates whether all received elements pass a given predicate.
    public struct CZAllSatisfy<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: AllSatisfy<Upstream>
        public let uuid: UUID

        public init(inner: AllSatisfy<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that publishes a single Boolean value that indicates whether all received elements pass a given error-throwing predicate.
    public struct CZTryAllSatisfy<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryAllSatisfy<Upstream>
        public let uuid: UUID

        public init(inner: TryAllSatisfy<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes only elements that don’t match the previous element.
    public struct CZRemoveDuplicates<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: RemoveDuplicates<Upstream>
        public let uuid: UUID

        public init(inner: RemoveDuplicates<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that publishes only elements that don’t match the previous element, as evaluated by a provided error-throwing closure.
    public struct CZTryRemoveDuplicates<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryRemoveDuplicates<Upstream>
        public let uuid: UUID

        public init(inner: TryRemoveDuplicates<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that decodes elements received from an upstream publisher, using a given decoder.
    public struct CZDecode<Upstream, Output, Coder> : CZPublisher where Upstream : Publisher, Output : Decodable, Coder : TopLevelDecoder, Upstream.Output == Coder.Input {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        public let upstream: Upstream
        public let inner: Decode<Upstream, Output, Coder>
        public let uuid: UUID

        public init(inner: Decode<Upstream, Output, Coder>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that encodes elements received from an upstream publisher, using a given encoder.
    public struct CZEncode<Upstream, Coder> : CZPublisher where Upstream : Publisher, Coder : TopLevelEncoder, Upstream.Output : Encodable {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses the encoder's output type.
        public typealias Output = Coder.Output

        public let upstream: Upstream
        public let inner: Encode<Upstream, Coder>
        public let uuid: UUID

        public init(inner: Encode<Upstream, Coder>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that emits a Boolean value when it receives a specific element from its upstream publisher.
    public struct CZContains<Upstream> : CZPublisher where Upstream : Publisher, Upstream.Output : Equatable {

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
        
        public let inner: Contains<Upstream>
        public let uuid: UUID

        public init(inner: Contains<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.output = inner.output
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that receives and combines the latest elements from two publishers.
    public struct CZCombineLatest<A, B> : CZPublisher where A : Publisher, B : Publisher, A.Failure == B.Failure {

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
        
        public let inner: CombineLatest<A, B>
        public let uuid: UUID

        public init(inner: CombineLatest<A, B>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that receives and combines the latest elements from three publishers.
    public struct CZCombineLatest3<A, B, C> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, B.Failure == C.Failure {

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
        
        public let inner: CombineLatest3<A, B, C>
        public let uuid: UUID

        public init(inner: CombineLatest3<A, B, C>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that receives and combines the latest elements from four publishers.
    public struct CZCombineLatest4<A, B, C, D> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure {

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

        public let inner: CombineLatest4<A, B, C, D>
        public let uuid: UUID
        
        public init(inner: CombineLatest4<A, B, C, D>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.d = inner.d
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that automatically connects to an upstream connectable publisher.
    ///
    /// This publisher calls ``ConnectablePublisher/connect()`` on the upstream ``ConnectablePublisher`` when first attached to by a subscriber.
    public class CZAutoconnect<Upstream> : CZPublisher where Upstream : ConnectablePublisher {

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
        
        public let inner: Autoconnect<Upstream>
        public let uuid: UUID
        
        required public init(inner: Autoconnect<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
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
    public struct CZPrint<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Print<Upstream>
        public let uuid: UUID

        public init(inner: Print<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.prefix = inner.prefix
            self.stream = inner.stream
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes elements while a predicate closure indicates publishing should continue.
    public struct CZPrefixWhile<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: PrefixWhile<Upstream>
        public let uuid: UUID

        public init(inner: PrefixWhile<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that republishes elements while an error-throwing predicate closure indicates publishing should continue.
    public struct CZTryPrefixWhile<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryPrefixWhile<Upstream>
        public let uuid: UUID

        public init(inner: TryPrefixWhile<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that appears to send a specified failure type.
    ///
    /// The publisher can't actually fail with the specified type and finishes normally. Use this publisher type when you need to match the error types for two mismatched publishers.
    public struct CZSetFailureType<Upstream, Failure> : CZPublisher where Upstream : Publisher, Failure : Error, Upstream.Failure == Never {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream
        
        public let inner: SetFailureType<Upstream, Failure>
        public let uuid: UUID
        
        public init(inner: SetFailureType<Upstream, Failure>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }

        public func setFailureType<E>(to failure: E.Type) -> Publishers.CZSetFailureType<Upstream, E> where E : Error {
            self.visualize()
            return Publishers.CZSetFailureType(inner: self.inner.setFailureType(to: failure), uuid: self.uuid)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that emits a Boolean value upon receiving an element that satisfies the predicate closure.
    public struct CZContainsWhere<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: ContainsWhere<Upstream>
        public let uuid: UUID

        public init(inner: ContainsWhere<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that emits a Boolean value upon receiving an element that satisfies the throwing predicate closure.
    public struct CZTryContainsWhere<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryContainsWhere<Upstream>
        public let uuid: UUID

        public init(inner: TryContainsWhere<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that provides explicit connectability to another publisher.
    ///
    /// ``Publishers/MakeConnectable`` is a ``ConnectablePublisher``, which allows you to perform configuration before publishing any elements. Call ``ConnectablePublisher/connect()`` on this publisher when you want to attach to its upstream publisher and start producing elements.
    ///
    /// Use the ``Publisher/makeConnectable()`` operator to wrap an upstream publisher with an instance of this publisher.
    public struct CZMakeConnectable<Upstream> : CZConnectablePublisher where Upstream : Publisher {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure
        
        public let inner: MakeConnectable<Upstream>
        public let uuid: UUID

        public init(inner: MakeConnectable<Upstream>, uuid: UUID) {
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that buffers and periodically publishes its items.
    public struct CZCollectByTime<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: CollectByTime<Upstream, Context>
        public let uuid: UUID

        public init(inner: CollectByTime<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.strategy = inner.strategy
            self.options = inner.options
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that buffers items.
    public struct CZCollect<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Collect<Upstream>
        public let uuid: UUID

        public init(inner: Collect<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that buffers a maximum number of items.
    public struct CZCollectByCount<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: CollectByCount<Upstream>
        public let uuid: UUID

        public init(inner: CollectByCount<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.count = inner.count
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that delivers elements to its downstream subscriber on a specific scheduler.
    public struct CZReceiveOn<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: ReceiveOn<Upstream, Context>
        public let uuid: UUID

        public init(inner: ReceiveOn<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.scheduler = inner.scheduler
            self.options = inner.options
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes the value of a key path.
    public struct CZMapKeyPath<Upstream, Output> : CZPublisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The key path of a property to publish.
        public let keyPath: KeyPath<Upstream.Output, Output>
        
        public let inner: MapKeyPath<Upstream, Output>
        public let uuid: UUID
        
        public init(inner: MapKeyPath<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.keyPath = inner.keyPath
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that publishes the values of two key paths as a tuple.
    public struct CZMapKeyPath2<Upstream, Output0, Output1> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: MapKeyPath2<Upstream, Output0, Output1>
        public let uuid: UUID
        
        public init(inner: MapKeyPath2<Upstream, Output0, Output1>, uuid: UUID) {
            self.upstream = inner.upstream
            self.keyPath0 = inner.keyPath0
            self.keyPath1 = inner.keyPath1
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that publishes the values of three key paths as a tuple.
    public struct CZMapKeyPath3<Upstream, Output0, Output1, Output2> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: MapKeyPath3<Upstream, Output0, Output1, Output2>
        public let uuid: UUID
        
        public init(inner: MapKeyPath3<Upstream, Output0, Output1, Output2>, uuid: UUID) {
            self.upstream = inner.upstream
            self.keyPath0 = inner.keyPath0
            self.keyPath1 = inner.keyPath1
            self.keyPath2 = inner.keyPath2
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes elements until another publisher emits an element.
    public struct CZPrefixUntilOutput<Upstream, Other> : CZPublisher where Upstream : Publisher, Other : Publisher {

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
        
        public let inner: PrefixUntilOutput<Upstream, Other>
        public let uuid: UUID

        public init(inner: PrefixUntilOutput<Upstream, Other>, uuid: UUID) {
            self.upstream = inner.upstream
            self.other = inner.other
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that applies a closure to all received elements and produces an accumulated value when the upstream publisher finishes.
    public struct CZReduce<Upstream, Output> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Reduce<Upstream, Output>
        public let uuid: UUID

        public init(inner: Reduce<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.initial = inner.initial
            self.nextPartialResult = inner.nextPartialResult
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that applies an error-throwing closure to all received elements and produces an accumulated value when the upstream publisher finishes.
    public struct CZTryReduce<Upstream, Output> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryReduce<Upstream, Output>
        public let uuid: UUID

        public init(inner: TryReduce<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.initial = inner.initial
            self.nextPartialResult = inner.nextPartialResult
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes all non-nil results of calling a closure with each received element.
    public struct CZCompactMap<Upstream, Output> : CZPublisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// A closure that receives values from the upstream publisher and returns optional values.
        public let transform: (Upstream.Output) -> Output?
        
        public let inner: CompactMap<Upstream, Output>
        public let uuid: UUID

        public init(inner: CompactMap<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.transform = inner.transform
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that republishes all non-nil results of calling an error-throwing closure with each received element.
    public struct CZTryCompactMap<Upstream, Output> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryCompactMap<Upstream, Output>
        public let uuid: UUID

        public init(inner: TryCompactMap<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.transform = inner.transform
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher created by applying the merge function to two upstream publishers.
    public struct CZMerge<A, B> : CZPublisher where A : Publisher, B : Publisher, A.Failure == B.Failure, A.Output == B.Output {

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
        
        public let inner: Merge<A, B>
        public let uuid: UUID

        public init(inner: Merge<A, B>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.inner = inner
            self.uuid = uuid
        }

        public func merge<P>(with other: P) -> Publishers.CZMerge3<A, B, P> where P : Publisher, B.Failure == P.Failure, B.Output == P.Output {
            self.visualize()
            return CZMerge3(inner: inner.merge(with: other), uuid: self.uuid)
        }

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.CZMerge4<A, B, Z, Y> where Z : Publisher, Y : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output {
            self.visualize()
            return CZMerge4(inner: inner.merge(with: z, y), uuid: self.uuid)
        }

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.CZMerge5<A, B, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output {
            self.visualize()
            return CZMerge5(inner: inner.merge(with: z, y, x), uuid: self.uuid)
        }

        public func merge<Z, Y, X, W>(with z: Z, _ y: Y, _ x: X, _ w: W) -> Publishers.CZMerge6<A, B, Z, Y, X, W> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output {
            self.visualize()
            return CZMerge6(inner: inner.merge(with: z, y, x, w), uuid: self.uuid)
        }

        public func merge<Z, Y, X, W, V>(with z: Z, _ y: Y, _ x: X, _ w: W, _ v: V) -> Publishers.CZMerge7<A, B, Z, Y, X, W, V> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, V : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output, W.Failure == V.Failure, W.Output == V.Output {
            self.visualize()
            return CZMerge7(inner: inner.merge(with: z, y, x, w, v), uuid: self.uuid)
        }

        public func merge<Z, Y, X, W, V, U>(with z: Z, _ y: Y, _ x: X, _ w: W, _ v: V, _ u: U) -> Publishers.CZMerge8<A, B, Z, Y, X, W, V, U> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, V : Publisher, U : Publisher, B.Failure == Z.Failure, B.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output, W.Failure == V.Failure, W.Output == V.Output, V.Failure == U.Failure, V.Output == U.Output {
            self.visualize()
            return CZMerge8(inner: inner.merge(with: z, y, x, w, v, u), uuid: self.uuid)
        }
    }

    /// A publisher created by applying the merge function to three upstream publishers.
    public struct CZMerge3<A, B, C> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output {

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
        
        public let inner: Merge3<A, B, C>
        public let uuid: UUID

        public init(inner: Merge3<A, B, C>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.inner = inner
            self.uuid = uuid
        }
        
        public func merge<P>(with other: P) -> Publishers.CZMerge4<A, B, C, P> where P : Publisher, C.Failure == P.Failure, C.Output == P.Output {
            self.visualize()
            return CZMerge4(inner: inner.merge(with: other), uuid: self.uuid)
        }

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.CZMerge5<A, B, C, Z, Y> where Z : Publisher, Y : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output {
            self.visualize()
            return CZMerge5(inner: inner.merge(with: z, y), uuid: self.uuid)
        }

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.CZMerge6<A, B, C, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output {
            self.visualize()
            return CZMerge6(inner: inner.merge(with: z, y, x), uuid: self.uuid)
        }

        public func merge<Z, Y, X, W>(with z: Z, _ y: Y, _ x: X, _ w: W) -> Publishers.CZMerge7<A, B, C, Z, Y, X, W> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output {
            self.visualize()
            return CZMerge7(inner: inner.merge(with: z, y, x, w), uuid: self.uuid)
        }

        public func merge<Z, Y, X, W, V>(with z: Z, _ y: Y, _ x: X, _ w: W, _ v: V) -> Publishers.CZMerge8<A, B, C, Z, Y, X, W, V> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, V : Publisher, C.Failure == Z.Failure, C.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output, W.Failure == V.Failure, W.Output == V.Output {
            self.visualize()
            return CZMerge8(inner: inner.merge(with: z, y, x, w, v), uuid: self.uuid)
        }
    }

    /// A publisher created by applying the merge function to four upstream publishers.
    public struct CZMerge4<A, B, C, D> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output {

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
        
        public let inner: Merge4<A, B, C, D>
        public let uuid: UUID

        public init(inner: Merge4<A, B, C, D>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.d = inner.d
            self.inner = inner
            self.uuid = uuid
        }

        public func merge<P>(with other: P) -> Publishers.CZMerge5<A, B, C, D, P> where P : Publisher, D.Failure == P.Failure, D.Output == P.Output {
            self.visualize()
            return CZMerge5(inner: inner.merge(with: other), uuid: self.uuid)
        }

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.CZMerge6<A, B, C, D, Z, Y> where Z : Publisher, Y : Publisher, D.Failure == Z.Failure, D.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output {
            self.visualize()
            return CZMerge6(inner: inner.merge(with: z, y), uuid: self.uuid)
        }

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.CZMerge7<A, B, C, D, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, D.Failure == Z.Failure, D.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output {
            self.visualize()
            return CZMerge7(inner: inner.merge(with: z, y, x), uuid: self.uuid)
        }

        public func merge<Z, Y, X, W>(with z: Z, _ y: Y, _ x: X, _ w: W) -> Publishers.CZMerge8<A, B, C, D, Z, Y, X, W> where Z : Publisher, Y : Publisher, X : Publisher, W : Publisher, D.Failure == Z.Failure, D.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output, X.Failure == W.Failure, X.Output == W.Output {
            self.visualize()
            return CZMerge8(inner: inner.merge(with: z, y, x, w), uuid: self.uuid)
        }
    }

    /// A publisher created by applying the merge function to five upstream publishers.
    public struct CZMerge5<A, B, C, D, E> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output {

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
        
        public let inner: Merge5<A, B, C, D, E>
        public let uuid: UUID

        public init(inner: Merge5<A, B, C, D, E>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.d = inner.d
            self.e = inner.e
            self.inner = inner
            self.uuid = uuid
        }

        public func merge<P>(with other: P) -> Publishers.CZMerge6<A, B, C, D, E, P> where P : Publisher, E.Failure == P.Failure, E.Output == P.Output {
            self.visualize()
            return CZMerge6(inner: inner.merge(with: other), uuid: self.uuid)
        }

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.CZMerge7<A, B, C, D, E, Z, Y> where Z : Publisher, Y : Publisher, E.Failure == Z.Failure, E.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output {
            self.visualize()
            return CZMerge7(inner: inner.merge(with: z, y), uuid: self.uuid)
        }

        public func merge<Z, Y, X>(with z: Z, _ y: Y, _ x: X) -> Publishers.CZMerge8<A, B, C, D, E, Z, Y, X> where Z : Publisher, Y : Publisher, X : Publisher, E.Failure == Z.Failure, E.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output, Y.Failure == X.Failure, Y.Output == X.Output {
            self.visualize()
            return CZMerge8(inner: inner.merge(with: z, y, x), uuid: self.uuid)
        }
    }

    /// A publisher created by applying the merge function to six upstream publishers.
    public struct CZMerge6<A, B, C, D, E, F> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output {

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
        
        public let inner: Merge6<A, B, C, D, E, F>
        public let uuid: UUID

        public init(inner: Merge6<A, B, C, D, E, F>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.d = inner.d
            self.e = inner.e
            self.f = inner.f
            self.inner = inner
            self.uuid = uuid
        }

        public func merge<P>(with other: P) -> Publishers.CZMerge7<A, B, C, D, E, F, P> where P : Publisher, F.Failure == P.Failure, F.Output == P.Output {
            self.visualize()
            return CZMerge7(inner: inner.merge(with: other), uuid: self.uuid)
        }

        public func merge<Z, Y>(with z: Z, _ y: Y) -> Publishers.CZMerge8<A, B, C, D, E, F, Z, Y> where Z : Publisher, Y : Publisher, F.Failure == Z.Failure, F.Output == Z.Output, Z.Failure == Y.Failure, Z.Output == Y.Output {
            self.visualize()
            return CZMerge8(inner: inner.merge(with: z, y), uuid: self.uuid)
        }
    }

    /// A publisher created by applying the merge function to seven upstream publishers.
    public struct CZMerge7<A, B, C, D, E, F, G> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, G : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output, F.Failure == G.Failure, F.Output == G.Output {

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
        
        public let inner: Merge7<A, B, C, D, E, F, G>
        public let uuid: UUID

        public init(inner: Merge7<A, B, C, D, E, F, G>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.d = inner.d
            self.e = inner.e
            self.f = inner.f
            self.g = inner.g
            self.inner = inner
            self.uuid = uuid
        }

        public func merge<P>(with other: P) -> Publishers.CZMerge8<A, B, C, D, E, F, G, P> where P : Publisher, G.Failure == P.Failure, G.Output == P.Output {
            self.visualize()
            return CZMerge8(inner: inner.merge(with: other), uuid: self.uuid)
        }
    }

    /// A publisher created by applying the merge function to eight upstream publishers.
    public struct CZMerge8<A, B, C, D, E, F, G, H> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, F : Publisher, G : Publisher, H : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output, D.Failure == E.Failure, D.Output == E.Output, E.Failure == F.Failure, E.Output == F.Output, F.Failure == G.Failure, F.Output == G.Output, G.Failure == H.Failure, G.Output == H.Output {

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
        
        public let inner: Merge8<A, B, C, D, E, F, G, H>
        public let uuid: UUID

        public init(inner: Merge8<A, B, C, D, E, F, G, H>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.d = inner.d
            self.e = inner.e
            self.f = inner.f
            self.g = inner.g
            self.h = inner.h
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher created by applying the merge function to an arbitrary number of upstream publishers.
    public struct CZMergeMany<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: MergeMany<Upstream>
        public let uuid: UUID
        
        public init(inner: MergeMany<Upstream>, uuid: UUID) {
            self.publishers = inner.publishers
            self.inner = inner
            self.uuid = uuid
        }

        public func merge(with other: Upstream) -> Publishers.CZMergeMany<Upstream> {
            self.visualize()
            return CZMergeMany(inner: inner.merge(with: other), uuid: self.uuid)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.
    public struct CZScan<Upstream, Output> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Scan<Upstream, Output>
        public let uuid: UUID
        
        public init(inner: Publishers.Scan<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.initialResult = inner.initialResult
            self.nextPartialResult = inner.nextPartialResult
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that transforms elements from the upstream publisher by providing the current element to a failable closure along with the last value returned by the closure.
    public struct CZTryScan<Upstream, Output> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryScan<Upstream, Output>
        public let uuid: UUID
        
        public init(inner: TryScan<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.initialResult = inner.initialResult
            self.nextPartialResult = inner.nextPartialResult
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes the number of elements received from the upstream publisher.
    public struct CZCount<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Count<Upstream>
        public let uuid: UUID

        public init(inner: Count<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies a predicate closure.
    public struct CZLastWhere<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: LastWhere<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.LastWhere<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies an error-throwing predicate closure.
    public struct CZTryLastWhere<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryLastWhere<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.TryLastWhere<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that ignores all upstream elements, but passes along the upstream publisher's completion state (finished or failed).
    public struct CZIgnoreOutput<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: IgnoreOutput<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.IgnoreOutput<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
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
    public struct CZSwitchToLatest<P, Upstream> : CZPublisher where P : Publisher, P == Upstream.Output, Upstream : Publisher, P.Failure == Upstream.Failure {

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
        
        public let inner: SwitchToLatest<P, Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.SwitchToLatest<P, Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that attempts to recreate its subscription to a failed upstream publisher.
    public struct CZRetry<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Retry<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.Retry<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.retries = inner.retries
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that converts any failure from the upstream publisher into a new error.
    public struct CZMapError<Upstream, Failure> : CZPublisher where Upstream : Publisher, Failure : Error {

        /// The kind of values published by this publisher.
        ///
        /// This publisher uses its upstream publisher's output type.
        public typealias Output = Upstream.Output

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that converts the upstream failure into a new error.
        public let transform: (Upstream.Failure) -> Failure
        
        public let inner: MapError<Upstream, Failure>
        public let uuid: UUID
        
        public init(inner: Publishers.MapError<Upstream, Failure>, uuid: UUID) {
            self.upstream = inner.upstream
            self.transform = inner.transform
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes either the most-recent or first element published by the upstream publisher in a specified time interval.
    public struct CZThrottle<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: Throttle<Upstream, Context>
        public let uuid: UUID
        
        public init(inner: Publishers.Throttle<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.interval = inner.interval
            self.scheduler = inner.scheduler
            self.latest = inner.latest
            self.inner = inner
            self.uuid = uuid
        }
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
    final public class CZShare<Upstream> : CZPublisher, Equatable where Upstream : Publisher {

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
        
        public let inner: Share<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.Share<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }

        /// Returns a Boolean value that indicates whether two publishers are equivalent.
        /// - Parameters:
        ///   - lhs: A `Share` publisher to compare for equality.
        ///   - rhs: Another `Share` publisher to compare for equality.
        /// - Returns: `true` if the publishers have reference equality (`===`); otherwise `false`.
        public static func == (lhs: Publishers.CZShare<Upstream>, rhs: Publishers.CZShare<Upstream>) -> Bool {
            guard lhs.uuid == rhs.uuid else {
                return false
            }
            return lhs.inner == rhs.inner
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item.
    public struct CZComparison<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Comparison<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.Comparison<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.areInIncreasingOrder = inner.areInIncreasingOrder
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item, and fails if the ordering logic throws an error.
    public struct CZTryComparison<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryComparison<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.TryComparison<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.areInIncreasingOrder = inner.areInIncreasingOrder
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that replaces an empty stream with a provided element.
    public struct CZReplaceEmpty<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: ReplaceEmpty<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.ReplaceEmpty<Upstream>, uuid: UUID) {
            self.output = inner.output
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that replaces any errors in the stream with a provided element.
    public struct CZReplaceError<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: ReplaceError<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.ReplaceError<Upstream>, uuid: UUID) {
            self.output = inner.output
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that raises a fatal error upon receiving any failure, and otherwise republishes all received input.
    ///
    /// Use this function for internal integrity checks that are active during testing but don't affect performance of shipping code.
    public struct CZAssertNoFailure<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: AssertNoFailure<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.AssertNoFailure<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.prefix = inner.prefix
            self.file = inner.file
            self.line = inner.line
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that ignores elements from the upstream publisher until it receives an element from second publisher.
    public struct CZDropUntilOutput<Upstream, Other> : CZPublisher where Upstream : Publisher, Other : Publisher, Upstream.Failure == Other.Failure {

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
        
        public let inner: DropUntilOutput<Upstream, Other>
        public let uuid: UUID
        
        public init(inner: Publishers.DropUntilOutput<Upstream, Other>, uuid: UUID) {
            self.upstream = inner.upstream
            self.other = inner.other
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that performs the specified closures when publisher events occur.
    public struct CZHandleEvents<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: HandleEvents<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.HandleEvents<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.receiveSubscription = inner.receiveSubscription
            self.receiveOutput = inner.receiveOutput
            self.receiveCompletion = inner.receiveCompletion
            self.receiveCancel = inner.receiveCancel
            self.receiveRequest = inner.receiveRequest
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that emits all of one publisher’s elements before those from another publisher.
    public struct CZConcatenate<Prefix, Suffix> : CZPublisher where Prefix : Publisher, Suffix : Publisher, Prefix.Failure == Suffix.Failure, Prefix.Output == Suffix.Output {

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
        
        public let inner: Concatenate<Prefix, Suffix>
        public let uuid: UUID
        
        public init(inner: Publishers.Concatenate<Prefix, Suffix>, uuid: UUID) {
            self.prefix = inner.prefix
            self.suffix = inner.suffix
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes elements only after a specified time interval elapses between events.
    public struct CZDebounce<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: Debounce<Upstream, Context>
        public let uuid: UUID

        public init(inner: Publishers.Debounce<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.dueTime = inner.dueTime
            self.scheduler = inner.scheduler
            self.options = inner.options
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that waits until after the stream finishes, and then publishes the last element of the stream.
    public struct CZLast<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Last<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.Last<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that transforms all elements from the upstream publisher with a provided closure.
    public struct CZMap<Upstream, Output> : CZPublisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher uses its upstream publisher's failure type.
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The closure that transforms elements from the upstream publisher.
        public let transform: (Upstream.Output) -> Output
        
        public let inner: Map<Upstream, Output>
        public let uuid: UUID
        
        public init(inner: Publishers.Map<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.transform = inner.transform
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that transforms all elements from the upstream publisher with a provided error-throwing closure.
    public struct CZTryMap<Upstream, Output> : CZPublisher where Upstream : Publisher {

        /// The kind of errors this publisher might publish.
        ///
        /// This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.
        public typealias Failure = Error

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The error-throwing closure that transforms elements from the upstream publisher.
        public let transform: (Upstream.Output) throws -> Output
        
        public let inner: TryMap<Upstream, Output>
        public let uuid: UUID
        
        public init(inner: Publishers.TryMap<Upstream, Output>, uuid: UUID) {
            self.upstream = inner.upstream
            self.transform = inner.transform
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that terminates publishing if the upstream publisher exceeds a specified time interval without producing an element.
    public struct CZTimeout<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: Timeout<Upstream, Context>
        public let uuid: UUID
        
        public init(inner: Publishers.Timeout<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.interval = inner.interval
            self.scheduler = inner.scheduler
            self.options = inner.options
            self.customError = inner.customError
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that buffers elements from an upstream publisher.
    public struct CZBuffer<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Buffer<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.Buffer<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.size = inner.size
            self.prefetch = inner.prefetch
            self.whenFull = inner.whenFull
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes a given sequence of elements.
    ///
    /// When the publisher exhausts the elements in the sequence, the next request causes the publisher to finish.
    public struct CZSequence<Elements, Failure> : CZPublisher where Elements : Swift.Sequence, Failure : Error {

        /// The kind of values published by this publisher.
        public typealias Output = Elements.Element

        /// The sequence of elements to publish.
        public let sequence: Elements
        
        public let inner: Sequence<Elements, Failure>
        public let uuid: UUID
        
        public init(inner: Publishers.Sequence<Elements, Failure>, uuid: UUID) {
            self.sequence = inner.sequence
            self.inner = inner
            self.uuid = uuid
        }
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
    public struct CZZip<A, B> : CZPublisher where A : Publisher, B : Publisher, A.Failure == B.Failure {

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
        
        public let inner: Zip<A, B>
        public let uuid: UUID
        
        public init(inner: Publishers.Zip<A, B>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher created by applying the zip function to three upstream publishers.
    ///
    /// Use a `Publishers.Zip3` to combine the latest elements from three publishers and emit a tuple to the downstream. The returned publisher waits until all three publishers have emitted an event, then delivers the oldest unconsumed event from each publisher as a tuple to the subscriber.
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    public struct CZZip3<A, B, C> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, B.Failure == C.Failure {

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
        
        public let inner: Zip3<A, B, C>
        public let uuid: UUID
        
        public init(inner: Publishers.Zip3<A, B, C>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher created by applying the zip function to four upstream publishers.
    ///
    /// Use a `Publishers.Zip4` to combine the latest elements from four publishers and emit a tuple to the downstream. The returned publisher waits until all four publishers have emitted an event, then delivers the oldest unconsumed event from each publisher as a tuple to the subscriber.
    ///
    /// If any upstream publisher finishes successfully or fails with an error, so too does the zipped publisher.
    public struct CZZip4<A, B, C, D> : CZPublisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure {

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
        
        public let inner: Zip4<A, B, C, D>
        public let uuid: UUID
        
        public init(inner: Publishers.Zip4<A, B, C, D>, uuid: UUID) {
            self.a = inner.a
            self.b = inner.b
            self.c = inner.c
            self.d = inner.d
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes elements specified by a range in the sequence of published elements.
    public struct CZOutput<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Publishers.Output<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.Output<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.range = inner.range
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
    public struct CZCatch<Upstream, NewPublisher> : CZPublisher where Upstream : Publisher, NewPublisher : Publisher, Upstream.Output == NewPublisher.Output {

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
        
        public let inner: Catch<Upstream, NewPublisher>
        public let uuid: UUID
        
        public init(inner: Publishers.Catch<Upstream, NewPublisher>, uuid: UUID) {
            self.upstream = inner.upstream
            self.handler = inner.handler
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher or producing a new error.
    ///
    /// Because this publisher’s handler can throw an error, ``Publishers/TryCatch`` defines its ``Publisher/Failure`` type as `Error`. This is different from ``Publishers/Catch``, which gets its failure type from the replacement publisher.
    public struct CZTryCatch<Upstream, NewPublisher> : CZPublisher where Upstream : Publisher, NewPublisher : Publisher, Upstream.Output == NewPublisher.Output {

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
        
        public let inner: TryCatch<Upstream, NewPublisher>
        public let uuid: UUID
        
        public init(inner: Publishers.TryCatch<Upstream, NewPublisher>, uuid: UUID) {
            self.upstream = inner.upstream
            self.handler = inner.handler
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that transforms elements from an upstream publisher into a new publisher.
    public struct CZFlatMap<NewPublisher, Upstream> : CZPublisher where NewPublisher : Publisher, Upstream : Publisher, NewPublisher.Failure == Upstream.Failure {

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
        
        public let inner: FlatMap<NewPublisher, Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.FlatMap<NewPublisher, Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.maxPublishers = inner.maxPublishers
            self.transform = inner.transform
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that delays delivery of elements and completion to the downstream receiver.
    public struct CZDelay<Upstream, Context> : CZPublisher where Upstream : Publisher, Context : Scheduler {

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
        
        public let inner: Delay<Upstream, Context>
        public let uuid: UUID
        
        public init(inner: Publishers.Delay<Upstream, Context>, uuid: UUID) {
            self.upstream = inner.upstream
            self.interval = inner.interval
            self.tolerance = inner.tolerance
            self.scheduler = inner.scheduler
            self.options = inner.options
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that omits a specified number of elements before republishing later elements.
    public struct CZDrop<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: Drop<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.Drop<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.count = inner.count
            self.inner = inner
            self.uuid = uuid
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {

    /// A publisher that publishes the first element of a stream, then finishes.
    public struct CZFirst<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: First<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.First<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that only publishes the first element of a stream to satisfy a predicate closure.
    public struct CZFirstWhere<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: FirstWhere<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.FirstWhere<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }

    /// A publisher that only publishes the first element of a stream to satisfy a throwing predicate closure.
    public struct CZTryFirstWhere<Upstream> : CZPublisher where Upstream : Publisher {

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
        
        public let inner: TryFirstWhere<Upstream>
        public let uuid: UUID
        
        public init(inner: Publishers.TryFirstWhere<Upstream>, uuid: UUID) {
            self.upstream = inner.upstream
            self.predicate = inner.predicate
            self.inner = inner
            self.uuid = uuid
        }
    }
}
