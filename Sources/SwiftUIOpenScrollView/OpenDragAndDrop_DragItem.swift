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
    func dragItem<ID>(_ isDragging: Binding<Bool>, value: ID, onDrag: ((OpenDragAndDropProxy) -> Void)? = nil, onDrop: ((OpenDragAndDropProxy) -> Void)? = nil, onDragOver: ((OpenDragAndDropProxy) -> Void)? = nil, onCancel: ((OpenDragAndDropProxy) -> Void)? = nil) -> some View where ID: Hashable {
        modifier(DragItem(isDragging, value: value, onDrag: onDrag, onDrop:  onDrop, onDragOver: onDragOver, onCancel: onCancel))
    }
}

/// Will set the dragged view to be read by the OpenDragAndDropReader.
///  - Attention: Most likely it will have to be attached before any offset etc. modifiers.
public struct DragItem<ID: Hashable>: ViewModifier {
    public init(_ isDragging: Binding<Bool>, value: ID, onDrag: ((OpenDragAndDropProxy) -> Void)? = nil, onDrop: ((OpenDragAndDropProxy) -> Void)? = nil, onDragOver: ((OpenDragAndDropProxy) -> Void)? = nil, onCancel: ((OpenDragAndDropProxy) -> Void)? = nil) {
        self._isDragging = isDragging
        self.value = value
        self.onDrag = onDrag
        self.onDrop = onDrop
        self.onDragOver = onDragOver
        self.onCancel = onCancel
    }

    @Binding var isDragging: Bool
    var value: ID

    @EnvironmentObject var openDragAndDropProxy: OpenDragAndDropProxy

    var onDrag: ((OpenDragAndDropProxy) -> Void)?
    var onDrop: ((OpenDragAndDropProxy) -> Void)?
    var onDragOver: ((OpenDragAndDropProxy) -> Void)?
    var onCancel: ((OpenDragAndDropProxy) -> Void)?

    public func body(content: Content) -> some View {

        if isDragging {
            onDrag?(openDragAndDropProxy)
        } else {
            onCancel?(openDragAndDropProxy)
        }


        return content
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

// MARK: - Drag Item

public struct OpenDragItem<ID, Content>: View where Content: View, ID: Hashable {

    public init(_ isDragging: Binding<Bool>, value: ID, content: @escaping (OpenDragAndDropProxy) -> Content) {
        self._isDragging = isDragging
        self.value = value
        self.content = content
    }

    @Binding var isDragging: Bool
    var value: ID

    var content: (OpenDragAndDropProxy) -> Content

    @EnvironmentObject var openDragAndDropProxy: OpenDragAndDropProxy

    public var body: some View {

        self.content(openDragAndDropProxy)
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


// TODO: - Maybe create a drag item that has its own gesture with simple offset etc in it. Works for simpler setups where there are no other gestures. Otherwise the recommended way is to setup your own gesture and let the view know.
