//
//  DropDestination.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Drop

public extension View {
    /// Assign a custom ID and activate the element to be used as drop destination
    func dropDestination<ID>(_ value: ID) -> some View where ID: Hashable {
        modifier(OpenDropDestination(value: value))
    }
}

/// Assign a custom ID and activate the element to be used as drop destination
public struct OpenDropDestination<ID: Hashable>: ViewModifier {
    public init(value: ID) {
        self.value = value
    }

    var value: ID

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: OpenDropDestinationPreferenceKey.self,
                            value: [value: geometry.frame(in: .named(OpenDragAndDropProxy.openDragAndDropCoordinateSpaceName))]
                        )
                }
            )
    }
}
