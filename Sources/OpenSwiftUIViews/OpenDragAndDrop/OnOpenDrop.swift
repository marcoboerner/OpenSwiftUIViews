//
//  OnDrop.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

// MARK: - Gesture as ViewModifier with Bindings

extension View {
    public func onOpenDrop<T: Hashable>(of supportedTypes: [T.Type], isTargeted: Binding<Bool>?, perform action: @escaping (_ draggedItems: [AnyHashable]) -> Void) -> some View {
        modifier(OnOpenDrop(isTargeted: isTargeted, didDropCompletion: action))
    }
}

struct OnOpenDrop: ViewModifier {
    internal init(isTargeted: Binding<Bool>?, didDropCompletion: @escaping ([AnyHashable]) -> Void) {
        _isTargeted = isTargeted ?? .constant(false)
        self.didDropCompletion = didDropCompletion
    }

    @EnvironmentObject var openDragItems: OpenDragItems
    @EnvironmentObject var draggedItem: IdentifiableLocation
    @Binding var isTargeted: Bool
    var didDropCompletion: ([AnyHashable]) -> Void

    func body(content: Content) -> some View {

        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: draggedItem) { [draggedItem] newDraggedItem in

                            if draggedItem.id != newDraggedItem.id, isTargeted {
                                didDropCompletion(openDragItems.items)
                            }

                            withAnimation {
                                isTargeted = newDraggedItem.frame.intersecting(geometry.frame(in: .global), by: 0.6)
                            }
                        }
                }
            )
    }
}
