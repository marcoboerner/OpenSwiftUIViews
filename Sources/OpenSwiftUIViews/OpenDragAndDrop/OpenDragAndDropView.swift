//
//  OpenDragAndDropView.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

class OpenDragAndDropState: ObservableObject, Equatable {
    static func == (lhs: OpenDragAndDropState, rhs: OpenDragAndDropState) -> Bool {
        lhs.dragLocation == rhs.dragLocation &&
        lhs.items == rhs.items &&
        lhs.anyItems.dragIdentifier == rhs.anyItems.dragIdentifier &&
        lhs.dragResult == rhs.dragResult &&
        lhs.hasDropTarget == rhs.hasDropTarget
    }

    @Published var dragLocation: IdentifiableLocation = IdentifiableLocation()
    @Published var items: [AnyHashable] = []
    @Published var anyItems: (dragIdentifier: AnyHashable, items: [Any]) = (AnyHashable(Int.zero), [])
    @Published var dragResult: OpenDragResult? = nil
    @Published var hasDropTarget: Bool = false
}

enum OpenDragResult: Equatable {
    case success(AnyHashable)
    case cancelled(AnyHashable)
    case removed(AnyHashable)
}

// MARK: - Drag and Drop Reading

public struct OpenDragAndDropView<Content>: View where Content: View {
    public init(content: @escaping () -> Content) {
        self.content = content
    }

    @State private var openDragAndDropState: OpenDragAndDropState = OpenDragAndDropState()

    var content: () -> Content

    public var body: some View {
        self.content()
            .onPreferenceChange(OpenDragPreferenceKey.self) { dragLocation in
                self.openDragAndDropState.dragLocation = dragLocation
            }
            .environmentObject(openDragAndDropState)
    }
}
