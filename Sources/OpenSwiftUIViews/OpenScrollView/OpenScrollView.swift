//
//  OpenScrollView.swift
//  SwiftUI_AnimationTest
//
//  Created by Marco Boerner on 03.03.22.
//

import Foundation
import SwiftUI

internal struct K {
    static let openScrollViewCoordinateSpaceName: String = "OpenScrollView"
}

struct DestinationPreferenceKey: PreferenceKey {
    static func reduce(value: inout ScrollDestination, nextValue: () -> ScrollDestination) {}
    static var defaultValue: ScrollDestination = ScrollDestination()
}

// MARK: - OpenScrollView

/// Use this ScrolLView to prevent other gestures from blocking or being blocked by default.
/// Clipping is deactivated by default and not all ScrollView features are implemented or will behave the same.
public struct OpenScrollView<Content>: View where Content: View {
    public init(_ axes: Axis.Set = .vertical, content: @escaping () -> Content) {
        self.axes = axes
        self.content = content
    }

    /// The current offset of the view content
    @State private var offset: CGSize = .zero
    /// The accumulated offset, set when the scrolling ends.
    @State private var accumulatedOffset: CGSize = .zero
    /// Set to true when another gesture contained in the scroll view needs to block this views gestures.
    @State private var scrollingIsBlocked = false

    @State private var innerGeometrySize: CGSize = .zero

    @State private var outerGeometrySize: CGSize = .zero

    /// The scroll direction, supported are vertical and horizontal or both.
    private var axes: Axis.Set

    /// This parameter is changed through the proxy and the goTo method.
    @State private var scrollDestination = ScrollDestination()

    var content: () -> Content

    public var body: some View {

        // FIXME: - I need to find a way to not have the geometry reader change the view. Otherwise the outer reader is gonna make the view use all available space.

        // An outer geometry ...
        GeometryReader { outerGeometry in
            self.content()
                .onChange(of: outerGeometry.size) { newSize in
                    outerGeometrySize = newSize
                }
                .contentShape(Rectangle())
            // ... and inner geometry is used to calculate the final extreme positions of the view ...
                .background(GeometryReader { innerGeometry in
                    Color.clear
                        .onChange(of: innerGeometry.size) { newSize in
                            innerGeometrySize = newSize
                        }
                })
            // The actual offset of the view is applied here, depending on the axis.
                .offset(x: axes.contains(.horizontal) ? accumulatedOffset.width + offset.width : 0, y: axes.contains(.vertical) ? accumulatedOffset.height + offset.height : 0)
            // Scrolling is triggered by the proxy's goTo method
                .onReceive(scrollDestination.$anchorPoint) { anchorPoint in
                    accumulatedOffset.height -= anchorPoint.y
                    accumulatedOffset.width -= anchorPoint.x
                }
                .preference(key: DestinationPreferenceKey.self, value: scrollDestination)
            // Blocking is set by the blocking modifier
                .onPreferenceChange(BlockScrollingPreferenceKey.self) { blockScrolling in
                    self.scrollingIsBlocked = blockScrolling
                }
            // The scrolling of this view needs to be simultaneous of other gestures to not block other gestures by default.
                .simultaneousGesture(
                    // The minimum distance can be changed depending on the needs. 10 worked good so far.
                    DragGesture(minimumDistance: 10.0)
                        .onChanged { gesture in
                            offset = scrollingIsBlocked ? .zero : gesture.translation
                        }
                        .onEnded { gesture in
                            // Animating the end of scrolling, keep scrolling if velocity was high
                            withAnimation(.easeOut(duration: 0.6)) {
                                offset = scrollingIsBlocked ? .zero : gesture.predictedEndTranslation
                            }
                            // this doesn't need to be animated as this is just setting the same values as above for the next scrolling gesture
                            accumulatedOffset.height += offset.height
                            accumulatedOffset.width += offset.width
                            offset = .zero

                            // ... in order to bounce back to the most outside view here ...
                            // bounce back to the top, also if the view does not have enough items to fill the scroll view.
                            if accumulatedOffset.height > 0 || innerGeometrySize.height <= outerGeometrySize.height {
                                withAnimation(.spring()) {
                                    accumulatedOffset.height = 0
                                }
                                // bounce to the bottom
                            } else if abs(accumulatedOffset.height) > innerGeometrySize.height - outerGeometrySize.height {
                                withAnimation(.spring()) {
                                    accumulatedOffset.height = -1*(innerGeometrySize.height - outerGeometrySize.height)
                                }
                            }
                            // ... and here.
                            if accumulatedOffset.width > 0 {
                                withAnimation(.spring()) {
                                    accumulatedOffset.width = 0
                                }
                            } else if abs(accumulatedOffset.width) > innerGeometrySize.width - outerGeometrySize.width {
                                withAnimation(.spring()) {
                                    accumulatedOffset.width = -1*(innerGeometrySize.width - outerGeometrySize.width)
                                }
                            }
                        }
                )
        }
        .coordinateSpace(name: K.openScrollViewCoordinateSpaceName)
    }
}
