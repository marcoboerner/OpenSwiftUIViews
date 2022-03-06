//
//  OpenScrollViewSelection.swift
//  
//
//  Created by Marco Boerner on 05.03.22.
//

import SwiftUI

// MARK: - Drag and Drop Reading

public struct OpenDragAndDropReader<Content>: View where Content: View {

    public init(content: @escaping (OpenDragAndDropProxy) -> Content) {
        self.content = content
    }

    @State var dropDestinationLocations: [AnyHashable: CGRect] = [:]
    @State var draggedItemLocation: IDLocation = IDLocation()

    var content: (OpenDragAndDropProxy) -> Content

    public var body: some View {

        let openDragAndDropProxy = OpenDragAndDropProxy(dropDestinationLocations: dropDestinationLocations, draggedItemLocation: draggedItemLocation)

        return self.content(openDragAndDropProxy)
            .onPreferenceChange(DraggedPreferenceKey.self) { dragged in
                self.draggedItemLocation = dragged
            }
            .onPreferenceChange(DropDestinationPreferenceKey.self) { newLocation in
                self.dropDestinationLocations = newLocation
            }
    }
}

public extension CGSize {
    /// Calculates the absolute volume
    func volume() -> CGFloat {
        abs(self.width) * abs(self.height)
    }
}
