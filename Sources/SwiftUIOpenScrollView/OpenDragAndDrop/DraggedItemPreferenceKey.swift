//
//  File.swift
//  
//
//  Created by Marco Boerner on 17.03.22.
//

import SwiftUI

struct OpenDraggedItemPreferenceKey: PreferenceKey {

    static func reduce(value: inout LocationWithID, nextValue: () -> LocationWithID) {
        if nextValue().frame != .zero, nextValue().anchorPoint != .zero {
            value = nextValue()
        }
    }
    static var defaultValue: LocationWithID = LocationWithID()
}
