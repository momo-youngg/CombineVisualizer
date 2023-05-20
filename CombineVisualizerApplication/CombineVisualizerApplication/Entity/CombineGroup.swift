//
//  CombineGroup.swift
//  CombineVisualizerApplication
//
//  Created by momo on 2023/05/18.
//

import Foundation

struct CombineGroup: Identifiable {
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
    
    var id: UUID {
        uuid
    }
    
    mutating func add(
        elementType: ElementType,
        elementName: String,
        edge: Edges
    ) {
        var isAppended = false
        let newElements = elements.map { element in
            if element.elementType == elementType &&  element.typeName == elementName {
                var element = element
                element.edges.append(edge)
                isAppended = true
                return element
            } else {
                return element
            }
        }
        guard isAppended == false else {
            self.elements = newElements
            return
        }
        self.elements.append(
            CombineElement(
                elementType: elementType,
                typeName: elementName,
                edges: [edge])
        )
    }
}

struct CombineElement: Identifiable {
    let elementType: ElementType
    let typeName: String
    var edges: [Edges]
    
    var id: String {
        "\(elementType)-\(typeName)"
    }
}

enum ElementType {
    case subject
    case publisher
    case subscription
    case subscriber
    
    init?(_ name: String) {
        switch name {
        case "subject":
            self = .subject
        case "publisher":
            self = .publisher
        case "subscription":
            self = .subscription
        case "subscriber":
            self = .subscriber
        default:
            return nil
        }
    }
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
    
    init?(methodName: String, methodParameter: String) {
        switch methodName {
        case "receiveSubscriber":
            self = .receiveSubscriber(methodParameter)
        case "sendOutput":
            self = .sendOutput
        case "sendCompletion":
            self = .sendCompletion
        case "sendSubscription":
            self = .sendSubscription
        case "receiveSubscription":
            self = .receiveSubscription(methodParameter)
        case "receiveInput":
            self = .receiveInput
        case "receiveCompletion":
            self = .receiveCompletion
        case "request":
            self = .request
        case "cancel":
            self = .cancel
        default:
            return nil
        }
    }
    
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
