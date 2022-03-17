//
//  Location.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Observable Object

public class Location: ObservableObject, Equatable {

    public init(frame: CGRect = .zero, anchor: UnitPoint = .zero) {
        self.frame = frame
        self.anchor = anchor

        let x = frame.minX + (frame.maxX - frame.minX) * anchor.x
        let y = frame.minY + (frame.maxY - frame.minY) * anchor.y
        self.anchorPoint = CGPoint(x: x, y: y)
    }

    public static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.frame == rhs.frame &&
        lhs.anchor == rhs.anchor
    }

    @Published public var frame: CGRect
    @Published public var anchor: UnitPoint
    @Published public var anchorPoint: CGPoint
}

public class LocationWithID: Location {
    public static func == (lhs: LocationWithID, rhs: LocationWithID) -> Bool {
        return lhs.frame == rhs.frame &&
        lhs.anchor == rhs.anchor &&
        lhs.id == rhs.id
    }

    public init(id: AnyHashable = Double.infinity, frame: CGRect = .zero, anchor: UnitPoint = .zero) {
        self.id = id
        super.init(frame: frame, anchor: anchor)
    }

    @Published public var id: AnyHashable
}
