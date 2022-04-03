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
    public init(content: @escaping () -> Content) {
        self.content = content
    }

    @State var openAlignState: OpenAlignState = OpenAlignState()

    var content: () -> Content

    public var body: some View {
        return self.content()
            .onPreferenceChange(OpenAlignPreferenceKey.self) { alignLocations in
                self.openAlignState.alignLocations = alignLocations // FIXME: - maybe something is not refreshed right and I need to find out what and where
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

        print("||: pref change: \(nextValue().first?.frame.minY ?? .zero)")

        value.append(contentsOf: nextValue())
    }
    static var defaultValue: [DoubleIdentifiableLocation] = []
}
