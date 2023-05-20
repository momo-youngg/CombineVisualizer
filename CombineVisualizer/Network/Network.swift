//
//  Network.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/20.
//

import Foundation

protocol Methodable {
    var name: String { get }
    var parameter: String? { get }
}

extension CombineElement.PublisherMethod : Methodable {
    var name: String {
        switch self {
        case .receiveSubscriber(_):
            return "receiveSubscriber"
        }
    }
    
    var parameter: String? {
        switch self {
        case .receiveSubscriber(let parameter):
            return parameter
        }
    }
}

extension CombineElement.SubscriberMethod : Methodable {
    var name: String {
        switch self {
        case .receiveSubscription(_):
            return "receiveSubscription"
        case .receiveInput:
            return "receiveInput"
        case .receiveCompletion:
            return "receiveCompletion"
        }
    }
    
    var parameter: String? {
        switch self {
        case .receiveSubscription(let parameter):
            return parameter
        default:
            return nil
        }
    }
}

extension CombineElement.SubscriptionMethod : Methodable {
    var name: String {
        switch self {
        case .request:
            return "request"
        case .cancel:
            return "cancel"
        }
    }
    
    var parameter: String? {
        nil
    }
}

extension CombineElement.SubjectMethod : Methodable {
    var name: String {
        switch self {
        case .sendOutput:
            return "sendOutput"
        case .sendCompletion:
            return "sendCompletion"
        case .sendSubscription:
            return "sendSubscription"
        case .receiveSubscriber(_):
            return "receiveSubscriber"
        }
    }
    
    var parameter: String? {
        switch self {
        case .receiveSubscriber(let parameter):
            return parameter
        default:
            return nil
        }
    }
}

extension CombineElement {
    var name: String {
        switch self {
        case .publisher(_):
            return "publisher"
        case .subscriber(_):
            return "subscriber"
        case .subscription(_):
            return "subscription"
        case .subject(_):
            return "subject"
        }
    }
    
    var method: String {
        switch self {
        case .publisher(let publisherMethod):
            return publisherMethod.name
        case .subscriber(let subscriberMethod):
            return subscriberMethod.name
        case .subscription(let subscriptionMethod):
            return subscriptionMethod.name
        case .subject(let subjectMethod):
            return subjectMethod.name
        }
    }
    
    var parameter: String? {
        switch self {
        case .publisher(let publisherMethod):
            return publisherMethod.parameter
        case .subscriber(let subscriberMethod):
            return subscriberMethod.parameter
        case .subscription(_):
            return nil
        case .subject(let subjectMethod):
            return subjectMethod.parameter
        }
    }
}

extension CombineElement {
    func sendToApplication(name: String, uuid: UUID) {
        let element = self.name
        let queue = String(cString: __dispatch_queue_get_label(nil))
        let thread = Thread.current.description.threadNumberString
        let method = self.method
        let parameter = self.parameter ?? ""
        let body: [String: String] = [
            "uuid": uuid.uuidString,
            "element": element,
            "elementName": name,
            "queue": queue,
            "thread": thread,
            "methodName": method,
            "methodParameter": parameter
        ]
        let port = CombineVisualizerConfig.port
        guard let data = try? JSONEncoder().encode(body),
              let url = URL(string: "http://localhost:\(port)/add") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.uploadTask(with: request, from: data) { (_, _, _) in }.resume()
    }
}

extension String {
    var threadNumberString: String {
        let pattern = "number = (?<threadNumber>.+),"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: self, options: [], range: NSRange(self.startIndex..., in: self)),
              let threadNumberRange = Range(match.range(withName: "threadNumber"), in: self) else {
            return ""
        }
        return String(self[threadNumberRange])
    }
}
