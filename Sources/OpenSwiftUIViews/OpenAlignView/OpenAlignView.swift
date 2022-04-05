//
//  File.swift
//  
//
//  Created by Marco Boerner on 01.04.22.
//

import Foundation
import SwiftUI


// MARK: - Align View

public struct OpenAlignView<Content>: View where Content: View {
    @inlinable public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    @State var openAlignState: OpenAlignState = OpenAlignState()

    public var content: () -> Content

    public var body: some View {
        self.content()
            .onPreferenceChange(OpenAlignPreferenceKey.self) { alignLocations in
                self.openAlignState.alignLocations = alignLocations
            }
            .environmentObject(openAlignState)
    }
}

// MARK: - Align State

class OpenAlignState: ObservableObject, Equatable {
    static func == (lhs: OpenAlignState, rhs: OpenAlignState) -> Bool {
        lhs.alignLocations == rhs.alignLocations
    }

    @Published var alignLocations: [DoubleIdentifiableLocation] = []
}

// MARK: - Preference key

struct OpenAlignPreferenceKey: PreferenceKey, Equatable {
    static func reduce(value: inout [DoubleIdentifiableLocation], nextValue: () -> [DoubleIdentifiableLocation]) {
        value.append(contentsOf: nextValue())
    }
    static var defaultValue: [DoubleIdentifiableLocation] = []
}
