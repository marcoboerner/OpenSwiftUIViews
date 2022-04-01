//
//  OpenScrollViewExample.swift
//
//  Created by Marco Boerner on 27.02.22.
//

import SwiftUI
import OpenSwiftUIViews

struct OpenScrollViewExample: View {

    @State var goTo: Int = 50

    var body: some View {
        VStack {
            Text("Hello there")
            Spacer()
            OpenScrollViewReader { proxy in
                OpenScrollView() {
                    LazyVStack(spacing: 10) {
                        ForEach(0..<99, id: \.self) { id in
                            JustSomeElement(stringNumber: "\(id)")
                                .openScrollID(id)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .clipped()
                .onChange(of: goTo) { newValue in
                    proxy.scrollTo(newValue)
                }
            }
            Spacer()
            Button {
                goTo -= 1
            } label: {
                Text("GoTo")
            }
        }

    }
}

// MARK: - List Element

struct JustSomeElement: View {

    let stringNumber: String

    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @GestureState private var isTapping = false

    var body: some View {

        // Gets triggered immediately because a drag of 0 distance starts already when touching down.
        let tapGesture = DragGesture(minimumDistance: 0)
            .updating($isTapping) {_, isTapping, _ in
                isTapping = true
            }

        // minimumDistance here is mainly relevant to change to red before the drag
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { offset = $0.translation }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }

        let pressGesture = LongPressGesture(minimumDuration: 1.0)
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }

        // The dragGesture will wait until the pressGesture has triggered after minimumDuration 1.0 seconds.
        let combined = pressGesture.sequenced(before: dragGesture)

        // The new combined gesture is set to run together with the tapGesture.
        let simultaneously = tapGesture.simultaneously(with: combined)

        return Circle()
            .overlay(
                Text(stringNumber)
                    .foregroundColor(.green)
            )
            .overlay(isTapping ? Circle().stroke(Color.red, lineWidth: 5) : nil) //listening to the isTapping state
            .frame(width: 100, height: 100)
            .foregroundColor(isDragging ? Color.red : Color.black) // listening to the isDragging state.
            .offset(offset)
            .blockScrolling(isDragging)
            .gesture(simultaneously)
    }
}

// MARK: - Preview

struct OpenScrollViewExample_Previews: PreviewProvider {
    static var previews: some View {
        OpenScrollViewExample()
    }
}
