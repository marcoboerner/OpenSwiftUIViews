//
//  OpenScrollViewExample.swift
//
//  Created by Marco Boerner on 27.02.22.
//

import SwiftUI
import OpenSwiftUIViews

struct OpenDragAndDropExample: View {

    @State private var targeted: Bool = false

    var body: some View {
        OpenDragAndDropView {
            HStack {
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { id in
                            TargetElement(label: "Drop destination #\(id)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    Spacer()
                }

                VStack {
                    Spacer()
                    LazyVStack(spacing: 10) {
                        ForEach(0..<5, id: \.self) { id in
                            JustAnotherElement(stringNumber: "\(id)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

class SomeValue: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    internal init(id: String) {
        self.id = id
    }
    static func == (lhs: SomeValue, rhs: SomeValue) -> Bool {
        lhs.id == rhs.id
    }

    let id: String
}

// MARK: - List Element

struct JustAnotherElement: View {

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
            .onOpenDrag {
                return [someValue]
            }
    }
}

struct TargetElement: View {

    var label: String
    @State private var hoover: Bool = false

    var body: some View {
        Rectangle()
            .overlay(
                Text(label)
                    .foregroundColor(.green)
            )
            .foregroundColor(hoover ? Color.red : Color.black) // listening to the isDragging state.
            .onOpenDrop(of: SomeValue.self , isTargeted: $hoover) { draggedItems in
                print("dropped #\(draggedItems)")
            }
    }
}


// MARK: - Preview

struct OpenDragAndDropExample_Previews: PreviewProvider {
    static var previews: some View {
        OpenDragAndDropExample()
    }
}
