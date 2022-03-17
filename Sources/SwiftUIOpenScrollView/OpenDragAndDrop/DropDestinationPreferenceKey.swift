//
//  File.swift
//  
//
//  Created by Marco Boerner on 17.03.22.
//

import SwiftUI

struct OpenDropDestinationPreferenceKey: PreferenceKey {
    static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { (oldValue, newValue) in
            return newValue
        })
    }
    static var defaultValue: [AnyHashable: CGRect] = [:]
}
