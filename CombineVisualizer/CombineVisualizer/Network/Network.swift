//
//  Network.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/20.
//

import Foundation

fileprivate protocol Methodable {
    var name: String { get }
    var parameter: String? { get }
}

extension CombineElement.PublisherMethod : Methodable {
    fileprivate var name: String {
        switch self {
        case .receiveSubscriber(_):
            return "receiveSubscriber"
        }
    }
    
    fileprivate var parameter: String? {
        switch self {
        case .receiveSubscriber(let parameter):
            return parameter
        }
    }
}

extension CombineElement.SubscriberMethod : Methodable {
    fileprivate var name: String {
        switch self {
        case .receiveSubscription(_):
            return "receiveSubscription"
        case .receiveInput:
            return "receiveInput"
        case .receiveCompletion:
            return "receiveCompletion"
        }
    }
    
    fileprivate var parameter: String? {
        switch self {
        case .receiveSubscription(let parameter):
            return parameter
        default:
            return nil
        }
    }
}

extension CombineElement.SubscriptionMethod : Methodable {
    fileprivate var name: String {
        switch self {
        case .request:
            return "request"
        case .cancel:
            return "cancel"
        }
    }
    
    fileprivate var parameter: String? {
        nil
    }
}

extension CombineElement.SubjectMethod : Methodable {
    fileprivate var name: String {
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
    
    fileprivate var parameter: String? {
        switch self {
        case .receiveSubscriber(let parameter):
            return parameter
        default:
            return nil
        }
    }
}

extension CombineElement {
    fileprivate var name: String {
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
    
    fileprivate var method: String {
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
    
    fileprivate var parameter: String? {
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
        guard let data = try? JSONEncoder().encode(body),
              let url = URL(string: "http://localhost:8080/add") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.uploadTask(with: request, from: data) { (_, _, _) in }.resume()
    }
}

extension String {
    fileprivate var threadNumberString: String {
        let pattern = "number = (?<threadNumber>.+),"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: self, options: [], range: NSRange(self.startIndex..., in: self)),
              let threadNumberRange = Range(match.range(withName: "threadNumber"), in: self) else {
            return ""
        }
        return String(self[threadNumberRange])
    }
}
