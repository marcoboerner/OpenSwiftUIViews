//
//  OpenScrollViewReader.swift
//  SwiftUI_AnimationTest
//
//  Created by Marco Boerner on 03.03.22.
//

import Foundation
import SwiftUI

// MARK: - OpenScrollViewReader

/// Use with OpenScrollView to programmatically scroll to a specific location identified and set with the customID modifier.
public struct OpenScrollViewReader<Content>: View where Content: View {

    public init(content: @escaping (OpenScrollViewProxy) -> Content) {
        self.content = content
    }

    @State var frames: [AnyHashable: CGRect] = [:]
    @State var scrollDestination = ScrollDestination()

    var content: (OpenScrollViewProxy) -> Content

    public var body: some View {

        let customScrollViewProxy = OpenScrollViewProxy(frames: frames, scrollDestination: scrollDestination)

        return self.content(customScrollViewProxy)
            .onPreferenceChange(DestinationPreferenceKey.self) { destination in
                self.scrollDestination = destination
            }
            .onPreferenceChange(LocationPreferenceKey.self) { newFrames in
                self.frames = newFrames
            }
    }
}

/// Use the proxy to scroll to a specific location.
public struct OpenScrollViewProxy {
    static let customScrollViewCoordinateSpaceName = "CustomScrollView"

    @State var frames: [AnyHashable: CGRect]
    @ObservedObject var scrollDestination: ScrollDestination

    /// Scrolls to the location of the ID
    /// Set the ID on the views inside the OpenScrollView with the customID modifier.
    public func scrollTo<ID>(_ id: ID, anchor: UnitPoint = .zero) where ID : Hashable {

        guard let frame = frames[id] else { return }

        let x = frame.minX + (frame.maxX - frame.minX) * anchor.x
        let y = frame.minY + (frame.maxY - frame.minY) * anchor.y

        scrollDestination.frame = frame
        scrollDestination.point = CGPoint(x: x, y: y)
    }
}

struct LocationPreferenceKey: PreferenceKey {
    static func reduce(value: inout [AnyHashable : CGRect], nextValue: () -> [AnyHashable : CGRect]) {

        value.merge(nextValue(), uniquingKeysWith: { (oldValue, newValue) in
            return newValue
        })
    }
    static var defaultValue: [AnyHashable: CGRect] = [:]
}

public extension View {
    /// Assign a custom ID to the elements to be used by the OpenScrollViewReader
    func customID<ID>(_ value: ID) -> some View where ID: Hashable {
        modifier(CustomID(value: value))
    }
}

/// Assign a custom ID to the elements to be used by the OpenScrollViewReader
public struct CustomID<ID: Hashable>: ViewModifier {
    public init(value: ID) {
        self.value = value
    }

    var value: ID

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: LocationPreferenceKey.self, value: [value: geometry.frame(in: .named(OpenScrollViewProxy.customScrollViewCoordinateSpaceName))])
                }
            )
    }
}
