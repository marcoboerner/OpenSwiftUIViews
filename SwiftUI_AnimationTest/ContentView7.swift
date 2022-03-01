
//
//import SwiftUI
//
//struct ContentView: View {
//	@State private var animationAmount: CGFloat = 1
//
//	var body: some View {
//		return VStack {
//			Stepper("Scale amount", value: $animationAmount.animation(
//				Animation.spring(response: 1.5, dampingFraction: 0.2, blendDuration: 0.2)
//					.repeatCount(1, autoreverses: true)
//			), in: 1...10)
//
//			Button("Tap Me") {
//				self.animationAmount += 1
//			}
//			.padding(40)
//			.background(Color.red)
//			.foregroundColor(.white)
//			.clipShape(Circle())
//			.scaleEffect(animationAmount)
//
//		}
//	}
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
