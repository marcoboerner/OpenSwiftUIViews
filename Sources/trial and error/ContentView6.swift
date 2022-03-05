////
////  ContentView.swift
////  SwiftUI_AnimationTest
////
////  Created by Marco Boerner on 27.10.20.
////
//
//import SwiftUI
//
//struct ContentView6: View {
//	
//	@State private var progress: TimeInterval = 0
//	@State private var sliderMoving: Bool = false
//
//	var body: some View {
//		
//		GeometryReader { geometry in
//			
//			let padding: CGFloat = 0 //optional in case padding needs to be adjusted.
//			let adjustment: CGFloat = padding + 15
//			
//			Slider(value: $progress, in: 0 ... Double(100), onEditingChanged: { didChange in
//				
//			})
//			.padding(padding)
//			.simultaneousGesture(
//				DragGesture(minimumDistance: 0)
//					.onChanged { gesture in
//						sliderMoving = true
//						progress = TimeInterval( min(max((gesture.location.x - adjustment) / ((geometry.size.width - adjustment*2) / 100), 0), 100)  )
//						print(progress)
//					}
//					.onEnded { gesture in
//						sliderMoving = false
//					}
//			)
//			
//		}
//	}
//}
//
//
//
//struct ContentView6_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView6()
//	}
//}
//
//
//
//
