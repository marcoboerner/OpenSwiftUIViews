////
////  ContentView7.swift
////  SwiftUI_AnimationTest
////
////  Created by Marco Boerner on 10.01.21.
////
//
//import SwiftUI
//
//struct ContentView: View {
//	
//	@State private var offset = CGSize.zero
//
//	var body: some View {
//		ScrollViewReader { scrollView in
//			ScrollView() {
//				ForEach(0..<5, id: \.self) { i in
//					ListElem(offset: $offset)
//						.frame(maxWidth: .infinity)
//						.offset(offset)
//				}
//			}
//		}
//	}
//}
//
//struct ListElem: View {
//	
//	@Binding var offset: CGSize
//	
//	//@State private var offset = CGSize.zero
//	@State private var translation = CGSize.zero
//	@State private var isDragging = false
//	@GestureState var isTapping = false
//	@GestureState var offsetState = CGSize.zero
//	
//	var body: some View {
//		
//		// Gets triggered immediately because a drag of 0 distance starts already when touching down.
//		let tapGesture = DragGesture(minimumDistance: 0)
//			.updating($isTapping) {_, isTapping, _ in
//				isTapping = true
//			}
//			.onChanged {
//				offset.height = offset.height + $0.translation.height
//				//offset.width = offset.width + $0.translation.width
//			}
//			.onEnded { value in
//				withAnimation {
//					offset = .zero
//					isDragging = false
//				}
//			}
//			
//
//	//	 minimumDistance here is mainly relevant to change to red before the drag
//		let dragGesture = DragGesture(minimumDistance: 0)
//			.onChanged { offset = $0.translation }
//			.onEnded { _ in
//				withAnimation {
//					offset = .zero
//					isDragging = false
//				}
//			}
//
//		let pressGesture = LongPressGesture(minimumDuration: 1.0)
//			.onEnded { value in
//				withAnimation {
//					isDragging = true
//				}
//			}
//		
//		// The dragGesture will wait until the pressGesture has triggered after minimumDuration 1.0 seconds.
//		let combined = pressGesture.sequenced(before: dragGesture)
//		
//		// The new combined gesture is set to run together with the tapGesture.
//		let simultaneously = tapGesture.simultaneously(with: combined)
//		
//		return Circle()
//			.overlay(isTapping ? Circle().stroke(Color.red, lineWidth: 5) : nil) //listening to the isTapping state
//			.frame(width: 100, height: 100)
//			.foregroundColor(isDragging ? Color.red : Color.green) // listening to the isDragging state.
//			//.offset(offset)
//			.gesture(simultaneously)
//	}
//}
//
//
//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
//}
//
