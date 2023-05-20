//
//  CombineElementGroupView.swift
//  CombineVisualizerApplication
//
//  Created by momo on 2023/05/20.
//

import SwiftUI

struct CombineElementGroupView: View {
    private let group: CombineGroup
    
    init(group: CombineGroup) {
        self.group = group
    }
    
    var body: some View {
        VStack {
            self.title
            self.combineElementGroupView
        }
    }
}

// MARK: - views
extension CombineElementGroupView {
    var title: some View {
        Text(group.uuid.uuidString)
            .font(.largeTitle)
    }
    
    var combineElementGroupView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Constants.spacingBetweenElementTypes) {
                VStack(spacing: Constants.typeNameSpacing) {
                    Text("Subjects")
                        .font(.title)
                        .foregroundColor(Constants.typeNameColor(.subject))
                    self.combineElementsView(of: self.group.subjects, direction: .fromLeftToRight)
                }
                VStack(spacing: Constants.typeNameSpacing) {
                    Text("Publishers")
                        .font(.title)
                        .foregroundColor(Constants.typeNameColor(.publisher))
                    self.combineElementsView(of: self.group.publishers, direction: .fromRightToLeft)
                }
                VStack(spacing: Constants.typeNameSpacing) {
                    Text("Subscriptions")
                        .font(.title)
                        .foregroundColor(Constants.typeNameColor(.subscription))
                    self.combineElementsView(of: self.group.subscriptions, direction: .fromRightToLeft)
                }
                VStack(spacing: Constants.typeNameSpacing) {
                    Text("Subscribers")
                        .font(.title)
                        .foregroundColor(Constants.typeNameColor(.subscriber))
                    self.combineElementsView(of: self.group.subscribers, direction: .fromLeftToRight)
                }
            }
        }
    }
    
    func combineElementsView(of elements: [CombineElement], direction: ViewDirection) -> some View {
        HStack(spacing: Constants.spacingBetweenElements) {
            let sortedElements = direction == .fromRightToLeft ? elements.reversed() : elements
            ForEach(sortedElements) { element in
                SingleCombineElementView(element, totalEdgesCount: self.group.totalEdgesCount)
            }
        }
    }
}

// MARK: - constants
extension CombineElementGroupView {
    enum Constants {
        static let typeNameSpacing: CGFloat = 10
        static func typeNameColor(_ elementType: ElementType) -> Color {
            switch elementType {
            case .subject:
                return .purple
            case .publisher:
                return .red
            case .subscription:
                return .green
            case .subscriber:
                return .blue
            }
        }
        
        static let spacingBetweenElements: CGFloat = 3
        static let spacingBetweenElementTypes: CGFloat = 3
    }
    
    enum ViewDirection {
        case fromLeftToRight
        case fromRightToLeft
    }
}

// MARK: - preview
struct CombineElementGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CombineElementGroupView(
            group: CombineGroup(
                uuid: UUID(),
                elements: [
                    CombineElement(
                        elementType: .subject,
                        typeName: "Combine.PassthroughSubject",
                        edges: [
                            Edges(
                                sequence: 2,
                                queue: "com.apple.root.utility-qos",
                                thread: "2",
                                method: .receiveSubscriber("SubscribeOn")
                            ),
                            Edges(
                                sequence: 9,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .sendOutput
                            ),
                            Edges(
                                sequence: 12,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .sendOutput
                            ),
                            Edges(
                                sequence: 115,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .sendOutput
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .publisher,
                        typeName: "ReceiveOn",
                        edges: [
                            Edges(
                                sequence: 0,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveSubscriber("Sink")
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .publisher,
                        typeName: "SubscribeOn",
                        edges: [
                            Edges(
                                sequence: 1,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveSubscriber("ReceiveOn")
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .subscription,
                        typeName: "ReceiveOn",
                        edges: [
                            Edges(
                                sequence: 6,
                                queue: "com.apple.root.utility-qos",
                                thread: "2",
                                method: .request
                            ),
                            Edges(
                                sequence: 21,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .cancel
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .subscription,
                        typeName: "SubscribeOn",
                        edges: [
                            Edges(
                                sequence: 7,
                                queue: "com.apple.root.utility-qos",
                                thread: "2",
                                method: .request
                            ),
                            Edges(
                                sequence: 22,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .cancel
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .subscription,
                        typeName: "PassthroughSubject",
                        edges: [
                            Edges(
                                sequence: 8,
                                queue: "com.apple.root.utility-qos",
                                thread: "3",
                                method: .request
                            ),
                            Edges(
                                sequence: 23,
                                queue: "com.apple.root.utility-qos",
                                thread: "2",
                                method: .cancel
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .subscriber,
                        typeName: "SubscribeOn",
                        edges: [
                            Edges(
                                sequence: 3,
                                queue: "com.apple.root.utility-qos",
                                thread: "2",
                                method: .receiveSubscription("PassthroughSubject")
                            ),
                            Edges(
                                sequence: 10,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 13,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 16,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveInput
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .subscriber,
                        typeName: "ReceiveOn",
                        edges: [
                            Edges(
                                sequence: 4,
                                queue: "com.apple.root.utility-qos",
                                thread: "2",
                                method: .receiveSubscription("SubscribeOn")
                            ),
                            Edges(
                                sequence: 11,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 14,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 18,
                                queue: "com.apple.main-thread",
                                thread: "1",
                                method: .receiveInput
                            )
                        ]
                    ),
                    CombineElement(
                        elementType: .subscriber,
                        typeName: "Sink",
                        edges: [
                            Edges(
                                sequence: 5,
                                queue: "com.apple.root.utility-qos",
                                thread: "2",
                                method: .receiveSubscription("ReceiveOn")
                            ),
                            Edges(
                                sequence: 17,
                                queue: "com.apple.root.background-qos",
                                thread: "3",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 19,
                                queue: "com.apple.root.background-qos",
                                thread: "3",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 20,
                                queue: "com.apple.root.background-qos",
                                thread: "2",
                                method: .receiveInput
                            )
                        ]
                    )
                ]
            )
        )
    }
}
