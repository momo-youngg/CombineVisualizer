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
        let queueName = String(cString: __dispatch_queue_get_label(nil))
        let thread = Thread.current.description
        print("########## \(uuid) \(self) \(name) \(function) \(message) \(queueName) \(thread)")
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
    func visualize(function: String = #function) {
        let fullName = String(describing: self.inner.self)
        let simpleName: String = {
            guard let parenthesisIndex = fullName.firstIndex(of: "<") else {
                return fullName
            }
            return String(fullName[..<parenthesisIndex])
        }()
        Element.publisher.visualize(
            name: simpleName,
            uuid: self.uuid,
            function: function
        )
    }
}

extension Publisher {
    /// 현재 Publisher가 CZPublisher면 UUID 그대로 이어서, 아니라면 UUID 새로 받아서
    func generateUUID() -> UUID {
        if let czPublisher = self as? any CZPublisher {
            return czPublisher.uuid
        } else if let czSubject = self as? any CZSubject {
            return czSubject.uuid
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
        self.visualize()
        let subscription = CZSubscription(subscription, uuid: self.uuid)
        self.inner.receive(subscription: subscription)
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        self.visualize()
        return self.inner.receive(input)
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        self.visualize()
        return self.inner.receive(completion: completion)
    }
}

extension CZSubscriber {
    func visualize(function: String = #function) {
        let fullName = String(describing: self.inner.self)
        let simpleName: String = {
            guard let parenthesisIndex = fullName.firstIndex(of: "<") else {
                return fullName
            }
            return String(fullName[..<parenthesisIndex])
        }()
        Element.subscriber.visualize(
            name: simpleName,
            uuid: self.uuid,
            function: function
        )
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
        self.visualize()
        self.inner.request(demand)
    }
    
    func cancel() {
        self.visualize()
        self.inner.cancel()
    }
}

extension CZSubscription {
    func visualize(function: String = #function) {
        let fullName = String(describing: self.inner.self)
        let simpleName: String = {
            guard let parenthesisIndex = fullName.firstIndex(of: "<") else {
                return fullName
            }
            return String(fullName[..<parenthesisIndex])
        }()
        Element.subscription.visualize(
            name: simpleName,
            uuid: self.uuid,
            function: function
        )
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
        self.visualize()
        self.inner.send(value)
    }
    
    public func send(completion: Subscribers.Completion<Inner.Failure>) {
        self.visualize()
        self.inner.send(completion: completion)
    }
        
    public func send(subscription: Subscription) {
        self.visualize()
        let czSubscription = CZSubscription(subscription, uuid: self.uuid)
        self.inner.send(subscription: czSubscription)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Inner.Failure == S.Failure, Inner.Output == S.Input {
        self.visualize()
        let czSubscriber = CZSubscriber(subscriber, uuid: self.uuid)
        self.inner.receive(subscriber: czSubscriber)
    }
}

extension CZSubject {
    func visualize(function: String = #function) {
        let fullName = String(describing: self.inner.self)
        let simpleName: String = {
            guard let parenthesisIndex = fullName.firstIndex(of: "<") else {
                return fullName
            }
            return String(fullName[..<parenthesisIndex])
        }()
        Element.subject.visualize(
            name: simpleName,
            uuid: self.uuid,
            function: function
        )
    }
}
