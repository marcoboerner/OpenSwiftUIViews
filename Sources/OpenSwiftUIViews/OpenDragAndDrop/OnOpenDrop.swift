//
//  OnDrop.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

// MARK: - Gesture as ViewModifier with Bindings

public extension View {
    /// A drop destination that checks for a specific type and returns an array of that type
    func onOpenDrop<T: Hashable>(of supportedType: T.Type, isTargeted: Binding<Bool>?, perform action: @escaping (_ draggedItems: [T]) -> Void) -> some View {
        modifier(OnOpenDrop(of: supportedType, isTargeted: isTargeted, didDropCompletion: action))
    }
    /// A drop destination that only checks for the dragIdentifier and returns an array of Any
    /// The array of any can be type cast in the completion closure
    func onOpenDrop(dragIdentifier: AnyHashable, isTargeted: Binding<Bool>?, perform action: @escaping (_ draggedItems: [Any]) -> Void) -> some View {
        modifier(OnOpenDrop(dragIdentifier: dragIdentifier, isTargeted: isTargeted, didDropAnyCompletion: action))
    }
    /// A drop destination that checks for the dragIdentifier and conveniently  type casts the array of Any to the given type.
    func onOpenDrop<T: Hashable>(of supportedType: T.Type, dragIdentifier: AnyHashable, isTargeted: Binding<Bool>?, perform action: @escaping (_ draggedItems: [T]) -> Void) -> some View {
        modifier(OnOpenDrop(of: supportedType, dragIdentifier: dragIdentifier, isTargeted: isTargeted, didDropCompletion: action))
    }
}

struct OnOpenDrop<T: Hashable>: ViewModifier {

    internal init(of supportedType: T.Type, isTargeted: Binding<Bool>?, didDropCompletion: @escaping ([T]) -> Void) {
        _isTargeted = isTargeted ?? .constant(false)
        self.supportedType = supportedType
        self.didDropCompletion = didDropCompletion
    }
    internal init(dragIdentifier: T, isTargeted: Binding<Bool>?, didDropAnyCompletion: @escaping ([Any]) -> Void) {
        _isTargeted = isTargeted ?? .constant(false)
        self.dragIdentifier = dragIdentifier
        self.didDropAnyCompletion = didDropAnyCompletion
    }
    internal init(of supportedType: T.Type, dragIdentifier: AnyHashable, isTargeted: Binding<Bool>?, didDropCompletion: @escaping ([T]) -> Void) {
        _isTargeted = isTargeted ?? .constant(false)
        self.supportedType = supportedType
        self.dragIdentifier = dragIdentifier
        self.didDropCompletion = didDropCompletion
    }

    @State private var internalChildID: UUID = UUID()

    @EnvironmentObject var openDragAndDropState: OpenDragAndDropState

    var supportedType: T.Type?
    var dragIdentifier: AnyHashable?
    @Binding var isTargeted: Bool
    var didDropCompletion: (([T]) -> Void)?
    var didDropAnyCompletion: (([Any]) -> Void)?

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

                            // Checking is not itself as being dragged through a drag modifier
                            guard internalChildID != newDragLocation.id as? UUID else { return }

                            // Checking if the currently dragged items match the expected type or the drag Identifiers match
                            guard openDragAndDropState.items.contains(where: { $0 as? T != nil }) || openDragAndDropState.anyItems.dragIdentifier == dragIdentifier else { return }

                            // If the dragged item changes, which could also due to a drop (new id = .inf), potentially dropping the item
                            if dragLocation.id != newDragLocation.id, isTargeted {

                                if dragIdentifier != nil, let didDropCompletion = didDropCompletion {
                                    // returning and type casting the anyItems
                                    openDragAndDropState.dragResult = .success(dragLocation.id)
                                    didDropCompletion(openDragAndDropState.anyItems.items.compactMap({ $0 as? T }))
                                    openDragAndDropState.anyItems = (AnyHashable(Int.zero), [])
                                } else if let didDropCompletion = didDropCompletion {
                                    // returning and type casting the dropped items...
                                    openDragAndDropState.dragResult = .success(dragLocation.id)
                                    didDropCompletion(openDragAndDropState.items.compactMap({ $0 as? T }))
                                    openDragAndDropState.items.removeAll()
                                } else if let didDropAnyCompletion = didDropAnyCompletion {
                                    // ... or returning anyItems as an array of any
                                    openDragAndDropState.dragResult = .success(dragLocation.id)
                                    didDropAnyCompletion(openDragAndDropState.anyItems.items)
                                    openDragAndDropState.anyItems = (AnyHashable(Int.zero), [])
                                }
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
