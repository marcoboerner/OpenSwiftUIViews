//
//  OpenDragAndDrop_DragItem.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Drag

public extension View {
    /// Will set the dragged view to be read by the OpenDragAndDropReader.
    ///  - Attention: Most likely it will have to be attached before any offset etc. modifiers.
    func openDragItem<ID>(
        _ isDragging: Binding<Bool>, value: ID, onDragging: ((OpenDragAndDropProxy) -> Void)? = nil, onDropping: ((OpenDragAndDropProxy) -> Void)? = nil) -> some View where ID: Hashable {
            modifier(OpenDragItem(isDragging, value: value, onDragging: onDragging, onDropping:  onDropping))
        }
}

/// Will set the dragged view to be read by the OpenDragAndDropReader.
///  - Attention: Most likely it will have to be attached before any offset etc. modifiers.
public struct OpenDragItem<ID: Hashable>: ViewModifier {
    public init(_ isDragging: Binding<Bool>, value: ID, onDragging: ((OpenDragAndDropProxy) -> Void)? = nil, onDropping: ((OpenDragAndDropProxy) -> Void)? = nil) {
        self._isDragging = isDragging
        self.value = value
        self.onDragging = onDragging
        self.onDropping = onDropping
    }

    @Binding public var isDragging: Bool
    var value: ID

    @EnvironmentObject public var openDragAndDropProxy: OpenDragAndDropProxy

    public var onDragging: ((OpenDragAndDropProxy) -> Void)?
    public var onDropping: ((OpenDragAndDropProxy) -> Void)?

    public func body(content: Content) -> some View {

        isDragging ? onDragging?(openDragAndDropProxy) : onDropping?(openDragAndDropProxy)

        return content
            .background(
                GeometryReader { geometry in
                    if isDragging {
                        Color.yellow
                            .preference(
                                key: OpenDraggedItemPreferenceKey.self,
                                value: LocationWithID(id: value, frame: geometry.frame(in: .named(OpenDragAndDropProxy.openDragAndDropCoordinateSpaceName)))
                            )
                    } else {
                        Color.clear
                    }
                }
            )
    }
}
