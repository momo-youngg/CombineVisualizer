//
//  CZSubject.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/20.
//

import Foundation
import Combine

public protocol CZSubject : Subject {
    associatedtype Inner
    
    var inner: Inner { get }
    var trid: UUID { get }
    var uuid: UUID { get }
    
    init(inner: Inner, trid: UUID)
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
        let czSubscription = CZSubscription(subscription, trid: self.trid)
        self.inner.send(subscription: czSubscription)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Inner.Failure == S.Failure, Inner.Output == S.Input {
        self.visualize(method: .receiveSubscriber(String(describing: subscriber).simpleTypeName))
        let czSubscriber = CZSubscriber(subscriber, trid: self.trid)
        self.inner.receive(subscriber: czSubscriber)
    }
}

extension CZSubject {
    func visualize(method: CombineElement.SubjectMethod) {
        CombineElement.subject(method).visualize(
            name: String(describing: self.inner.self).simpleTypeName,
            trid: self.trid,
            uuid: self.uuid
        )
    }
}

