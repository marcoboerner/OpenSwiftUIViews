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
    static func reduce(value: inout ScrollDestination, nextValue: () -> ScrollDestination) {
        value = nextValue()
    }
    static var defaultValue: ScrollDestination = ScrollDestination()
}

// MARK: - Initialization and variables

/// Use this ScrolLView to prevent other gestures from blocking or being blocked by default.
/// Clipping is deactivated by default and not all ScrollView features are implemented or will behave the same.
public struct OpenScrollView<Content>: View where Content: View {

    public init(_ axes: Axis.Set = .vertical, content: @escaping () -> Content) {
        self.axes = axes
        self.content = content
    }

    /// The scroll direction, supported are vertical and horizontal or both.
    private var axes: Axis.Set

    var content: () -> Content

    /// The current offset of the view content
    @State private var heightOffset: CGFloat = .zero
    @State private var widthOffset: CGFloat = .zero
    /// The accumulated offset, set when the scrolling ends.
    @State private var accumulatedHeightOffset: CGFloat = .zero
    @State private var accumulatedWidthOffset: CGFloat = .zero

    /// Set to true when another gesture contained in the scroll view needs to block this views gestures.
    @State private var scrollingIsBlocked = false

    @State private var innerGeometrySize: CGSize = .zero
    @State private var outerGeometrySize: CGSize = .zero

    /// This parameter is changed through the proxy and the goTo method.
    @State private var scrollDestination = ScrollDestination()

}


extension OpenScrollView {

    public var body: some View {

        // FIXME: - I need to find a way to not have the geometry reader change the view. Otherwise the outer reader is gonna make the view use all available space.

        // An outer geometry ...
        GeometryReader { outerGeometry in
            self.content()
                .onChange(of: outerGeometry.size) { outerGeometrySize = $0 }
                .contentShape(Rectangle())
            // ... and inner geometry is used to calculate the final extreme positions of the view ...
                .background(GeometryReader { innerGeometry in
                    Color.clear
                        .onChange(of: innerGeometry.size) { innerGeometrySize = $0 }
                })
            // The actual offset of the view is applied here, depending on the axis.
                .offset(x: axes.contains(.horizontal) ? accumulatedWidthOffset + widthOffset : 0, y: axes.contains(.vertical) ? accumulatedHeightOffset + heightOffset : 0)
            // Scrolling is triggered by the proxy's goTo method
                .onReceive(scrollDestination.$anchorPoint) { anchorPoint in

                    print(accumulatedHeightOffset, anchorPoint.y)

                    accumulatedHeightOffset -= anchorPoint.y
                    accumulatedHeightOffset -= anchorPoint.x

                    print(accumulatedHeightOffset)
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
                            heightOffset = scrollingIsBlocked ? .zero : gesture.translation.height
                            widthOffset = scrollingIsBlocked ? .zero : gesture.translation.width
                        }
                        .onEnded { gesture in
                            // Animating the end of scrolling, keep scrolling if velocity was high
                            withAnimation(.easeOut(duration: 0.6)) {
                                heightOffset = scrollingIsBlocked ? .zero : gesture.predictedEndTranslation.height
                                widthOffset = scrollingIsBlocked ? .zero : gesture.predictedEndTranslation.width
                            }
                            // this doesn't need to be animated as this is just setting the same values as above for the next scrolling gesture
                            accumulatedHeightOffset += heightOffset
                            accumulatedWidthOffset += widthOffset
                            heightOffset = .zero
                            widthOffset = .zero
                            bounceBackHeight()
                            bounceBackWidth()
                        }
                )
        }
        .coordinateSpace(name: K.openScrollViewCoordinateSpaceName)
    }
}

// MARK: - End of view bouncing

extension OpenScrollView {

    private func bounceBackHeight() {
        // ... in order to bounce back to the most outside view here ...
        // bounce back to the top, also if the view does not have enough items to fill the scroll view.
        if accumulatedHeightOffset > 0 || innerGeometrySize.height <= outerGeometrySize.height {
            withAnimation(.spring()) {
                accumulatedHeightOffset = 0
            }
            // bounce to the bottom
        } else if abs(accumulatedHeightOffset) > innerGeometrySize.height - outerGeometrySize.height {
            withAnimation(.spring()) {
                accumulatedHeightOffset = -1*(innerGeometrySize.height - outerGeometrySize.height)
            }
        }
    }

    private func bounceBackWidth() {
        // ... and here.
        if accumulatedWidthOffset > 0 {
            withAnimation(.spring()) {
                accumulatedWidthOffset = 0
            }
        } else if abs(accumulatedWidthOffset) > innerGeometrySize.width - outerGeometrySize.width {
            withAnimation(.spring()) {
                accumulatedWidthOffset = -1*(innerGeometrySize.width - outerGeometrySize.width)
            }
        }
    }
}
