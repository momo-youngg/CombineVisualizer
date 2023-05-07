//
//  CombineVisualizer.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/04.
//

import Foundation
import Combine

// MARK: - Common
enum Element {
    case publisher, subscriber, subscription
    
    func visualize(name: String, uuid: UUID, function: String = #function, message: String = "") {
        // do something
    }
}

// MARK: - Publisher
public protocol CZPublisher : Publisher {
    associatedtype Inner

    var inner: Inner { get }
    var uuid: UUID { get }
    
    init(inner: Inner, uuid: UUID)
}

extension CZPublisher where Inner : Publisher {
    public func receive<S>(subscriber: S) where S : Subscriber, Inner.Failure == S.Failure, Inner.Output == S.Input {
        let inner = CZSubscriber(subscriber, self.uuid)
        self.visualize()
        self.inner.receive(subscriber: subscriber)
    }
}

public protocol CZConnectablePublisher: CZPublisher {
    func connect() -> Cancellable
}

extension CZConnectablePublisher where Inner : ConnectablePublisher {
    public func connect() -> Cancellable {
        visualize()
        return self.inner.connect()
    }
    
    public func autoconnect() -> Publishers.CZAutoconnect<Inner> {
        visualize()
        return Publishers.CZAutoconnect(inner: self.inner.autoconnect(), uuid: self.uuid)
    }
}

extension CZPublisher {
    func visualize() {
        Element.publisher.visualize(
            name: String(describing: self.inner.self),
            uuid: self.uuid
        )
    }
}

// MARK: - Subscriber
class CZSubscriber<Inner: Subscriber> : Subscriber {
    typealias Input = Inner.Input
    typealias Failure = Inner.Failure
    
    private let inner: Inner
    private let uuid: UUID
    
    init(_ inner: Inner, _ uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }
    
    func receive(subscription: Subscription) {
        let subscription = CZSubscription(subscription, self.uuid)
        Element.subscriber.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        self.inner.receive(subscription: subscription)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        Element.subscriber.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        return self.inner.receive(input)
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        Element.subscriber.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        return self.inner.receive(completion: completion)
    }
}

// MARK: - Subscription
class CZSubscription : Subscription {
    private let inner: Subscription
    private let uuid: UUID
    
    init(_ inner: Subscription, _ uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }
    
    func request(_ demand: Subscribers.Demand) {
        Element.subscription.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        self.inner.request(demand)
    }
    
    func cancel() {
        Element.subscription.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        self.inner.cancel()
    }
}
