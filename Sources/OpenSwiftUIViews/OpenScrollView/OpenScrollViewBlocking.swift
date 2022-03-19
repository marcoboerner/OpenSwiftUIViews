//
//  OpenScrollViewBlocking.swift
//  SwiftUI_AnimationTest
//
//  Created by Marco Boerner on 03.03.22.
//

import Foundation
import SwiftUI

// MARK: - Blocking

public extension View {
    /// Pass in a state that is supposed to block the OpenScrollView scrolling.
    func blockScrolling(_ value: Bool) -> some View {
        preference(key: BlockScrollingPreferenceKey.self, value: value)
    }
}

struct BlockScrollingPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}
