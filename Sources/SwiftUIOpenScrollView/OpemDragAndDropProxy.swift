//
//  OpenDragAndDropProxy.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Drag and Drop proxy

/// Use the proxy to scroll to a specific location.
/// - Note: use .onChange() with individual computed properties and not the while proxy to only receive updates when the result of the properties changes.
public class OpenDragAndDropProxy: Equatable, ObservableObject {
    public static func == (lhs: OpenDragAndDropProxy, rhs: OpenDragAndDropProxy) -> Bool {
        lhs.dropDestinationLocations == rhs.dropDestinationLocations &&
        lhs.draggedItemLocation == rhs.draggedItemLocation
    }

    // static let customScrollViewCoordinateSpaceName = "OpenDragAndDrop"

    init(dropDestinationLocations: [AnyHashable: CGRect], draggedItemLocation: IDLocation) {
        self.dropDestinationLocations = dropDestinationLocations
        self.draggedItemLocation = draggedItemLocation
    }

    @State public var dropDestinationLocations: [AnyHashable: CGRect]
    @State public var draggedItemLocation: IDLocation

}

// MARK: - Intersection with drop destinations

extension OpenDragAndDropProxy {

    public func callAsFunction<ID: Hashable>(for: ID) -> Self {
        return self
    }
}


extension OpenDragAndDropProxy {
    public var intersectingDestinations: [IDLocation] {
        dropDestinationLocations
            .filter { $1.intersects(draggedItemLocation.frame) }
            .sorted {
                $0.value.intersection(draggedItemLocation.frame).size.volume() > $1.value.intersection(draggedItemLocation.frame).size.volume()
            }
            .map { IDLocation(id: $0, frame: $1) }
    }

    public var mostIntersectingDestination: IDLocation {
        dropDestinationLocations
            .filter { $1.intersects(draggedItemLocation.frame) }
            .reduce(IDLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItemLocation.frame).size.volume() ?
                $0 : IDLocation(id: $1.key, frame: $1.value)
            }
    }

    public var topIntersectingDestination: IDLocation {
        dropDestinationLocations
            .filter {
                $1.intersects(draggedItemLocation.frame) &&
                $1.maxY < draggedItemLocation.frame.maxY &&
                $1.minY < draggedItemLocation.frame.minY
            }
            .reduce(IDLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItemLocation.frame).size.volume() ?
                $0 : IDLocation(id: $1.key, frame: $1.value)
            }
    }

    public var bottomIntersectingDestination: IDLocation {
        dropDestinationLocations
            .filter {
                $1.intersects(draggedItemLocation.frame) &&
                $1.maxY > draggedItemLocation.frame.maxY &&
                $1.minY > draggedItemLocation.frame.minY
            }
            .reduce(IDLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItemLocation.frame).size.volume() ?
                $0 : IDLocation(id: $1.key, frame: $1.value)
            }
    }

    public var leadingIntersectingDestination: IDLocation {
        dropDestinationLocations
            .filter {
                $1.intersects(draggedItemLocation.frame) &&
                $1.maxX < draggedItemLocation.frame.maxX &&
                $1.minX < draggedItemLocation.frame.minX
            }
            .reduce(IDLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItemLocation.frame).size.volume() ?
                $0 : IDLocation(id: $1.key, frame: $1.value)
            }
    }

    public var trailingIntersectingDestination: IDLocation {
        dropDestinationLocations
            .filter {
                $1.intersects(draggedItemLocation.frame) &&
                $1.maxX > draggedItemLocation.frame.maxX &&
                $1.minX > draggedItemLocation.frame.minX
            }
            .reduce(IDLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItemLocation.frame).size.volume() ?
                $0 : IDLocation(id: $1.key, frame: $1.value)
            }
    }
}
