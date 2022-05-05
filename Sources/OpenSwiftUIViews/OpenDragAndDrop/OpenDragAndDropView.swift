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
        lhs.success == rhs.success
    }

    @Published var dragLocation: IdentifiableLocation = IdentifiableLocation()
    @Published var items: [AnyHashable] = []
    @Published var success: Bool = false
}


// MARK: - Drag and Drop Reading

public struct OpenDragAndDropView<Content>: View where Content: View {
    public init(content: @escaping () -> Content) {
        self.content = content
    }

    @State private var openDragAndDropState: OpenDragAndDropState = OpenDragAndDropState()

    var content: () -> Content

    public var body: some View {
        return self.content()
            .onPreferenceChange(OpenDragPreferenceKey.self) { dragLocation in
                self.openDragAndDropState.dragLocation = dragLocation
            }
            .environmentObject(openDragAndDropState)
    }
}
