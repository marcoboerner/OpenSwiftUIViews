//
//  OpenDragPreferenceKey.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

struct OpenDragPreferenceKey: PreferenceKey, Equatable {
    static func reduce(value: inout IdentifiableLocation, nextValue: () -> IdentifiableLocation) {
        if nextValue().frame != .zero {
            value = nextValue()
        }
    }
    static var defaultValue: IdentifiableLocation = IdentifiableLocation()
}
