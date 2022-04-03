////
////  ContentView.swift
////  SwiftUI_AnimationTest
////
////  Created by Marco Boerner on 27.10.20.
////
//
//import SwiftUI
//
//struct ContentView3: View {
//	
//	@State private var dragAmount = CGSize.zero
//	
//	var body: some View {
//		LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
//			.frame(width: 300, height: 200)
//			.clipShape(RoundedRectangle(cornerRadius: 10))
//			.offset(dragAmount)
//			.gesture(
//				DragGesture()
//					.onChanged { self.dragAmount = $0.translation}
//					.onEnded { _ in
//						withAnimation(.spring()) {
//							self.dragAmount = .zero
//						}
//					}
//			)
//		//.animation(.spring())
//	}
//}
//
//
//struct ContentView3_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView3()
//	}
//}
