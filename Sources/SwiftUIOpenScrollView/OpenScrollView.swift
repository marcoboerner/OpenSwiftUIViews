//
//  OpenScrollView.swift
//  SwiftUI_AnimationTest
//
//  Created by Marco Boerner on 03.03.22.
//

import Foundation
import SwiftUI

struct DestinationPreferenceKey: PreferenceKey {
    static func reduce(value: inout Location, nextValue: () -> Location) {}
    static var defaultValue: Location = Location()
}

// MARK: - OpenScrollView

/// Use this ScrolLView to prevent other gestures from blocking of being blocked by default.
/// Clipping is deactivated by default and not all ScrollView features are implemented or will behave the same.
public struct OpenScrollView<Content>: View where Content: View {
    public init(content: @escaping () -> Content) {
        self.content = content
    }

    /// The current offset of the view content
    @State private var offset: CGSize = .zero
    /// The accumulated offset, set when the scrolling ends.
    @State private var accumulatedOffset: CGSize = .zero
    /// Set to true when another gesture contained in the scroll view needs to block this views gestures.
    @State private var scrollingIsBlocked = false

    /// The scroll direction, supported are vertical and horizontal or both.
    @State var axis: Axis.Set = [.vertical]

    /// This parameter is changed through the proxy and the goTo method.
    @State private var scrollDestination = Location()

    var content: () -> Content

    public var body: some View {

        // An outer geometry ...
        GeometryReader { outerGeometry in
            self.content()
                .contentShape(Rectangle())
                // ... and inner geometry is used to calculate the final extreme positions of the view ...
                .background(GeometryReader { innerGeometry in
                    EmptyView()

                        // ... in order to bounce back to the most outside view here ...
                        .onChange(of: accumulatedOffset.height) { _ in
                            // bounce back to the top, also if the view does not have enough items to fill the scroll view.
                            if accumulatedOffset.height > 0 || innerGeometry.size.height <= outerGeometry.size.height {
                                accumulatedOffset.height = 0
                            // bounce to the bottom
                            } else if abs(accumulatedOffset.height) > innerGeometry.size.height - outerGeometry.size.height {
                                accumulatedOffset.height = -1*(innerGeometry.size.height - outerGeometry.size.height)
                            }
                        }
                    // ... and here.
                        .onChange(of: accumulatedOffset.width) { _ in
                            if accumulatedOffset.width > 0 {
                                accumulatedOffset.width = 0
                            } else if abs(accumulatedOffset.width) > innerGeometry.size.width - outerGeometry.size.width {
                                accumulatedOffset.width = -1*(innerGeometry.size.width - outerGeometry.size.width)
                            }
                        }
                })
                // The actual offset of the view is applied here, depending on the axis.
                .offset(x: axis.contains(.horizontal) ? accumulatedOffset.width + offset.width : 0, y: axis.contains(.vertical) ? accumulatedOffset.height + offset.height : 0)
                // Currently only offset and accumulated offset changes are animated
                .animation(.spring(), value: offset)
                .animation(.spring(), value: accumulatedOffset)
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
                        .onEnded { _ in
                            // when using the onEnded parameter instead of the offset. values it gives a nice looking effect when releasing the dragged object. But it doesn't go back to zero, so might have to check that
                            accumulatedOffset.height += offset.height
                            accumulatedOffset.width += offset.width
                            offset = .zero
                        }
                )
        }
        .coordinateSpace(name: OpenScrollViewProxy.openScrollViewCoordinateSpaceName)
    }
}
