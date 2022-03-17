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

    // FIXME: - I moved the proxy out of the body and made default init parameters. maybe I can move that back of I fix the other error

    @ObservedObject var openDragAndDropProxy = OpenDragAndDropProxy()

    public var body: some View {

        openDragAndDropProxy.dropDestinationLocations = dropDestinationLocations
        openDragAndDropProxy.draggedItemLocation = draggedItemLocation

        return self.content(openDragAndDropProxy)
            .onPreferenceChange(OpenDraggedItemPreferenceKey.self) { dragged in
                print("draggedItemLocation")
                self.draggedItemLocation = dragged
            }
            .onPreferenceChange(DropDestinationPreferenceKey.self) { newLocation in
                self.dropDestinationLocations = newLocation
            }
            .environmentObject(openDragAndDropProxy)
    }
}

// TODO: - Maybe I can implement the same onDragged and on Dropped methods here, even the same protocol, and also listen here already for the drag result.

public extension CGSize {
    /// Calculates the absolute volume
    func volume() -> CGFloat {
        abs(self.width) * abs(self.height)
    }
}
