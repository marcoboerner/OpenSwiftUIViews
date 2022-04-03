//
//  File.swift
//  
//
//  Created by Marco Boerner on 01.04.22.
//

import Foundation
import SwiftUI

// MARK: - Modifiers

public extension View {
    func openAlignSize<T: Hashable>(column: T? = nil, row: T? = nil, _ alignment: Alignment = .center) -> some View {
        modifier(OpenAlignSize(column: column, row: row, alignment: alignment))
    }
}

struct OpenAlignSize<T: Hashable>: ViewModifier {

    internal init(column: T?, row: T?, alignment: Alignment) {
        self.alignment = alignment
        self.column = column
        self.row = row
    }

    private let alignment: Alignment
    private let column: T?
    private let row: T?
    @State private var width: CGFloat?
    @State private var height: CGFloat?
    @EnvironmentObject var openAlignState: OpenAlignState

    func body(content: Content) -> some View {

        content
            .frame(width: width, height: height, alignment: alignment)
            .background(
                GeometryReader { geometry in
                    Color.green
                        .preference(key: OpenAlignPreferenceKey.self, value: [DoubleIdentifiableLocation(id1: column, id2: row, frame: geometry.frame(in: .global))])
                }
            )
            .onReceive(openAlignState.$alignLocations) { alignLocations in

                let filteredVerticalLocations = alignLocations.filter({ column != nil && $0.id1 == column as AnyHashable })
                let filteredHorizontalLocations = alignLocations.filter({ row != nil && $0.id2 == row as AnyHashable })

                width = filteredVerticalLocations.max(by: { $0.frame.width < $1.frame.width })?.frame.width
                height = filteredHorizontalLocations.max(by: { $0.frame.height < $1.frame.height })?.frame.height
            }
    }
}

public extension View {
    func openAlignOffset<T: Hashable>(column: T? = nil, row: T? = nil, _ alignment: Alignment = .center, in coordinateSpace: CoordinateSpace = .global) -> some View {
        modifier(OpenAlignOffset(column: column, row: row, alignment: alignment, coordinateSpace: coordinateSpace))
    }
}

struct OpenAlignOffset<T: Hashable>: ViewModifier {

    internal init(column: T?, row: T?, alignment: Alignment, coordinateSpace: CoordinateSpace) {
        self.alignment = alignment
        self.column = column
        self.row = row
        self.coordinateSpace = coordinateSpace
    }

    let coordinateSpace: CoordinateSpace

    private let alignment: Alignment
    private let column: T?
    private let row: T?
    @State private var newPosition: CGPoint = .zero
    @State private var offset: CGSize = .zero
    @State private var x: CGFloat?
    @State private var y: CGFloat?
    @State private var width: CGFloat?
    @State private var height: CGFloat?
    @EnvironmentObject var openAlignState: OpenAlignState

    func body(content: Content) -> some View {

        content
            .frame(width: width, height: height, alignment: alignment)
            //.position(newPosition)
            .offset(offset)
            .background(
                GeometryReader { geometry in
                    Color.black.opacity(0.1)
                        .onAppear {
                            let localFrame = geometry.frame(in: .local)
                            let otherFrame = geometry.frame(in: coordinateSpace)

                            let localPosition = CGPoint(x: localFrame.midX, y: localFrame.midY)
                            let targetPosition = CGPoint(x: otherFrame.midX, y: otherFrame.midY)

                            newPosition = CGPoint(
                                x: localPosition.x - targetPosition.x + (x ?? targetPosition.x),
                                y: localPosition.y - targetPosition.y + (y ?? targetPosition.y)
                            )

                            offset = CGSize(width: newPosition.x - abs(localPosition.x), height: newPosition.y - abs(localPosition.y))

                            print("||: initial: ", offset)

                        }
                        .onChange(of: geometry.frame(in: coordinateSpace)){ newValue in
                            let localFrame = geometry.frame(in: .local)
                            let otherFrame = geometry.frame(in: coordinateSpace)

                            let localPosition = CGPoint(x: localFrame.midX, y: localFrame.midY)
                            let targetPosition = CGPoint(x: otherFrame.midX, y: otherFrame.midY)

                            newPosition = CGPoint(
                                x: localPosition.x - targetPosition.x + (x ?? targetPosition.x),
                                y: localPosition.y - targetPosition.y + (y ?? targetPosition.y)
                            )

                            offset = CGSize(width: newPosition.x - abs(localPosition.x), height: newPosition.y - abs(localPosition.y))

                            print("||: changed: ", offset)
                        }
                        .preference(key: OpenAlignPreferenceKey.self, value: [DoubleIdentifiableLocation(id1: column, id2: row, frame: geometry.frame(in: coordinateSpace))])
                }
            )
            .onReceive(openAlignState.$alignLocations) { alignLocations in

                let filteredColumnLocations = alignLocations.filter({ column != nil && $0.id1 == column as AnyHashable })
                let filteredRowLocations = alignLocations.filter({ row != nil && $0.id2 == row as AnyHashable })

                switch alignment {
                case .topLeading:
                    x = filteredColumnLocations.min(by: { $0.frame.minX < $1.frame.minX })?.frame.minX
                    y = filteredRowLocations.min(by: { $0.frame.minY < $1.frame.minY })?.frame.minY

                    width = filteredColumnLocations.max(by: { $0.frame.width < $1.frame.width })?.frame.width
                    height = filteredRowLocations.max(by: { $0.frame.height < $1.frame.height })?.frame.height

//                case .leading:


//                case .bottomLeading:
//
//                case .top:
//
//                case .center:
//
//                case .bottom:
//
//                case .topTrailing:
//
//                case .trailing:
//
//                case .bottomTrailing:

                default:
                    return
                }
            }
    }
}
