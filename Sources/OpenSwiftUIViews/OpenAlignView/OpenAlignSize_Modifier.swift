//
//  File.swift
//  
//
//  Created by Marco Boerner on 01.04.22.
//

import Foundation
import SwiftUI

// MARK: - Open Align Size

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
                    Color.green.opacity(0.1)
                        .preference(key: OpenAlignPreferenceKey.self, value: [DoubleIdentifiableLocation(id1: column, id2: row, frame: geometry.frame(in: .global))])
                        .onReceive(openAlignState.$alignLocations) { alignLocations in

                            let filteredVerticalLocations = alignLocations.filter({ column != nil && $0.id1 == column as AnyHashable })
                            let filteredHorizontalLocations = alignLocations.filter({ row != nil && $0.id2 == row as AnyHashable })

                            width = filteredVerticalLocations.max(by: { $0.frame.width < $1.frame.width })?.frame.width
                            height = filteredHorizontalLocations.max(by: { $0.frame.height < $1.frame.height })?.frame.height
                        }
                }
            )
    }
}

// MARK: - Open Align Offset

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
    @State private var offset: CGSize = .zero
    @EnvironmentObject var openAlignState: OpenAlignState

    func body(content: Content) -> some View {
        content
            .offset(offset)
            .background(
                GeometryReader { geometry in
                    Color.black.opacity(0.1)
                        .preference(key: OpenAlignPreferenceKey.self, value: [DoubleIdentifiableLocation(id1: column, id2: row, frame: geometry.frame(in: coordinateSpace))])
                        .onReceive(openAlignState.$alignLocations) { alignLocations in
                            offset = getOffset(for: alignLocations, with: geometry, and: alignment)
                        }
                }
            )
    }

    private func getOffset(for alignLocations: [DoubleIdentifiableLocation], with geometry: GeometryProxy, and alignment: Alignment) -> CGSize {

        var valueX: KeyPath<CGRect, CGFloat> = \.midX
        var valueY: KeyPath<CGRect, CGFloat> = \.midY

        // Assigning the CGRect KeyPath determined by the alignement.
        switch alignment {
        case .topLeading:
            valueX = \.minX
            valueY = \.minY
        case .leading:
            valueX = \.minX
        case .bottomLeading:
            valueX = \.minX
            valueY = \.maxY
        case .top:
            valueY = \.minY
        case .bottom:
            valueY = \.maxY
        case .topTrailing:
            valueX = \.maxX
            valueY = \.minY
        case .trailing:
            valueX = \.maxX
        case .bottomTrailing:
            valueX = \.maxX
            valueY = \.maxY
        default:
            break
        }

        // Creating two collections of frames filtered by the id of the rows and columns.
        let xFrames = alignLocations.filter({ column != nil && $0.id1 == column as AnyHashable }).map { $0.frame }
        let yFrames = alignLocations.filter({ row != nil && $0.id2 == row as AnyHashable }).map { $0.frame }

        // Creating the predicate to be used to be used later to get the min or max values of the columns
        let xPredicate: (CGRect, CGRect) -> Bool = { $0[keyPath: valueX] < $1[keyPath: valueX] }
        let yPredicate: (CGRect, CGRect) -> Bool = { $0[keyPath: valueY] < $1[keyPath: valueY] }

        // the either min or max location (frames) of x and y
        var xFrame: CGRect?
        var yFrame: CGRect?

        // using the above predicate to get the individual min or max x or y frame
        switch valueX {
        case \.minX:
            xFrame = xFrames.min(by: xPredicate)
        case \.maxX:
            xFrame = xFrames.max(by: xPredicate)
        default: //midX
            break
        }

        switch valueY {
        case \.minY:
            yFrame = yFrames.min(by: yPredicate)
        case \.maxY:
            yFrame = yFrames.max(by: yPredicate)
        default: //midY
            break
        }

        // from the min or max frame we get the min or max x or y value
        let x = xFrame?[keyPath: valueX]
        let y = yFrame?[keyPath: valueY]

        let localFrame = geometry.frame(in: .local)
        let otherFrame = geometry.frame(in: coordinateSpace)

        let localPosition = CGPoint(x: localFrame[keyPath: valueX], y: localFrame[keyPath: valueY])
        let otherPosition = CGPoint(x: otherFrame[keyPath: valueX], y: otherFrame[keyPath: valueY])

        // getting the position in the other coordinate space relative to the local coordinate space.
        let newPosition = CGPoint(
            x: localPosition.x - otherPosition.x + (x ?? otherPosition.x),
            y: localPosition.y - otherPosition.y + (y ?? otherPosition.y)
        )

        // Calculating and returning the relative offset
        return CGSize(width: newPosition.x - abs(localPosition.x), height: newPosition.y - abs(localPosition.y))

    }
}

// TODO: - Allow the alignment to be set by the OpenAlignView and be inherited, but can be overwritten by the individual modifiers
// TODO: - When having both open align offset and open align size, make it possible that only one of the two need to assign the id (when no id is given.
// TODO: - Can there be a way to auto assign an id if the views are in a 2d grid?
// TODO: - Figure out if I even need a VStack or HStack, could I also use it without as some sort if view builder? I guess I'd need to lay them out first. Could I create a view that internally has a v and h stack, but looks more like:

/*

 OpenAlignView(.topLeading) {
    OpenRow {
        Text1()
            .trailing
        Text2()
            .bottomLeading
        Text3()
    }
    OpenRow {
        TextA()
        TextB()
            .bottomLeading
        TextC()
    }
 */
