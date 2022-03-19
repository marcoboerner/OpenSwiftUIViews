//
//  OnDrop.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

// MARK: - Gesture as ViewModifier with Bindings

public extension View {
    func onOpenDrop<T: Hashable>(of supportedType: T.Type, isTargeted: Binding<Bool>?, perform action: @escaping (_ draggedItems: [AnyHashable]) -> Void) -> some View {
        modifier(OnOpenDrop(of: supportedType, isTargeted: isTargeted, didDropCompletion: action))
    }
}

struct OnOpenDrop<T: Hashable>: ViewModifier {

    internal init(of supportedType: T.Type, isTargeted: Binding<Bool>?, didDropCompletion: @escaping ([AnyHashable]) -> Void) {
        _isTargeted = isTargeted ?? .constant(false)
        self.supportedType = supportedType
        self.didDropCompletion = didDropCompletion
    }

    @EnvironmentObject var openDragItems: OpenDragItems
    @EnvironmentObject var dragLocation: IdentifiableLocation
    var supportedType: T.Type
    @Binding var isTargeted: Bool
    var didDropCompletion: ([AnyHashable]) -> Void

    func body(content: Content) -> some View {

        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: dragLocation) { [dragLocation] newDragLocation in

                            guard openDragItems.items.contains(where: { $0 as? T != nil }) else { return }

                            if dragLocation.id != newDragLocation.id, isTargeted {
                                didDropCompletion(openDragItems.items)
                            }

                            withAnimation {
                                isTargeted = newDragLocation.frame.intersecting(geometry.frame(in: .global), by: 0.6)
                            }
                        }
                }
            )
    }
}
