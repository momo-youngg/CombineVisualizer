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
    case publisher, subscriber, subscription, subject
    
    func visualize(name: String, uuid: UUID, function: String = #function, message: String = "") {
        // do something
        // TODO: visualize 되는 코드들 제대로 확인. 되야 하는 것인지. 필요한 정보는 다 있는지.
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
        let czSubscriber = CZSubscriber(subscriber, uuid: self.uuid)
        self.visualize()
        self.inner.receive(subscriber: czSubscriber)
    }
}

public protocol CZConnectablePublisher: CZPublisher {
    func connect() -> Cancellable
}

extension CZConnectablePublisher where Inner : ConnectablePublisher {
    public func connect() -> Cancellable {
        self.visualize()
        return self.inner.connect()
    }
    
    public func autoconnect() -> Publishers.CZAutoconnect<Inner> {
        self.visualize()
        return Publishers.CZAutoconnect<Inner>(inner: self.inner.autoconnect(), uuid: self.uuid)
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

extension Publisher {
    /// 현재 Publisher가 CZPublisher면 UUID 그대로 이어서, 아니라면 UUID 새로 받아서
    func generateUUID() -> UUID {
        if let czPublisher = self as? any CZPublisher {
            return czPublisher.uuid
        } else {
            return UUID()
        }
    }
}

// MARK: - Subscriber
public class CZSubscriber<Inner: Subscriber> : Subscriber {
    public typealias Input = Inner.Input
    public typealias Failure = Inner.Failure
    
    let inner: Inner
    let uuid: UUID
    
    init(_ inner: Inner, uuid: UUID) {
        self.inner = inner
        self.uuid = uuid
    }
    
    public func receive(subscription: Subscription) {
        let subscription = CZSubscription(subscription, uuid: self.uuid)
        Element.subscriber.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        self.inner.receive(subscription: subscription)
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        Element.subscriber.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        return self.inner.receive(input)
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        Element.subscriber.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        return self.inner.receive(completion: completion)
    }
}

// MARK: - Subscription
class CZSubscription : Subscription {
    let inner: Subscription
    let uuid: UUID
    
    init(_ inner: Subscription, uuid: UUID) {
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

// MARK: - Subject
public protocol CZSubject : Subject {
    associatedtype Inner
    
    var inner: Inner { get }
    var uuid: UUID { get }
    
    init(inner: Inner, uuid: UUID)
}

extension CZSubject where Inner : Subject {
    public func send(_ value: Inner.Output) {
        Element.subject.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        self.inner.send(value)
    }
    
    public func send(completion: Subscribers.Completion<Inner.Failure>) {
        Element.subject.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        self.inner.send(completion: completion)
    }
        
    public func send(subscription: Subscription) {
        Element.subject.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        let czSubscription = CZSubscription(subscription, uuid: self.uuid)
        self.inner.send(subscription: czSubscription)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Inner.Failure == S.Failure, Inner.Output == S.Input {
        Element.subject.visualize(name: String(describing: self.inner.self), uuid: self.uuid)
        let czSubscriber = CZSubscriber(subscriber, uuid: self.uuid)
        self.inner.receive(subscriber: czSubscriber)
    }
}
