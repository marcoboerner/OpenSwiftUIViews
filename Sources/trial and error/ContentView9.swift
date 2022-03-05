////
////  ContentView8.swift
////  SwiftUI_AnimationTest
////
////  Created by Marco Boerner on 27.02.22.
////
//
//import SwiftUI
//
//struct ContentView9: View {
//
//    @State var goTo: Int = 25
//
//    var body: some View {
//        VStack {
//            Text("Hello there")
//            Spacer()
//            CustomScrollViewReader { proxy in
//                CustomScrollView() {
//                    LazyVStack {
//                        ForEach(0..<99, id: \.self) { id in
//                            ListElement8(stringNumber: "\(id)")
//                                .customID(id)
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
//                }
//                .onChange(of: goTo) { newValue in
//                    proxy.scrollTo(newValue)
//                }
//            }
//            Spacer()
//            Button {
//                goTo -= 1
//            } label: {
//                Text("GoTo")
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//    }
//}
//
//// MARK: - Reader and proxy
//
//class ScrollDestination: ObservableObject {
//    @Published var frame: CGRect = .zero
//    @Published var point: CGPoint = .zero
//}
//
//struct CustomScrollViewReader<Content>: View where Content: View {
//
//    @State var frames: [AnyHashable: CGRect] = [:]
//    @StateObject var scrollDestination = ScrollDestination()
//
//    var content: (CustomScrollViewProxy) -> Content
//
//    var body: some View {
//
//        let customScrollViewProxy = CustomScrollViewProxy(positions: frames, scrollDestination: scrollDestination)
//
//        return self.content(customScrollViewProxy)
//            .environmentObject(scrollDestination)
//            .onPreferenceChange(LocationPreferenceKey.self) { frames in
//                self.frames = frames
//            }
//    }
//}
//
//struct CustomScrollViewProxy {
//
//    static let customScrollViewCoordinateSpaceName = "CustomScrollView"
//
//    @State var positions: [AnyHashable: CGRect]
//    @ObservedObject var scrollDestination: ScrollDestination
//
//    public func scrollTo<ID>(_ id: ID, anchor: UnitPoint = .zero) where ID : Hashable {
//        guard let position = positions[id] else { return }
//
//        let x = position.minX + (position.maxX - position.minX) * anchor.x
//        let y = position.minY + (position.maxY - position.minY) * anchor.y
//
//        scrollDestination.frame = position
//        scrollDestination.point = CGPoint(x: x, y: y)
//    }
//}
//
//struct LocationPreferenceKey: PreferenceKey {
//    static func reduce(value: inout [AnyHashable : CGRect], nextValue: () -> [AnyHashable : CGRect]) {
//
//        value.merge(nextValue(), uniquingKeysWith: { (oldValue, newValue) in
//            return newValue
//        })
//    }
//    static var defaultValue: [AnyHashable: CGRect] = [:]
//}
//
//extension View {
//
//    func customID<ID>(_ value: ID) -> some View where ID: Hashable {
//
//        return GeometryReader { geometry in
//            self.body
//                .preference(key: LocationPreferenceKey.self, value: [value: geometry.frame(in: .named(CustomScrollViewProxy.customScrollViewCoordinateSpaceName))])
//        }
//    }
//}
//
//
//// MARK: - OpenScrollView
//
//struct CustomScrollView<Content>: View where Content: View {
//
//    @State private var offset: CGSize = .zero
//    @State private var accumulatedOffset: CGSize = .zero
//
//    @State var axis: Axis.Set = [.vertical]
//    @EnvironmentObject private var scrollDestination: ScrollDestination
//
//    var content: () -> Content
//
//    var body: some View {
//        GeometryReader { outerGeometry in
//            self.content()
//                .contentShape(Rectangle())
//                .background(GeometryReader { innerGeometry in
//                    EmptyView()
//                        .onChange(of: accumulatedOffset.height) { _ in
//                        if accumulatedOffset.height > 0 {
//                            accumulatedOffset.height = 0
//                        } else if abs(accumulatedOffset.height) > innerGeometry.size.height - outerGeometry.size.height {
//                            accumulatedOffset.height = -1*(innerGeometry.size.height - outerGeometry.size.height)
//                        }
//                    }
//                        .onChange(of: accumulatedOffset.width) { _ in
//                            if accumulatedOffset.width > 0 {
//                                accumulatedOffset.width = 0
//                            } else if abs(accumulatedOffset.width) > innerGeometry.size.width - outerGeometry.size.width {
//                                accumulatedOffset.width = -1*(innerGeometry.size.width - outerGeometry.size.width)
//                            }
//                        }
//                })
//                .offset(x: axis.contains(.horizontal) ? accumulatedOffset.width + offset.width : 0 , y: axis.contains(.vertical) ? accumulatedOffset.height + offset.height : 0)
//                .coordinateSpace(name: CustomScrollViewProxy.customScrollViewCoordinateSpaceName)
//                .animation(.spring(), value: offset)
//                .animation(.spring(), value: accumulatedOffset)
//                .onReceive(scrollDestination.$point) { point in
//                    accumulatedOffset.height -= point.y
//                    accumulatedOffset.width -= point.x
//                }
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            offset = gesture.translation
//                        }
//                        .onEnded { gesture in
//                            accumulatedOffset.height += gesture.translation.height
//                            accumulatedOffset.width += gesture.translation.width
//                            offset = .zero
//                        }
//                )
//        }
//    }
//}
//
//// MARK: - List Element
//
//struct ListElement8: View {
//
//    let stringNumber: String
//
//    var body: some View {
//
//        return Text("Hello World \(stringNumber)")
//    }
//}
//
//// MARK: - Preview
//
//struct ContentView9_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView9()
//    }
//}
