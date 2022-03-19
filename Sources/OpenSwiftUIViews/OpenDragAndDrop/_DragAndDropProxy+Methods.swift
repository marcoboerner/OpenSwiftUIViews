//
//  File.swift
//  
//
//  Created by Marco Boerner on 17.03.22.
//

import SwiftUI

// MARK: - Intersection with drop destinations

extension OpenDragAndDropProxy {
    
    public var intersectingDestinations: [IdentifiableLocation] {
        dropDestinations
            .filter { $1.intersects(draggedItem.frame) }
            .sorted {
                $0.value.intersection(draggedItem.frame).size.volume() > $1.value.intersection(draggedItem.frame).size.volume()
            }
            .map { IdentifiableLocation(id: $0, frame: $1) }
    }

    public var mostIntersectingDestination: IdentifiableLocation {
        dropDestinations
            .filter { $1.intersects(draggedItem.frame) }
            .reduce(IdentifiableLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : IdentifiableLocation(id: $1.key, frame: $1.value)
            }
    }

    public var topIntersectingDestination: IdentifiableLocation {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxY < draggedItem.frame.maxY &&
                $1.minY < draggedItem.frame.minY
            }
            .reduce(IdentifiableLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : IdentifiableLocation(id: $1.key, frame: $1.value)
            }
    }

    public var bottomIntersectingDestination: IdentifiableLocation {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxY > draggedItem.frame.maxY &&
                $1.minY > draggedItem.frame.minY
            }
            .reduce(IdentifiableLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : IdentifiableLocation(id: $1.key, frame: $1.value)
            }
    }

    public var leadingIntersectingDestination: IdentifiableLocation {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxX < draggedItem.frame.maxX &&
                $1.minX < draggedItem.frame.minX
            }
            .reduce(IdentifiableLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : IdentifiableLocation(id: $1.key, frame: $1.value)
            }
    }

    public var trailingIntersectingDestination: IdentifiableLocation {
        dropDestinations
            .filter {
                $1.intersects(draggedItem.frame) &&
                $1.maxX > draggedItem.frame.maxX &&
                $1.minX > draggedItem.frame.minX
            }
            .reduce(IdentifiableLocation()) {
                $0.frame.size.volume() > $1.value.intersection(draggedItem.frame).size.volume() ?
                $0 : IdentifiableLocation(id: $1.key, frame: $1.value)
            }
    }
}
