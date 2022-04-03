////
////  ContentView.swift
////  SwiftUI_AnimationTest
////
////  Created by Marco Boerner on 27.10.20.
////
//
//import SwiftUI
//
//struct ContentView2: View {
//	
//	@State private var animationAmount = 0.0
//	@State private var enabled = false
//	
//	var body: some View {
//		Button("Tap Me") {
//			self.enabled.toggle() //togling the enabled variable and changing the color and rotation.
//			withAnimation(.interpolatingSpring(stiffness: 5, damping: 1.0)) {
//				self.animationAmount += 360 //each button press we turn 360 degree more
//			}
//		}
//		.padding(50)
//		.background(enabled ? Color.red : Color.blue)
//		.animation(.default) //this animates everything above. The animation for the rotation is set in the
//		.foregroundColor(.white)
//		.clipShape(Circle())
//		.rotation3DEffect(
//			.degrees(animationAmount),
//			axis: enabled ? (x: 0, y: 1, z: 0) : (x: 1, y: 0, z: 0))
//		//.animation(.interpolatingSpring(stiffness: 5, damping: 1.0))
//	}
//}
//
//// very interesting how if I use the animation below the rotation effect it's acting different than when I use it in the button part.
//
//struct ContentView2_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView2()
//    }
//}
