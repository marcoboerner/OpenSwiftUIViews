//
//  OpenDragAndDropProxy.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Drag and Drop proxy

/// Use the proxy to scroll to a specific location.
/// - Note: use .onChange() with individual computed properties and not the whole proxy to only receive updates when the result of the properties changes.
public class OpenDragAndDropProxy: Equatable, ObservableObject {
    public static func == (lhs: OpenDragAndDropProxy, rhs: OpenDragAndDropProxy) -> Bool {
        lhs.dropDestinations == rhs.dropDestinations &&
        lhs.draggedItem == rhs.draggedItem
    }

    init(dropDestinations: [AnyHashable: CGRect] = [:], draggedItem: IdentifiableLocation = IdentifiableLocation()) {
        self.dropDestinations = dropDestinations
        self.draggedItem = draggedItem
    }

    static let openDragAndDropCoordinateSpaceName = "OpenDragAndDrop"

    @State public var dropDestinations: [AnyHashable: CGRect]
    @State public var draggedItemStart: Location = Location()
    @State public var draggedItem: IdentifiableLocation

    // TODO: - Need to somehow get the iniital locaion stored and only changed when I select another item, then I need to find the right offset so that I can have the drop hover snap


}
