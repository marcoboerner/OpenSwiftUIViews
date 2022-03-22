//
//  OnOpenDrag.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

public extension View {
    func onOpenDrag<T: Hashable>(_ didStartDragging: @escaping () -> [T]) -> some View {
        modifier(OnOpenDrag(didStartDragging: didStartDragging))
    }
}

// MARK: - Gesture as ViewModifier

struct OnOpenDrag<T: Hashable>: ViewModifier {

    let internalID: UUID = UUID()
    @State var gestureValue: GestureValue = GestureValue()
    @EnvironmentObject var openDragAndDropState: OpenDragAndDropState

    var didStartDragging: () -> [T]
    @State var scale: CGFloat = 1.0

    func body(content: Content) -> some View {

        // Gets triggered immediately because a drag of 0 distance starts already when touching down.
        let tapGesture = DragGesture(minimumDistance: 0)
            .onChanged { _ in
                gestureValue.isTapping = true
            }
            .onEnded { _ in
                gestureValue.isTapping = false
            }

        let pressGesture = LongPressGesture(minimumDuration: 0.3)
            .onEnded { _ in
                gestureValue.zIndex += 100
                withAnimation {
                    gestureValue.isDragging = true
                }
            }

        // minimumDistance here is mainly relevant to change to red before the drag
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { gestureValue.offset = $0.translation }
            .onEnded { _ in
                if openDragAndDropState.success { // this animation doesn't work yet as planned
                    scale = 0.0
                    gestureValue.offset = .zero
                    withAnimation {
                        scale = 1.0
                    }
                } else {
                    withAnimation {
                        scale = 1.0
                        gestureValue.offset = .zero
                        gestureValue.isDragging = false
                    }
                }

                gestureValue.zIndex -= 100
            }

        // The dragGesture will wait until the pressGesture has triggered after minimumDuration 1.0 seconds.
        let pressDragGesture = pressGesture.sequenced(before: dragGesture)

        // The new combined gesture is set to run together with the tapGesture.
        let tapPressDragGesture = tapGesture.simultaneously(with: pressDragGesture)

        content
            .background(
                GeometryReader { geometry in
                    if gestureValue.isDragging {
                        Color.clear
                            .preference(key: OpenDragPreferenceKey.self, value: IdentifiableLocation(id: internalID, frame: geometry.frame(in: .global)))
                    } else {
                        Color.clear
                    }
                }
            )
            .scaleEffect(scale)
            .zIndex(gestureValue.zIndex)
            .offset(gestureValue.offset)
            .blockScrolling(gestureValue.isDragging)
            .gesture(tapPressDragGesture)
            .onChange(of: gestureValue.isDragging) { isDragging in
                if isDragging {
                    let draggedValues = didStartDragging()
                    openDragAndDropState.items = draggedValues
                }
            }
    }
}

// MARK: - GestureValue

public struct GestureValue: Equatable {
    public static func == (lhs: GestureValue, rhs: GestureValue) -> Bool {
        lhs.isTapping == rhs.isTapping &&
        lhs.isDragging == rhs.isDragging &&
        lhs.offset == rhs.offset &&
        lhs.zIndex == rhs.zIndex
    }

    var isTapping: Bool = false
    var isDragging = false
    var offset: CGSize = .zero
    var zIndex: Double = 0.0
}
