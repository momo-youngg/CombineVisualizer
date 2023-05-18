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
            path: "/",
            request: GCDWebServerDataRequest.self,
            processBlock: { request in
                let body = self.getBody(from: request)
                return GCDWebServerDataResponse(jsonObject: body)
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
}
