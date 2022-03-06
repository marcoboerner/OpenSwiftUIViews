//
//  OpenDragAndDrop_DragItem.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Drag

struct DraggedPreferenceKey: PreferenceKey {

    static func reduce(value: inout IDLocation, nextValue: () -> IDLocation) {
        if nextValue().frame != .zero, nextValue().anchorPoint != .zero {
            value = nextValue()
        }
    }
    static var defaultValue: IDLocation = IDLocation()
}

public extension View {
    /// Will set the dragged view to be read by the OpenDragAndDropReader.
    ///  - Attention: Most likely it will have to be attached before any offset etc. modifiers.
    func dragItem<ID>(_ isDragging: Binding<Bool>, value: ID) -> some View where ID: Hashable {
        modifier(DragItem(isDragging, value: value))
    }
}

/// Will set the dragged view to be read by the OpenDragAndDropReader.
///  - Attention: Most likely it will have to be attached before any offset etc. modifiers.
public struct DragItem<ID: Hashable>: ViewModifier {
    public init(_ isDragging: Binding<Bool>, value: ID) {
        self._isDragging = isDragging
        self.value = value
    }

    @Binding var isDragging: Bool
    var value: ID

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    if isDragging {
                        Color.clear
                            .preference(
                                key: DraggedPreferenceKey.self,
                                value: IDLocation(id: value, frame: geometry.frame(in: .global)))
                    } else {
                        Color.clear
                    }
                }
            )
    }
}

