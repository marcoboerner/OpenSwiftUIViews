//
//  OnOpenDrag.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

public extension View {
    func onOpenDrag<T: Hashable>(removalOffset: CGSize = CGSize(width: -1, height: -1), onRemove: (([T]) -> Void)? = nil, didStartDragging: @escaping () -> [T]) -> some View {
        modifier(OnOpenDrag<T, Any>(removalOffset: removalOffset, didStartDragging: didStartDragging, onRemove: onRemove))
    }

    func onOpenDrag<A>(dragIdentifier: AnyHashable, removalOffset: CGSize = CGSize(width: -1, height: -1), onRemove: (([A]) -> Void)? = nil, didStartDragging: @escaping () -> [A]) -> some View {
        modifier(OnOpenDrag(removalOffset: removalOffset, dragIdentifierForAny: dragIdentifier, didStartDraggingAny: didStartDragging, onRemoveAny: onRemove))
    }
}

// MARK: - Gesture as ViewModifier

struct OnOpenDrag<T: Hashable, A>: ViewModifier {

    private let internalID: UUID = UUID()
    @State private var gestureValue: GestureValue = GestureValue()
    @EnvironmentObject var openDragAndDropState: OpenDragAndDropState
    var removalOffset: CGSize
    var didStartDragging: (() -> [T])?
    var onRemove: (([T]) -> Void)?
    var dragIdentifierForAny: T?
    var didStartDraggingAny: (() -> [A])?
    var onRemoveAny: (([A]) -> Void)?

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
                    } else if let didStartDraggingAny = didStartDraggingAny, let dragIdentifierForAny = dragIdentifierForAny {
                        openDragAndDropState.anyItems = (dragIdentifierForAny, didStartDraggingAny())
                    }
                    openDragAndDropState.dragResult = nil
                } else if !isDragging && openDragAndDropState.dragResult == nil {
                    if shouldRemove() {
                        openDragAndDropState.dragResult = .removed(internalID)
                    } else {
                        openDragAndDropState.dragResult = .cancelled(internalID)
                    }
                }
            }
            .onReceive(openDragAndDropState.$dragResult) { dragResult in
                guard let dragResult = dragResult else { return }

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
                case .removed(let id):
                    guard id as? UUID == internalID else { return }
                    withAnimation {
                        scale = 0.1
                    }
                    removedAction()
                }
            }
    }

    // MARK: - Helper

    private func removedAction() {
        // All this only happens when no drop has been detected anywhere and only if onRemove is set.
        if let onRemove = onRemove, didStartDragging != nil, !openDragAndDropState.items.isEmpty {
            onRemove(openDragAndDropState.items.compactMap({ $0 as? T }))
            openDragAndDropState.items.removeAll()
        } else if let onRemoveAny = onRemoveAny, didStartDraggingAny != nil || dragIdentifierForAny != nil {
            onRemoveAny(openDragAndDropState.anyItems.items.compactMap({ $0 as? A }))
            openDragAndDropState.anyItems = (AnyHashable(Int.zero), [])
        }
    }

    private func shouldRemove() -> Bool {
        (abs(gestureValue.offset.height) >= removalOffset.height || abs(gestureValue.offset.width) >= removalOffset.width) &&
        (onRemove != nil || onRemoveAny != nil)
    }
    private func shouldNotRemove() -> Bool {
        !shouldRemove()
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
