////
////  ContentView.swift
////  SwiftUI_AnimationTest
////
////  Created by Marco Boerner on 27.10.20.
////
//
//import SwiftUI
//
//struct ContentView4: View {
//	let letters = Array("Hello SwiftUI")
//	@State private var enabled = false
//	@State private var dragAmount = CGSize.zero
//	
//	var body: some View {
//		HStack(spacing: 0) {
//			ForEach(0..<letters.count) { num in
//				Text(String(letters[num]))
//					.padding(5)
//					.font(.title)
//					.background(enabled ? Color.blue : Color.red)
//					.offset(dragAmount)
//					.animation(Animation.default.delay(Double(num) / 20))
//			}
//		}
//		.gesture(
//			DragGesture()
//				.onChanged { dragAmount = $0.translation }
//				.onEnded { _ in
//					dragAmount = .zero
//					enabled.toggle()
//				}
//		)
//	}
//}
//
//// here without the self. as this is no longer required in the latest swift version
//struct ContentView4_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView4()
//	}
//}
