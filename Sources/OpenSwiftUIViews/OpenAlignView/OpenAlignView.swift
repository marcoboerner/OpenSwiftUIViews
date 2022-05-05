//
//  File.swift
//  
//
//  Created by Marco Boerner on 01.04.22.
//

import Foundation
import SwiftUI
import OrderedCollections


// MARK: - Align View

public struct OpenAlignView<Content>: View where Content: View {
    @inlinable public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    @State private var openAlignState: OpenAlignState = OpenAlignState()

    public var content: () -> Content

    public var body: some View {
        self.content()
            .onPreferenceChange(OpenAlignPreferenceKey.self) { alignLocations in
                self.openAlignState.alignLocations = alignLocations
            }
            .onPreferenceChange(OpenAlignMaxXOffsetsPreferenceKeys.self) { identifiableMaxX in
                // => I might be able to use this here to make sure only the relevant values are published, somehow.
                self.openAlignState.alignedXOffsets[identifiableMaxX.id] = identifiableMaxX.maxX
            }
            .environmentObject(openAlignState)
    }
}

// MARK: - Align State

class OpenAlignState: ObservableObject, Equatable {
    static func == (lhs: OpenAlignState, rhs: OpenAlignState) -> Bool {
        lhs.alignLocations == rhs.alignLocations &&
        lhs.alignedYOffsets == rhs.alignedYOffsets &&
        lhs.alignedXOffsets == rhs.alignedXOffsets
    }

    @Published var alignLocations: [DoubleIdentifiableLocation] = []
    @Published var alignedYOffsets: OrderedDictionary<AnyHashable, CGFloat> = [:]
    @Published var alignedXOffsets: OrderedDictionary<AnyHashable, CGFloat> = [:]
}

// MARK: - Preference key

struct OpenAlignPreferenceKey: PreferenceKey, Equatable {
    static func reduce(value: inout [DoubleIdentifiableLocation], nextValue: () -> [DoubleIdentifiableLocation]) {
        value.append(contentsOf: nextValue())
    }
    static var defaultValue: [DoubleIdentifiableLocation] = []
}

struct OpenAlignMaxXOffsetsPreferenceKeys: PreferenceKey, Equatable {
    static func reduce(value: inout IdentifiableMaxX, nextValue: () -> IdentifiableMaxX) {

        guard nextValue().maxX > 0 else { return value = defaultValue }

        guard nextValue().id == value.id else { return value = nextValue() }

        value = value.maxX > nextValue().maxX ? value : nextValue()


//        guard let nextValue = nextValue().first else { return }
//        value[nextValue.key] = max(nextValue.value, value[nextValue.key] ?? 0)
    }
    static var defaultValue: IdentifiableMaxX = IdentifiableMaxX(id: 999, maxX: 0.0)
}
