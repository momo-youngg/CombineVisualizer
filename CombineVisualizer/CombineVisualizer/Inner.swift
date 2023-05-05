//
//  CombineVisualizer.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/04.
//

import Foundation
import Combine

enum CombineVisualizer {
    private enum Element {
        case publisher, subscriber, subscription
    }
    
    private static func visualize(from element: Element, name: String, uuid: UUID, function: String = #function, message: String = "") {
        // do something
    }
    
    struct _Publisher<Inner: Publisher>: Publisher {
        typealias Output = Inner.Output
        typealias Failure = Inner.Failure
        
        private let inner: Inner
        
        init(_ inner: Inner) {
            self.inner = inner
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let uuid = UUID()
            let subscriber = _Subscriber(subscriber, uuid)
            CombineVisualizer.visualize(from: .publisher, name: String(describing: inner.self), uuid: uuid)
            inner.receive(subscriber: subscriber)
        }
        
    }

    class _Subscriber<Inner: Subscriber>: Subscriber {
        typealias Input = Inner.Input
        typealias Failure = Inner.Failure
        
        private let inner: Inner
        private let uuid: UUID
        
        init(_ inner: Inner, _ uuid: UUID) {
            self.inner = inner
            self.uuid = uuid
        }
        
        func receive(subscription: Subscription) {
            let subscription = _Subscription(subscription, uuid)
            CombineVisualizer.visualize(from: .subscriber, name: String(describing: inner.self), uuid: uuid)
            inner.receive(subscription: subscription)
        }
        
        func receive(_ input: Input) -> Subscribers.Demand {
            CombineVisualizer.visualize(from: .subscriber, name: String(describing: inner.self), uuid: uuid)
            return inner.receive(input)
        }
        
        func receive(completion: Subscribers.Completion<Failure>) {
            CombineVisualizer.visualize(from: .subscriber, name: String(describing: inner.self), uuid: uuid)
            return inner.receive(completion: completion)
        }
    }

    class _Subscription: Subscription {
        private let inner: Subscription
        private let uuid: UUID
        
        init(_ inner: Subscription, _ uuid: UUID) {
            self.inner = inner
            self.uuid = uuid
        }
        
        func request(_ demand: Subscribers.Demand) {
            CombineVisualizer.visualize(from: .subscription, name: String(describing: inner.self), uuid: uuid)
            inner.request(demand)
        }
        
        func cancel() {
            CombineVisualizer.visualize(from: .subscription, name: String(describing: inner.self), uuid: uuid)
            inner.cancel()
        }
    }
}
