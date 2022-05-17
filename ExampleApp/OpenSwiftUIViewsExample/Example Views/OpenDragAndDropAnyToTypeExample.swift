//
//  OpenScrollViewExample.swift
//
//  Created by Marco Boerner on 27.02.22.
//

import SwiftUI
import OpenSwiftUIViews

struct OpenDragAndDropAnyToTypeExample: View {

    @State private var targeted: Bool = false

    var body: some View {
        OpenDragAndDropView {
            HStack {
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { id in
                            AnyToTypeTargetElement(label: "Drop destination #\(id)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    Spacer()
                }

                VStack {
                    Spacer()
                    LazyVStack(spacing: 10) {
                        ForEach(0..<5, id: \.self) { id in
                            JustAnyToTypeAnotherElement(stringNumber: "\(id)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - List Element

struct JustAnyToTypeAnotherElement: View {

    internal init(stringNumber: String) {
        self.stringNumber = stringNumber
        self.someValue = SomeValue(id: stringNumber)
    }

    let stringNumber: String
    private var someValue: SomeValue

    var body: some View {
        Circle()
            .overlay(
                Text(stringNumber)
                    .foregroundColor(.green)
            )
            .frame(width: 100, height: 100)
            .onOpenDrag(dragIdentifier: "MyValue") {
                return [someValue]
            }
    }
}

struct AnyToTypeTargetElement: View {

    var label: String
    @State private var hoover: Bool = false

    var body: some View {
        Rectangle()
            .overlay(
                Text(label)
                    .foregroundColor(.green)
            )
            .foregroundColor(hoover ? Color.red : Color.black) // listening to the isDragging state.
            .onOpenDrop(of: SomeValue.self, dragIdentifier: "MyValue", isTargeted: $hoover) { draggedItems in
                print("dropped SomeValue (from Any): \(draggedItems.first?.id ?? "nothing")")
            }
    }
}


// MARK: - Preview

struct OpenDragAndDropAnyToTypeExample_Previews: PreviewProvider {
    static var previews: some View {
        OpenDragAndDropAnyToTypeExample()
    }
}
