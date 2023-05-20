//
//  CombineManager.swift
//  CombineVisualizerApplication
//
//  Created by momo on 2023/05/20.
//

import Foundation
import Combine

final class CombineManager {
    static let shared = CombineManager()
    private init() { }
    
    @MainActor
    let combineGroupsSubject = CurrentValueSubject<[CombineGroup], Never>([])
    
    @MainActor
    func add(
        uuid: String,
        element: String,
        elementName: String,
        queue: String,
        thread: String,
        methodName: String,
        methodParameter: String
    ) {
        guard let elementType = ElementType(element),
              let method = ElementMethod(
                methodName: methodName,
                methodParameter: methodParameter
              ) else {
            return
        }
        
        var currentGroups = self.combineGroupsSubject.value
        if var existGroup = currentGroups.first(where: { $0.uuid.uuidString == uuid }) {
            let newEdge = Edges(
                sequence: existGroup.totalEdgesCount,
                queue: queue,
                thread: thread,
                method: method
            )
            existGroup.add(
                elementType: elementType,
                elementName: elementName,
                edge: newEdge
            )
            let newGroup = currentGroups.map { group in
                if group.uuid == existGroup.uuid {
                    return existGroup
                } else {
                    return group
                }
            }
            self.combineGroupsSubject.send(newGroup)
        } else {
            let newGroup = CombineGroup(
                uuid: UUID(uuidString: uuid) ?? UUID(),
                elements: [
                    CombineElement(
                        elementType: elementType,
                        typeName: elementName,
                        edges: [
                            Edges(
                                sequence: 0,
                                queue: queue,
                                thread: thread,
                                method: method
                            )
                        ]
                    )
                ]
            )
            currentGroups.append(newGroup)
            self.combineGroupsSubject.send(currentGroups)
        }
    }
}
