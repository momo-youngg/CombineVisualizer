//
//  CZSubscriber.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/20.
//

import Foundation
import Combine

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

