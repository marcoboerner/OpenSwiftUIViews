//
//  OpenDragAndDropView.swift
//  Doomsday Trainer
//
//  Created by Marco Boerner on 19.03.22.
//

import SwiftUI

// MARK: - Drag and Drop Reading

public struct OpenDragAndDropView<Content>: View where Content: View {

    @State var draggedItem: IdentifiableLocation = IdentifiableLocation()
    var openDragItems: OpenDragItems = OpenDragItems()

    var content: () -> Content

    public var body: some View {
        return self.content()
            .onPreferenceChange(OpenDragPreferenceKey.self) { draggedItem in
                self.draggedItem = draggedItem
            }
            .environmentObject(draggedItem)
            .environmentObject(openDragItems)
    }
}

public class OpenDragItems: ObservableObject, Equatable {
    public static func == (lhs: OpenDragItems, rhs: OpenDragItems) -> Bool {
        lhs.items == rhs.items
    }

    public init(items: [AnyHashable] = []) {
        self.items = items
    }

    @Published public var items: [AnyHashable]
}
