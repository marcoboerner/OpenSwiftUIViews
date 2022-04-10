//
//  Location.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Observable Location Objects

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

public class IdentifiableLocation: Location {
    public static func == (lhs: IdentifiableLocation, rhs: IdentifiableLocation) -> Bool {
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

public class DoubleIdentifiableLocation: Location {
    public static func == (lhs: DoubleIdentifiableLocation, rhs: DoubleIdentifiableLocation) -> Bool {
        return lhs.frame == rhs.frame &&
        lhs.anchor == rhs.anchor &&
        lhs.id1 == rhs.id1 &&
        lhs.id2 == rhs.id2
    }

    public init(id1: AnyHashable = Double.infinity, id2: AnyHashable = Double.infinity, frame: CGRect = .zero, anchor: UnitPoint = .zero) {
        self.id1 = id1
        self.id2 = id2
        super.init(frame: frame, anchor: anchor)
    }

    @Published public var id1: AnyHashable
    @Published public var id2: AnyHashable
}

public class IdentifiableMaxX: Equatable {
    public static func == (lhs: IdentifiableMaxX, rhs: IdentifiableMaxX) -> Bool {
        return lhs.id == rhs.id &&
        lhs.maxX == rhs.maxX
    }

    public init(id: AnyHashable, maxX: CGFloat) {
        self.id = id
        self.maxX = maxX
    }

    public var id: AnyHashable
    public var maxX: CGFloat
}
