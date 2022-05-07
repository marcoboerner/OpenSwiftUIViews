//
//  OnDrop.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

// MARK: - Gesture as ViewModifier with Bindings

public extension View {
    func onOpenDrop<T: Hashable>(of supportedType: T.Type, isTargeted: Binding<Bool>?, perform action: @escaping (_ draggedItems: [T]) -> Void) -> some View {
        modifier(OnOpenDrop(of: supportedType, isTargeted: isTargeted, didDropCompletion: action))
    }
}

struct OnOpenDrop<T: Hashable>: ViewModifier {

    internal init(of supportedType: T.Type, isTargeted: Binding<Bool>?, didDropCompletion: @escaping ([T]) -> Void) {
        _isTargeted = isTargeted ?? .constant(false)
        self.supportedType = supportedType
        self.didDropCompletion = didDropCompletion
    }

    @State private var internalChildID: UUID = UUID()

    @EnvironmentObject var openDragAndDropState: OpenDragAndDropState

    var supportedType: T.Type
    @Binding var isTargeted: Bool
    var didDropCompletion: ([T]) -> Void

    func body(content: Content) -> some View {

        content
            .onPreferenceChange(OpenDragPreferenceKey.self) {
                // If a child of the drop location is also the dragged item, choosing to ignore that item.
                guard let internalChildID = $0.id as? UUID else { return }
                self.internalChildID = internalChildID
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onReceive(openDragAndDropState.$dragLocation) { [dragLocation = openDragAndDropState.dragLocation] newDragLocation in
                            // Checking if the currently dragged items match the expected type and is not itself as being dragged through a drag modifier
                            guard openDragAndDropState.items.contains(where: { $0 as? T != nil }), internalChildID != newDragLocation.id as? UUID else { return }

                            // If the dragged item changes, which could also due to a drop, potentially dropping the item
                            if dragLocation.id != newDragLocation.id, isTargeted {
                                // returning the dropped items
                                openDragAndDropState.dragResult = .success(dragLocation.id)
                                didDropCompletion(openDragAndDropState.items.compactMap({ $0 as? T }))
                                openDragAndDropState.items.removeAll()
                            } else if dragLocation.id != newDragLocation.id {
                                openDragAndDropState.dragResult = .cancelled(dragLocation.id)
                            }

                            // Activating the binding if a dragged item is over the drop area.
                            withAnimation {
                                isTargeted = newDragLocation.frame.intersecting(geometry.frame(in: .global), by: 0.6)
                            }
                        }
                }
            )
    }
}
