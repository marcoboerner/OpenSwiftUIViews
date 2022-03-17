//
//  OpenDragAndDrop_DragItem.swift
//  
//
//  Created by Marco Boerner on 06.03.22.
//

import SwiftUI

// MARK: - Drag

struct OpenDraggedItemPreferenceKey: PreferenceKey {

    static func reduce(value: inout IDLocation, nextValue: () -> IDLocation) {
        if nextValue().frame != .zero, nextValue().anchorPoint != .zero {

print("change")

            value = nextValue()
        }
    }
    static var defaultValue: IDLocation = IDLocation()
}

//public extension View {
//    /// Will set the dragged view to be read by the OpenDragAndDropReader.
//    ///  - Attention: Most likely it will have to be attached before any offset etc. modifiers.
//    func openDragItem<ID>(
//        _ isDragging: Binding<Bool>, value: ID, onDragging: ((OpenDragAndDropProxy) -> Void)? = nil, onDropping: ((OpenDragAndDropProxy) -> Void)? = nil) -> some View where ID: Hashable {
//            modifier(OpenDragItem(isDragging, value: value, onDragging: onDragging, onDropping:  onDropping))
//        }
//}
//
///// Will set the dragged view to be read by the OpenDragAndDropReader.
/////  - Attention: Most likely it will have to be attached before any offset etc. modifiers.
//public struct OpenDragItem<ID: Hashable>: ViewModifier {
//    public init(_ isDragging: Binding<Bool>, value: ID, onDragging: ((OpenDragAndDropProxy) -> Void)? = nil, onDropping: ((OpenDragAndDropProxy) -> Void)? = nil) {
//        self._isDragging = isDragging
//        self.value = value
//        self.onDragging = onDragging
//        self.onDropping = onDropping
//    }
//
//    @Binding public var isDragging: Bool
//    var value: ID
//
//    @EnvironmentObject public var openDragAndDropProxy: OpenDragAndDropProxy
//
//    public var onDragging: ((OpenDragAndDropProxy) -> Void)?
//    public var onDropping: ((OpenDragAndDropProxy) -> Void)?
//
//    public func body(content: Content) -> some View {
//
//        isDragging ? onDragging?(openDragAndDropProxy) : onDropping?(openDragAndDropProxy)
//
//        return content
//            .background(
//                GeometryReader { geometry in
//                    if isDragging {
//                        Color.clear
//                            .preference(
//                                key: OpenDraggedItemPreferenceKey.self,
//                                value: IDLocation(id: value, frame: geometry.frame(in: .global))
//                            )
//                    } else {
//                        Color.clear
//                    }
//                }
//            )
//    }
//}

// MARK: - Drag Item

public struct OpenDragItemView<ID, Content>: View where Content: View, ID: Hashable {

    public init(_ isDragging: Binding<Bool>, value: ID, content: @escaping (OpenDragAndDropProxy) -> Content) {
        self._isDragging = isDragging
        self.value = value
        self.content = content
    }

    @Binding public var isDragging: Bool
    var value: ID
    var content: (OpenDragAndDropProxy) -> Content
    @EnvironmentObject public var openDragAndDropProxy: OpenDragAndDropProxy

    public var body: some View {

        return self.content(openDragAndDropProxy)
            .background(
                GeometryReader { geometry in
                    if isDragging {
                        Color.clear
                            .preference(
                                key: OpenDraggedItemPreferenceKey.self,
                                value: IDLocation(id: value, frame: geometry.frame(in: .global))
                            )
                    } else {
                        Color.clear
                    }
                }
            )
    }
}
