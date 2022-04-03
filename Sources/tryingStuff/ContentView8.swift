////
////  ContentView8.swift
////  SwiftUI_AnimationTest
////
////  Created by Marco Boerner on 27.02.22.
////
//
//import SwiftUI
//
//struct ContentView8: View {
//
//    var body: some View {
//        OpenScrollView() {
//            VStack {
//                ForEach(0..<5, id: \.self) { id in
//                    ListElem8()
//                        .frame(maxWidth: .infinity)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - OpenScrollView
//
//struct OpenScrollView<Content>: View where Content: View {
//
//    @State private var heightOffset: CGFloat = .zero
//    @State private var accumulatedHeightOffset: CGFloat = .zero
//    @State private var scrollingIsBlocked = false
//
//    var content: () -> Content
//
//    var body: some View {
//        GeometryReader { outerGeometry in
//            self.content()
//                .contentShape(Rectangle())
//                .frame(height: outerGeometry.size.height)
//                .offset(x: 0, y: accumulatedHeightOffset + heightOffset)
//                .onPreferenceChange(BlockScrollingPreferenceKey.self) { blockScrolling in
//                    self.scrollingIsBlocked = blockScrolling
//                }
//                .simultaneousGesture(
//                    DragGesture(minimumDistance: 10.0)
//                        .onChanged { gesture in
//                            heightOffset = scrollingIsBlocked ? .zero : gesture.translation.height
//                        }
//                        .onEnded { gesture in
//                            accumulatedHeightOffset += heightOffset
//                            heightOffset = .zero
//                        }
//                )
//        }
//    }
//}
//
//// MARK: - Blocking
//
////see file 10 for following implementation
//
////extension View {
////    func blockScrolling(_ value: Bool) -> some View {
////        preference(key: BlockScrollingPreferenceKey.self, value: value)
////    }
////}
////
////struct BlockScrollingPreferenceKey: PreferenceKey {
////    static var defaultValue: Bool = false
////
////    static func reduce(value: inout Bool, nextValue: () -> Bool) {
////        value = value || nextValue()
////    }
////}
//
//// MARK: - List Element
//
//struct ListElem8: View {
//
//    @State private var offset = CGSize.zero
//    @State private var isDragging = false
//    @GestureState private var isTapping = false
//
//    var body: some View {
//
//        // Gets triggered immediately because a drag of 0 distance starts already when touching down.
//        let tapGesture = DragGesture(minimumDistance: 0)
//            .updating($isTapping) {_, isTapping, _ in
//                isTapping = true
//            }
//
//        // minimumDistance here is mainly relevant to change to red before the drag
//        let dragGesture = DragGesture(minimumDistance: 0)
//            .onChanged { offset = $0.translation }
//            .onEnded { _ in
//                withAnimation {
//                    offset = .zero
//                    isDragging = false
//                }
//            }
//
//        let pressGesture = LongPressGesture(minimumDuration: 1.0)
//            .onEnded { value in
//                withAnimation {
//                    isDragging = true
//                }
//            }
//
//        // The dragGesture will wait until the pressGesture has triggered after minimumDuration 1.0 seconds.
//        let combined = pressGesture.sequenced(before: dragGesture)
//
//        // The new combined gesture is set to run together with the tapGesture.
//        let simultaneously = tapGesture.simultaneously(with: combined)
//
//        return Circle()
//            .overlay(isTapping ? Circle().stroke(Color.red, lineWidth: 5) : nil) //listening to the isTapping state
//            .frame(width: 100, height: 100)
//            .foregroundColor(isDragging ? Color.red : Color.black) // listening to the isDragging state.
//            .offset(offset)
//            .blockScrolling(isDragging)
//            .gesture(simultaneously)
//    }
//}
//
//// MARK: - Preview
//
//struct ContentView8_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView8()
//    }
//}
