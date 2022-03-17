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

    @State var dropDestinations: [AnyHashable: CGRect] = [:]
    @State var draggedItem: LocationWithID = LocationWithID()

    var content: (OpenDragAndDropProxy) -> Content

    public var body: some View {

        let openDragAndDropProxy = OpenDragAndDropProxy(dropDestinations: dropDestinations, draggedItem: draggedItem)

        return self.content(openDragAndDropProxy)
            .coordinateSpace(name: OpenDragAndDropProxy.openDragAndDropCoordinateSpaceName)
            .onPreferenceChange(OpenDraggedItemPreferenceKey.self) { draggedItem in
                self.draggedItem = draggedItem
            }
            .onPreferenceChange(OpenDropDestinationPreferenceKey.self) { newDropDestination in
                self.dropDestinations = newDropDestination
            }
            .environmentObject(openDragAndDropProxy)
    }
}
