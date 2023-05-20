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

extension String {
    var simpleTypeName: String {
        guard let parenthesisIndex = self.firstIndex(of: "<") else {
            return self
        }
        return String(self[..<parenthesisIndex])
    }
}
