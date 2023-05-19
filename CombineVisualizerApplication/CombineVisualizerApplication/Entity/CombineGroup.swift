//
//  CombineGroup.swift
//  CombineVisualizerApplication
//
//  Created by momo on 2023/05/18.
//

import Foundation

struct CombineGroup {
    let uuid: UUID
    var elements: [CombineElement]
    var totalEdgesCount: Int {
        elements.map { $0.edges.count }.reduce(0) { $0 + $1 }
    }
    var subjects: [CombineElement] {
        elements.filter { $0.elementType == .subject }
    }
    var publishers: [CombineElement] {
        elements.filter { $0.elementType == .publisher }
    }
    var subscriptions: [CombineElement] {
        elements.filter { $0.elementType == .subscription }
    }
    var subscribers: [CombineElement] {
        elements.filter { $0.elementType == .subscriber }
    }
}

struct CombineElement {
    let elementType: ElementType
    let typeName: String
    let edges: [Edges]
}

enum ElementType {
    case subject
    case publisher
    case subscription
    case subscriber
}

struct Edges {
    let sequence: Int
    let queue: String
    let thread: String
    let method: ElementMethod
}

enum ElementMethod {
    // Publisher + Subject
    case receiveSubscriber(String)
    // Subject
    case sendOutput
    case sendCompletion
    case sendSubscription
    // Subscriber
    case receiveSubscription(String)
    case receiveInput
    case receiveCompletion
    // Subscription
    case request
    case cancel
    
    var text: String {
        switch self {
        case .receiveSubscriber(let subscriber):
            return "receive(\(subscriber))"
        case .sendOutput:
            return "send(output)"
        case .sendCompletion:
            return "send(completion)"
        case .sendSubscription:
            return "send(subscription)"
        case .receiveSubscription(let subscription):
            return "receive(\(subscription))"
        case .receiveInput:
            return "receive(input)"
        case .receiveCompletion:
            return "receive(completion)"
        case .request:
            return "request(demand)"
        case .cancel:
            return "cancel"
        }
    }
}
