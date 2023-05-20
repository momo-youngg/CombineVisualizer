//
//  CZPublisher.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/20.
//

import Foundation
import Combine

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
