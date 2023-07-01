//
//  CZSubscription.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/20.
//

import Foundation
import Combine

class CZSubscription : Subscription {
    let inner: Subscription
    let trid: UUID
    
    init(_ inner: Subscription, trid: UUID) {
        self.inner = inner
        self.trid = trid
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
            trid: self.trid
        )
    }
}
