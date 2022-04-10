//
//  File.swift
//  
//
//  Created by Marco Boerner on 06.04.22.
//

import Foundation
import SwiftUI

// MARK: - Open Align Offset

public extension View {
    func openAlignOffset<T: Hashable>(column: T? = nil, minColumnSpacing: CGFloat? = 10, row: T? = nil, minRowSpacing: CGFloat? = 10, _ alignment: Alignment = .center, in coordinateSpace: CoordinateSpace = .global) -> some View {
        modifier(OpenAlignOffset(column: column, minColumnSpacing: minColumnSpacing, row: row, minRowSpacing: minRowSpacing, alignment: alignment, coordinateSpace: coordinateSpace))
    }
}

struct OpenAlignOffset<T: Hashable>: ViewModifier {

    internal init(column: T?, minColumnSpacing: CGFloat?, row: T?, minRowSpacing: CGFloat?, alignment: Alignment, coordinateSpace: CoordinateSpace) {
        self.alignment = alignment
        self.column = column
        self.row = row
        self.minColumnSpacing = minColumnSpacing
        self.minRowSpacing = minRowSpacing
        self.coordinateSpace = coordinateSpace
    }

    let coordinateSpace: CoordinateSpace

    private let alignment: Alignment
    private let column: T?
    private let row: T?
    private let minColumnSpacing: CGFloat?
    private let minRowSpacing: CGFloat?
    @State private var offset: CGSize = .zero
    private var offsetMaxX: CGFloat = .zero
    @EnvironmentObject var openAlignState: OpenAlignState

    func body(content: Content) -> some View {
        content
//            .background(
//                GeometryReader { geometry in
//                    Color.blue.opacity(0.2)
//                        .preference(
//                            key: OpenAlignMaxXOffsetsPreferenceKeys.self,
//                            value: IdentifiableMaxX(id: column, maxX: geometry.frame(in: coordinateSpace).maxX)
//                        )
//                }
//            )
            .offset(offset)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: OpenAlignPreferenceKey.self, value: [DoubleIdentifiableLocation(id1: column, id2: row, frame: geometry.frame(in: coordinateSpace))])
//                        .preference(
//                            key: OpenAlignMaxXOffsetsPreferenceKeys.self,
//                            value: IdentifiableMaxX(id: column, maxX: geometry.frame(in: coordinateSpace).maxX)
//                        )
                        .onReceive(openAlignState.$alignLocations) { alignLocations in
                            offset = getOffset(for: alignLocations, with: geometry, alignment: alignment, column: column, row: row)
                        }
//                        .onReceive(openAlignState.$alignedXOffsets) { alignedXOffsets in
//
//                        }
                }
            )
    }
}
