//
//  ViewExtensions.swift
//  SameSame SwiftUI Tests
//
//  Created by Marco Boerner on 06.01.21.
//

import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Positions the center of this view at the specified point in the specified
    /// coordinate space.
    ///
    /// Use the `openRelativePosition(_ position:in:)` modifier to place the center of a view at a
    /// specific coordinate in the specified coordinate space using a
    /// CGPoint to specify the `x`
    /// and `y` position of the target CoordinateSpace defined by the Enum `coordinateSpace`
    /// As this is changing the position of the view other views using auto layout might be changed.
    /// Use any other `.position()` or `openRelativePosition` modifier to avoid that.
    ///
    ///     Text("Position by passing a CGPoint() and CoordinateSpace")
    ///         .openRelativePosition(CGPoint(x: 175, y: 100), in: .global)
    ///         .border(Color.gray)
    ///
    /// - Parameters
    ///   - position: The point in the target CoordinateSpace at which to place the center of this. Uses auto layout if nil.
    ///   view.
    ///   - in coordinateSpace: The target CoordinateSpace at which to place the center of this view.
    ///
    /// - Returns: A view that fixes the center of this view at `position` in `coordinateSpace` .
    public func openRelativePosition(_ position: CGPoint?, in coordinateSpace: CoordinateSpace) -> some View {
        modifier(OpenRelativePosition(position: position, coordinateSpace: coordinateSpace))
    }
}

private struct OpenRelativePosition: ViewModifier {

    var position: CGPoint?
    @State private var newPosition: CGPoint = .zero

    let coordinateSpace: CoordinateSpace

    @State var localPosition: CGPoint = .zero
    @State var targetPosition: CGPoint = .zero

    func body(content: Content) -> some View {

        if let position = position {
            return AnyView(
                content
                    .position(newPosition)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    let localFrame = geometry.frame(in: .local)
                                    let otherFrame = geometry.frame(in: coordinateSpace)

                                    localPosition = CGPoint(x: localFrame.midX, y: localFrame.midY)
                                    targetPosition = CGPoint(x: otherFrame.midX, y: otherFrame.midY)
                                    newPosition.x = localPosition.x - targetPosition.x + position.x
                                    newPosition.y = localPosition.y - targetPosition.y + position.y
                                }
                        }
                    )
            )
        } else {
            return AnyView(
                content
            )
        }
    }
}
