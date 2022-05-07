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
        lhs.dragResult == rhs.dragResult
    }

    @Published var dragLocation: IdentifiableLocation = IdentifiableLocation()
    @Published var items: [AnyHashable] = []
    @Published var dragResult: OpenDragResult? = nil
}

enum OpenDragResult: Equatable {
    case success(AnyHashable)
    case cancelled(AnyHashable)
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
