//
//  CombineVisualizerServer.swift
//  CombineVisualizerApplication
//
//  Created by momo on 2023/05/18.
//

import Foundation

final class CombineVisualizerServer {
    static let shared = CombineVisualizerServer()
    private init() { }
    
    func start() {
        let webServer = GCDWebServer()
        webServer.addHandler(
            forMethod: "POST",
            path: "/add",
            request: GCDWebServerDataRequest.self,
            processBlock: { request in
                let body = self.getBody(from: request)
                let result = self.addNewEdge(body)
                return GCDWebServerDataResponse(jsonObject: ["result": result ? "success" : "fail"])
            }
        )
        webServer.start(withPort: 8080, bonjourName: "GCD Web Server")
    }
    
    private func getBody(from request: GCDWebServerRequest) -> [String: Any] {
        guard let dataRequest = request as? GCDWebServerDataRequest,
           let jsonObject = dataRequest.jsonObject,
           let jsonDict = jsonObject as? Dictionary<String, Any> else {
            return [:]
        }
        return jsonDict
    }
    
    private func addNewEdge(_ body: [String: Any]) -> Bool {
        guard let uuid = body["uuid"] as? String,
              let element = body["element"] as? String,
              let elementName = body["elementName"] as? String,
              let queue = body["queue"] as? String,
              let thread = body["thread"] as? String,
              let methodName = body["methodName"] as? String
        else {
            return false
        }
        let methodParameter = body["methodParameter"] as? String ?? ""
        Task { @MainActor in
            CombineManager.shared.add(
                uuid: uuid,
                element: element,
                elementName: elementName,
                queue: queue,
                thread :thread,
                methodName: methodName,
                methodParameter :methodParameter
            )
        }
        return true
    }
}
