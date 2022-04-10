//
//  File.swift
//  
//
//  Created by Marco Boerner on 07.04.22.
//

import Foundation
import SwiftUI
import OrderedCollections

extension OpenAlignOffset {

    internal func getOffset(for alignLocations: [DoubleIdentifiableLocation], with geometry: GeometryProxy, alignment: Alignment, column: T?, row: T?) -> CGSize {

        var valueX: KeyPath<CGRect, CGFloat> = \.midX
        var valueY: KeyPath<CGRect, CGFloat> = \.midY

        // Assigning the CGRect KeyPath determined by the alignment.
        switch alignment {
        case .topLeading:
            valueX = \.minX
            valueY = \.minY
        case .leading:
            valueX = \.minX
        case .bottomLeading:
            valueX = \.minX
            valueY = \.maxY
        case .top:
            valueY = \.minY
        case .bottom:
            valueY = \.maxY
        case .topTrailing:
            valueX = \.maxX
            valueY = \.minY
        case .trailing:
            valueX = \.maxX
        case .bottomTrailing:
            valueX = \.maxX
            valueY = \.maxY
        default:
            break
        }

        // Creating two collections of frames filtered by the id of the rows and columns.
        let xFrames = alignLocations.filter({ column != nil && $0.id1 == column as AnyHashable }).map { $0.frame }
        let yFrames = alignLocations.filter({ row != nil && $0.id2 == row as AnyHashable }).map { $0.frame }

        // Creating the predicate to be used to be used later to get the min or max values of the columns
        let xPredicate: (CGRect, CGRect) -> Bool = { $0[keyPath: valueX] < $1[keyPath: valueX] }
        let yPredicate: (CGRect, CGRect) -> Bool = { $0[keyPath: valueY] < $1[keyPath: valueY] }

        // the either min or max location (frames) of x and y
        var xFrame: CGRect?
        var yFrame: CGRect?

        // using the above predicate to get the individual min or max x or y frame
        switch valueX {
        case \.minX:
            xFrame = xFrames.min(by: xPredicate)
        case \.maxX:
            xFrame = xFrames.max(by: xPredicate)
        default: //midX
            break
        }

        switch valueY {
        case \.minY:
            yFrame = yFrames.min(by: yPredicate)
        case \.maxY:
            yFrame = yFrames.max(by: yPredicate)
        default: //midY
            break
        }

        // from the min or max frame we get the min or max x or y value
        let x = xFrame?[keyPath: valueX]
        let y = yFrame?[keyPath: valueY]

        let localFrame = geometry.frame(in: .local)
        let globalFrame = geometry.frame(in: coordinateSpace)

        let localPosition = CGPoint(x: localFrame[keyPath: valueX], y: localFrame[keyPath: valueY])
        let globalPosition = CGPoint(x: globalFrame[keyPath: valueX], y: globalFrame[keyPath: valueY])

        // getting the new x and y position in the other coordinate space relative to the local coordinate space.
        let newX = localPosition.x - globalPosition.x + (x ?? globalPosition.x)
        let newY = localPosition.y - globalPosition.y + (y ?? globalPosition.y)

        let newPosition = CGPoint(x: newX, y: newY)

        // Calculating the relative offset
        let offset = CGSize(width: newPosition.x - abs(localPosition.x), height: newPosition.y - abs(localPosition.y))

        // Returning the final offset
        return offset
    }

}

extension OpenAlignOffset {

    internal func offsetAlignment(xSpacing: CGFloat? = nil, ySpacing: CGFloat? = nil) {

        // >
//        let minXPredicate: (CGRect, CGRect) -> Bool = { $0.minX < $1.minX }
//
//        // >
//        var minXFrame: CGRect?
//
//        // >
//        minXFrame = xFrames.min(by: minXPredicate)
//        // >
//        let minX = minXFrame?.minX
//
//        let previousColumnMaxX: CGFloat
//
//        if let xIndex = alignedXOffsets.index(forKey: column), xIndex > 0 {
//            previousColumnMaxX = alignedXOffsets.elements[xIndex - 1].value
//        } else if alignedXOffsets.elements.indices.contains(0) {
//            previousColumnMaxX = alignedXOffsets.elements[0].value
//        } else {
//            previousColumnMaxX = .zero
//        }
//
//        if let minX = minX {
//            if previousColumnMaxX > minX {
//                x? += previousColumnMaxX - minX
//            }
//        }

    }
}

// TODO: - Implement some warnings when the same modifier is implemented on the same view multiple times. Like on a custom view and also in the subview of the custom view.

// TODO: - Allow the alignment to be set by the OpenAlignView and be inherited, but can be overwritten by the individual modifiers
// TODO: - When having both open align offset and open align size, make it possible that only one of the two need to assign the id (when no id is given.
// TODO: - Can there be a way to auto assign an id if the views are in a 2d grid?
// TODO: - Figure out if I even need a VStack or HStack, could I also use it without as some sort if view builder? I guess I'd need to lay them out first. Could I create a view that internally has a v and h stack, but looks more like:

/*

 OpenAlignView(.topLeading) {
 OpenRow {
 Text1()
 .trailing
 Text2()
 .bottomLeading
 Text3()
 }
 OpenRow {
 TextA()
 TextB()
 .bottomLeading
 TextC()
 }
 */
