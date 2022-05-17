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

    func onOpenDrag(dragIdentifier: AnyHashable, _ didStartDragging: @escaping () -> [Any]) -> some View {
        modifier(OnOpenDrag(dragIdentifierForAny: dragIdentifier, didStartDraggingAny: didStartDragging))
    }
}

// MARK: - Gesture as ViewModifier

struct OnOpenDrag<T: Hashable>: ViewModifier {

    private let internalID: UUID = UUID()
    @State private var gestureValue: GestureValue = GestureValue()
    @EnvironmentObject var openDragAndDropState: OpenDragAndDropState
    var didStartDragging: (() -> [T])?
    var dragIdentifierForAny: T?
    var didStartDraggingAny: (() -> [Any])?
    @State private var scale: CGFloat = 1.0

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
                gestureValue.isDragging = false
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
                    if let didStartDragging = didStartDragging {
                        openDragAndDropState.items = didStartDragging()
                        // FIXME: - maybe make these optional and clear the other
                    } else if let didStartDraggingAny = didStartDraggingAny, let dragIdentifierForAny = dragIdentifierForAny {
                        openDragAndDropState.anyItems = (dragIdentifierForAny, didStartDraggingAny())
                    }
                    openDragAndDropState.dragResult = nil
                }
            }
            .onReceive(openDragAndDropState.$dragResult) { dragResult in
                switch dragResult {
                case .success(let id):
                    guard id as? UUID == internalID else { return }
                    scale = 0.01 // <- it is important to start with a value > 0.
                    withAnimation {
                        gestureValue.offset = .zero
                        scale = 1.0
                    }
                case .cancelled(let id):
                    guard id as? UUID == internalID else { return }
                    withAnimation {
                        scale = 1.0
                        gestureValue.offset = .zero
                    }
                case nil:
                    break
                }
                gestureValue.zIndex -= 100
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
