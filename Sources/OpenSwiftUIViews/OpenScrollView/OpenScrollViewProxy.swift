//
//  OpenScrollViewProxy.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Open Scroll View Proxy

/// Use the proxy to scroll to a specific location.
public struct OpenScrollViewProxy {

    static let openScrollViewCoordinateSpaceName = "OpenScrollView"

    var frames: [AnyHashable: CGRect]
    @ObservedObject var scrollDestination: ScrollDestination

    /// Scrolls to the location of the ID
    /// Set the ID on the views inside the OpenScrollView with the customID modifier.
    public func scrollTo<ID>(_ id: ID, anchor: UnitPoint = .zero) where ID: Hashable {

        guard let frame = frames[id] else { return }

        scrollDestination.setAnchorPoint(frame: frame, anchor: anchor)
    }
}

// MARK: - Location Preference Key

/// Collecting the current frames (locations) from every ID'ed scroll item. Updating while scrolling
struct LocationPreferenceKey: PreferenceKey {
    static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {

        value.merge(nextValue(), uniquingKeysWith: { (oldValue, newValue) in
            return newValue
        })
    }
    static var defaultValue: [AnyHashable: CGRect] = [:]
}

// MARK: - Open Scroll ID

public extension View {
    /// Assign a custom ID to the elements to be used by the OpenScrollViewReader
    func openScrollID<ID>(_ value: ID) -> some View where ID: Hashable {
        modifier(OpenScrollID(value: value))
    }
}

/// Assign a custom ID to the elements to be used by the OpenScrollViewReader
public struct OpenScrollID<ID: Hashable>: ViewModifier {
    public init(value: ID) {
        self.value = value
    }

    var value: ID

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: LocationPreferenceKey.self, value: [value: geometry.frame(in: .named(OpenScrollViewProxy.openScrollViewCoordinateSpaceName))])
                }
            )
    }
}
