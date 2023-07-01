//
//  CombineVisualizerConfig.swift
//  CombineVisualizer
//
//  Created by momo on 2023/05/21.
//

import Foundation

public final class CombineVisualizerConfig {
    static var outputType: OutputType = .visualize(port: "8080")
    static var port: String = "8080"
    public func setOutputType(_ outputType: OutputType) {
        Self.outputType = outputType
        if case .visualize(port: let port) = outputType {
            Self.port = port
        }
    }
}

public enum OutputType {
    case visualize(port: String)
    case custom((CustomOutputInfo) -> Void)
    
    public struct CustomOutputInfo {
        let trid: UUID
        let uuid: UUID
        let element: CombineElement
        let elementName: String
        let queue: String
        let thread: String
        let methodName: String
        let methodParameter: String
    }
}
