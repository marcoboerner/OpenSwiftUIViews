//
//  ContentView.swift
//  SwiftUI_AnimationTest
//
//  Created by Marco Boerner on 27.10.20.
//

import SwiftUI

struct ContentView5: View {

	var body: some View {
		ScrollView {

			ForEach(0..<5, id: \.self) { i in
				ListElem()
					.frame(maxWidth: .infinity)
			}
		}
		.background(Color.white)
	}
}

struct ListElem: View {

	@State private var offset = CGSize.zero

	@State private var isDragging = false
	@GestureState private var isTapping = false


	var body: some View {


		let tap = TapGesture()

		let dragGesture = DragGesture(minimumDistance: 0)
			.onChanged { offset = $0.translation }
			.onEnded { _ in
				withAnimation {
					offset = .zero
					isDragging = false
				}
			}

		let pressGesture = LongPressGesture(minimumDuration: 1.0, maximumDistance: 5.0)
			.updating($isTapping) { a, isTapping, c in
				isTapping = true
			}
			.onEnded { _ in
				withAnimation {
					isDragging = true
				}
			}

		let combined = pressGesture.sequenced(before: dragGesture)


		let exclusively = tap.exclusively(before: combined)

		return Circle()
			.overlay(isTapping ? Circle().stroke(Color.red, lineWidth: 5) : nil)
			.frame(width: 100, height: 100)
			.foregroundColor(isDragging ? Color.red : Color.black)
			.offset(offset)
			.gesture(exclusively)
	}
}


struct ContentView5_Previews: PreviewProvider {
	static var previews: some View {
		ContentView5()
	}
}
