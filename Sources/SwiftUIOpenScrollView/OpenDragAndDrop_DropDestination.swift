//
//  DropDestination.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Drop

struct DropDestinationPreferenceKey: PreferenceKey {
    static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { (oldValue, newValue) in
            return newValue
        })
    }
    static var defaultValue: [AnyHashable: CGRect] = [:]
}

public extension View {
    /// Assign a custom ID and activate the element to be used as drop destination
    func dropDestination<ID>(_ value: ID) -> some View where ID: Hashable {
        modifier(DropDestination(value: value))
    }
}

/// Assign a custom ID and activate the element to be used as drop destination
public struct DropDestination<ID: Hashable>: ViewModifier {
    public init(value: ID) {
        self.value = value
    }

    var value: ID

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: DropDestinationPreferenceKey.self, value: [value: geometry.frame(in: .global)])
                }
            )
    }
}
