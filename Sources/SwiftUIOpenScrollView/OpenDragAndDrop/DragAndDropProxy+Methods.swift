//
//  File.swift
//  
//
//  Created by Marco Boerner on 17.03.22.
//

import SwiftUI

// MARK: - Intersection with drop destinations

extension OpenDragAndDropProxy {
    
    public var intersectingDestinations: [LocationWithID] {
        dropDestinations
            .filter { $1.intersects(draggedItem.frame) }
            .sorted {
                $0.value.intersection(draggedItem.frame).size.volume() > $1.value.intersection(draggedItem.frame).size.volume()
            }
            .map { LocationWithID(id: $0, frame: $1) }
    }

    public var mostIntersectingDestination: LocationWithID {
        dropDestinations
            .filter { $1.intersects(draggedItem.frame) }
            .reduce(LocationWithID()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : LocationWithID(id: $1.key, frame: $1.value)
            }
    }

    public var topIntersectingDestination: LocationWithID {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxY < draggedItem.frame.maxY &&
                $1.minY < draggedItem.frame.minY
            }
            .reduce(LocationWithID()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : LocationWithID(id: $1.key, frame: $1.value)
            }
    }

    public var bottomIntersectingDestination: LocationWithID {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxY > draggedItem.frame.maxY &&
                $1.minY > draggedItem.frame.minY
            }
            .reduce(LocationWithID()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : LocationWithID(id: $1.key, frame: $1.value)
            }
    }

    public var leadingIntersectingDestination: LocationWithID {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxX < draggedItem.frame.maxX &&
                $1.minX < draggedItem.frame.minX
            }
            .reduce(LocationWithID()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : LocationWithID(id: $1.key, frame: $1.value)
            }
    }

    public var trailingIntersectingDestination: LocationWithID {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxX > draggedItem.frame.maxX &&
                $1.minX > draggedItem.frame.minX
            }
            .reduce(LocationWithID()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : LocationWithID(id: $1.key, frame: $1.value)
            }
    }
}
