//
//  File.swift
//  
//
//  Created by Marco Boerner on 17.03.22.
//

import SwiftUI

public extension CGSize {
    /// Calculates the absolute volume
    func volume() -> CGFloat {
        abs(self.width) * abs(self.height)
    }
}

public extension CGRect {

    /// Calculates how much the rect is intersecting the other rect
    func intersecting(_ frame: CGRect) -> CGFloat {
        intersection(frame).size.volume() / size.volume()
    }

    /// Checks if the intersection is over a certain amount
    func intersecting(_ frame: CGRect, by rate: CGFloat) -> Bool {
        intersecting(frame) >= rate
    }

}
