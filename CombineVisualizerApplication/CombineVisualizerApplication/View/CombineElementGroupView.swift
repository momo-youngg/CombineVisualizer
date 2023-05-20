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
        Text("Hello, World!")
    }
}

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
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
                                method: .receiveSubscriber("SubscribeOn")
                            ),
                            Edges(
                                sequence: 9,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
                                method: .sendOutput
                            ),
                            Edges(
                                sequence: 12,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
                                method: .sendOutput
                            ),
                            Edges(
                                sequence: 115,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
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
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
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
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
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
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
                                method: .request
                            ),
                            Edges(
                                sequence: 21,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
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
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
                                method: .request
                            ),
                            Edges(
                                sequence: 22,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
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
                                thread: "<NSThread: 0x600001739100>{number = 3, name = (null)}",
                                method: .request
                            ),
                            Edges(
                                sequence: 23,
                                queue: "com.apple.root.utility-qos",
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
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
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
                                method: .receiveSubscription("PassthroughSubject")
                            ),
                            Edges(
                                sequence: 10,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 13,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 16,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
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
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
                                method: .receiveSubscription("SubscribeOn")
                            ),
                            Edges(
                                sequence: 11,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 14,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 18,
                                queue: "com.apple.main-thread",
                                thread: "<_NSMainThread: 0x600001704300>{number = 1, name = main}",
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
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
                                method: .receiveSubscription("ReceiveOn")
                            ),
                            Edges(
                                sequence: 17,
                                queue: "com.apple.root.background-qos",
                                thread: "<NSThread: 0x600001739100>{number = 3, name = (null)}",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 19,
                                queue: "com.apple.root.background-qos",
                                thread: "<NSThread: 0x600001739100>{number = 3, name = (null)}",
                                method: .receiveInput
                            ),
                            Edges(
                                sequence: 20,
                                queue: "com.apple.root.background-qos",
                                thread: "<NSThread: 0x60000173ca00>{number = 2, name = (null)}",
                                method: .receiveInput
                            )
                        ]
                    )
                ]
            )
        )
    }
}
