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

    @EnvironmentObject var openDragItems: OpenDragItems
    @EnvironmentObject var dragLocation: IdentifiableLocation
    var supportedType: T.Type
    @Binding var isTargeted: Bool
    var didDropCompletion: ([T]) -> Void

    func body(content: Content) -> some View {

        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: dragLocation) { [dragLocation] newDragLocation in

                            // Checking if the currently dragged items match the expected type
                            guard openDragItems.items.contains(where: { $0 as? T != nil }) else { return }

                            // If the dragged item changes, which could also due to a drop, potentially dropping the item
                            if dragLocation.id != newDragLocation.id, isTargeted {
                                // returning the dropped items
                                didDropCompletion(openDragItems.items.compactMap({ $0 as? T }))
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
