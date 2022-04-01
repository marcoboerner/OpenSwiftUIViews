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
    func openAlign<T: Hashable>(column: T? = nil, row: T? = nil, _ alignment: Alignment = .center) -> some View {
        modifier(OpenAlign(column: column, row: row, alignment: alignment))
    }
}

struct OpenAlign<T: Hashable>: ViewModifier {

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

// MARK: - Align State

class OpenAlignState: ObservableObject, Equatable {
    static func == (lhs: OpenAlignState, rhs: OpenAlignState) -> Bool {
        lhs.alignLocations == rhs.alignLocations
    }

    @Published var alignLocations: [DoubleIdentifiableLocation] = []
}

// MARK: - Align View

public struct OpenAlignView<Content>: View where Content: View {
    public init(content: @escaping () -> Content) {
        self.content = content
    }

    @State var openAlignState: OpenAlignState = OpenAlignState()

    var content: () -> Content

    public var body: some View {
        return self.content()
            .onPreferenceChange(OpenAlignPreferenceKey.self) { alignLocations in
                self.openAlignState.alignLocations = alignLocations
            }
            .environmentObject(openAlignState)
    }
}

// MARK: - Preference key

struct OpenAlignPreferenceKey: PreferenceKey, Equatable {
    static func reduce(value: inout [DoubleIdentifiableLocation], nextValue: () -> [DoubleIdentifiableLocation]) {
        value.append(contentsOf: nextValue())
    }
    static var defaultValue: [DoubleIdentifiableLocation] = []
}
