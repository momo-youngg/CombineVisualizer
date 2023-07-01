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
    func visualize(name: String, trid: UUID, uuid: UUID) {
        switch CombineVisualizerConfig.outputType {
        case .visualize(_):
            self.sendToApplication(name: name, trid: trid, uuid: uuid)
        case .custom(let outputHandler):
            let outputInfo = OutputType.CustomOutputInfo(
                trid: trid,
                uuid: uuid,
                element: self,
                elementName: name,
                queue: String(cString: __dispatch_queue_get_label(nil)),
                thread: Thread.current.description.threadNumberString,
                methodName: self.method,
                methodParameter: self.method
            )
            outputHandler(outputInfo)
        }
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
