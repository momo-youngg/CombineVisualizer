//
//  SingleCombineElementView.swift
//  CombineVisualizerApplication
//
//  Created by momo on 2023/05/18.
//

import SwiftUI

struct SingleCombineElementView: View {
    private let elementType: ElementType
    private let typeName: String
    private let edges: [Edges]
    private let totalEdgesCount: Int
    private let edgeBySequence: [Int: Edges]
    
    @State private var maxLeftEdgeWidth: CGFloat = .zero
    @State private var maxRightEdgeWidth: CGFloat = .zero
    @State private var edgeTextAreaWidthBySequence: [Int: CGFloat] = [:]
    @State private var titleWidth: CGFloat = .zero
    
    init(_ element: CombineElement, totalEdgesCount: Int) {
        self.elementType = element.elementType
        self.typeName = element.typeName
        self.edges = element.edges
        self.totalEdgesCount = totalEdgesCount
        self.edgeBySequence = element.edges.reduce(into: [:], { $0[$1.sequence] = $1 })
    }
    
    var body: some View {
        VStack(spacing: Constants.titleStickSpacing) {
            self.titleView
            ZStack {
                self.stickView
                self.edgesView
            }
        }
        .fixedSize()
    }
}

// MARK: - views
extension SingleCombineElementView {
    var titleView: some View {
        HStack {
            Spacer()
                .frame(width: self.maxLeftEdgeWidth + Constants.stickWidth / 2 - self.titleWidth / 2)
            Text(self.typeName)
                .font(Constants.titleFont)
                .underline()
                .lineLimit(1)
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                self.titleWidth = proxy.size.width
                            }
                    }
                }
            Spacer()
        }
    }

    var stickView: some View {
        HStack {
            Spacer()
                .frame(width: self.maxLeftEdgeWidth)
            Rectangle()
                .background { Constants.stickColor(self.elementType) }
                .frame(width: Constants.stickWidth, height: self.stickHeight)
            Spacer()
                .frame(width: self.maxRightEdgeWidth)
        }
    }
    
    var edgesView: some View {
        VStack(spacing: Constants.edgeSpacing) {
            ForEach((0..<self.totalEdgesCount), id: \.self) { sequence in
                Group {
                    if let edge = self.edgeBySequence[sequence] {
                        singleEdgeView(edge)
                    } else {
                        Rectangle()
                            .opacity(0)
                    }
                }
                .frame(height: Constants.edgeHeight)
            }
        }
    }
    
    var fromLeftTriangle: some View {
        self.fromRightTriangle
            .rotationEffect(.degrees(180))
    }
    
    var fromRightTriangle: some View {
        GeometryReader { proxy in
            Path { path in
                path.move(to: CGPoint(x: .zero, y: proxy.size.height / 2))
                path.addLine(to: CGPoint(x: proxy.size.width, y: proxy.size.height))
                path.addLine(to: CGPoint(x: proxy.size.width, y: .zero))
                path.addLine(to: CGPoint(x: .zero, y: proxy.size.height / 2))
            }
            .fill(Constants.edgeColor(self.elementType))
        }
        .frame(width: Constants.edgeTriangleWidth)
    }
    
    func singleEdgeView(_ edge: Edges) -> some View {
        HStack {
            let leftSpace: CGFloat = {
                switch direction(of: edge) {
                case .fromRight:
                    return self.maxLeftEdgeWidth + Constants.stickWidth
                case .fromLeft:
                    return self.maxLeftEdgeWidth - Constants.edgeTriangleWidth -
                    (self.edgeTextAreaWidthBySequence[edge.sequence] ?? 0)
                }
            }()
            Spacer()
                .frame(width: leftSpace)
            
            HStack(spacing: .zero) {
                if direction(of: edge) == .fromRight {
                    self.fromRightTriangle
                }
                VStack {
                    Text(edge.method.text)
                        .lineLimit(1)
                    Text(edge.queue)
                        .lineLimit(1)
                    Text(edge.thread)
                        .lineLimit(1)
                }
                .padding(Constants.edgeTextPadding)
                .background {
                    GeometryReader { proxy in
                        Constants.edgeColor(self.elementType)
                            .onAppear {
                                switch direction(of: edge) {
                                case .fromRight:
                                    self.maxRightEdgeWidth = max(self.maxRightEdgeWidth, proxy.size.width + Constants.edgeTriangleWidth)
                                case .fromLeft:
                                    self.maxLeftEdgeWidth = max(self.maxLeftEdgeWidth, proxy.size.width + Constants.edgeTriangleWidth)
                                }
                                self.edgeTextAreaWidthBySequence[edge.sequence] = proxy.size.width
                            }
                    }
                }
                if direction(of: edge) == .fromLeft {
                    self.fromLeftTriangle
                }
            }

            let rightSpace: CGFloat = {
                switch direction(of: edge) {
                case .fromRight:
                    return self.maxRightEdgeWidth - Constants.edgeTriangleWidth -
                    (self.edgeTextAreaWidthBySequence[edge.sequence] ?? 0)
                case .fromLeft:
                    return self.maxRightEdgeWidth + Constants.stickWidth
                }
            }()
            Spacer()
                .frame(width: rightSpace)
        }
    }
}

// MARK: - computed properties or func for view
extension SingleCombineElementView {
    var stickHeight: CGFloat {
        return Constants.edgeHeight * CGFloat(self.totalEdgesCount) +
        Constants.edgeSpacing * CGFloat(self.totalEdgesCount - 1)
    }
    
    func direction(of edge: Edges) -> EdgeViewDirection {
        switch (self.elementType, edge.method) {
        case (.subject, .receiveSubscriber(_)):
            return .fromRight
        case (.subject, _):
            return .fromLeft
        case (.publisher, _):
            return .fromRight
        case (.subscription, _):
            return .fromRight
        case (.subscriber, _):
            return .fromLeft
        }
    }
}

// MARK: - constants
extension SingleCombineElementView {
    struct Constants {
        static let titleFont: Font = .title3
        static let titleStickSpacing: CGFloat = 5
        
        static let edgeHeight: CGFloat = 50
        static let edgeSpacing: CGFloat = 5
        static let edgeTriangleWidth: CGFloat = 20
        static let edgeTextPadding: EdgeInsets = EdgeInsets(
            top: 0,
            leading: 3,
            bottom: 0,
            trailing: 3
        )
        static func edgeColor(_ elementType: ElementType) -> Color {
            switch elementType {
            case .subject:
                return .red
            case .publisher:
                return .red
            case .subscription:
                return .green
            case .subscriber:
                return .blue
            }
        }
        
        static let stickWidth: CGFloat = 5
        static func stickColor(_ elementType: ElementType) -> Color {
            switch elementType {
            case .subject:
                return .red
            case .publisher:
                return .red
            case .subscription:
                return .green
            case .subscriber:
                return .blue
            }
        }
    }
    
    enum EdgeViewDirection {
        case fromLeft
        case fromRight
    }
}

// MARK: - preview
struct SingleCombineElementView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCombineElementView(
            CombineElement(
                elementType: .subject,
                typeName: "SampleSubject",
                edges: [
                    Edges(
                        sequence: 0,
                        queue: "queue 1",
                        thread: "thread 1",
                        method: .receiveSubscriber("SampleSubscriber")
                    ),
                    Edges(
                        sequence: 1,
                        queue: "queue 1",
                        thread: "thread 1",
                        method: .sendOutput
                    ),
                    Edges(
                        sequence: 4,
                        queue: "queue 1",
                        thread: "thread 2",
                        method: .sendCompletion
                    )
                ]
            ),
            totalEdgesCount: 5
        )
    }
}
