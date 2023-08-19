//
//  PickerStride.swift
//
//
//  Created by Marco Boerner on 19.08.23.
//

import SwiftUI

public struct PickerStride<T, Label, Selection, Content>: View where T: Strideable, T: Hashable, Label: View, Selection: View, Content: View  {
    public init(
        selection: Binding<T?>,
        from start: T,
        through: T? = nil,
        by steps: T.Stride,
        content: @escaping (T) -> Content,
        emptySelection: @escaping () -> Selection,
        label: @escaping () -> Label
    ) {
        self._selection = selection
        self.start = start
        self.through = through
        self.steps = steps
        self.content = content
        self.emptySelection = emptySelection
        self.label = label
    }

    public init(
        selection: Binding<T?>,
        from start: T,
        to: T? = nil,
        by steps: T.Stride,
        content: @escaping (T) -> Content,
        emptySelection: @escaping () -> Selection,
        label: @escaping () -> Label
    ) {
        self._selection = selection
        self.start = start
        self.to = to
        self.steps = steps
        self.content = content
        self.emptySelection = emptySelection
        self.label = label
    }

    @Binding private var selection: T?
    private var start: T
    private var through: T?
    private var to: T?
    private var steps: T.Stride
    @ViewBuilder private var content: (T) -> Content
    @ViewBuilder private var emptySelection: () -> Selection
    @ViewBuilder private var label: () -> Label

    public var body: some View {
        Picker(selection: $selection) {
            if let end = through {
                ForEach(Array(stride(from: start, through: end, by: steps)), id: \.self) {
                    content($0)
                        .tag($0 as T?)
                }
            } else if let end = to {
                ForEach(Array(stride(from: start, to: end, by: steps)), id: \.self) {
                    content($0)
                        .tag($0 as T?)
                }
            }
            emptySelection()
                .tag(nil as T?)
        } label: {
            label()
        }
    }
}
