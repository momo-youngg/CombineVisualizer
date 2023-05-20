//
//  CombineVisualizer.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/04.
//

import Foundation
import Combine

// MARK: - Common
enum CombineElement {
    case publisher(PublisherMethod)
    case subscriber(SubscriberMethod)
    case subscription(SubscriptionMethod)
    case subject(SubjectMethod)
    
    enum PublisherMethod {
        case receiveSubscriber(String)
    }
    
    enum SubscriberMethod {
        case receiveSubscription(String)
        case receiveInput
        case receiveCompletion
    }
    
    enum SubscriptionMethod {
        case request
        case cancel
    }
    
    enum SubjectMethod {
        case sendOutput
        case sendCompletion
        case sendSubscription
        case receiveSubscriber(String)
    }
}

extension CombineElement {
    func visualize(name: String, uuid: UUID) {
        self.sendToApplication(name: name, uuid: uuid)
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
        self.visualize(method: .receiveSubscriber(String(describing: subscriber).simpleTypeName))
        self.inner.receive(subscriber: czSubscriber)
    }
}

public protocol CZConnectablePublisher: CZPublisher {
    func connect() -> Cancellable
}

extension CZConnectablePublisher where Inner : ConnectablePublisher {
    public func connect() -> Cancellable {
        return self.inner.connect()
    }
    
    public func autoconnect() -> Publishers.CZAutoconnect<Inner> {
        return Publishers.CZAutoconnect<Inner>(inner: self.inner.autoconnect(), uuid: self.uuid)
    }
}

extension CZPublisher {
    func visualize(method: CombineElement.PublisherMethod) {
        CombineElement.publisher(method).visualize(
            name: String(describing: self.inner.self).simpleTypeName,
            uuid: self.uuid
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
        self.visualize(method: .receiveSubscription(String(describing: subscription).simpleTypeName))
        let subscription = CZSubscription(subscription, uuid: self.uuid)
        self.inner.receive(subscription: subscription)
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        self.visualize(method: .receiveInput)
        return self.inner.receive(input)
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        self.visualize(method: .receiveCompletion)
        return self.inner.receive(completion: completion)
    }
}

extension CZSubscriber {
    func visualize(method: CombineElement.SubscriberMethod) {
        CombineElement.subscriber(method).visualize(
            name: String(describing: self.inner.self).simpleTypeName,
            uuid: self.uuid
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
        self.visualize(method: .request)
        self.inner.request(demand)
    }
    
    func cancel() {
        self.visualize(method: .cancel)
        self.inner.cancel()
    }
}

extension CZSubscription {
    func visualize(method: CombineElement.SubscriptionMethod) {
        CombineElement.subscription(method).visualize(
            name: String(describing: self.inner.self).simpleTypeName,
            uuid: self.uuid
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
        self.visualize(method: .sendOutput)
        self.inner.send(value)
    }
    
    public func send(completion: Subscribers.Completion<Inner.Failure>) {
        self.visualize(method: .sendCompletion)
        self.inner.send(completion: completion)
    }
        
    public func send(subscription: Subscription) {
        self.visualize(method: .sendSubscription)
        let czSubscription = CZSubscription(subscription, uuid: self.uuid)
        self.inner.send(subscription: czSubscription)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Inner.Failure == S.Failure, Inner.Output == S.Input {
        self.visualize(method: .receiveSubscriber(String(describing: subscriber).simpleTypeName))
        let czSubscriber = CZSubscriber(subscriber, uuid: self.uuid)
        self.inner.receive(subscriber: czSubscriber)
    }
}

extension CZSubject {
    func visualize(method: CombineElement.SubjectMethod) {
        CombineElement.subject(method).visualize(
            name: String(describing: self.inner.self).simpleTypeName,
            uuid: self.uuid
        )
    }
}

// MARK: - String Extension
extension String {
    fileprivate var simpleTypeName: String {
        guard let parenthesisIndex = self.firstIndex(of: "<") else {
            return self
        }
        return String(self[..<parenthesisIndex])
    }
}
