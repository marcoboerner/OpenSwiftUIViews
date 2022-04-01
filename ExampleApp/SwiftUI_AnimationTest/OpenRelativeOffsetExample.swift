//  ContentView.swift
//  SameSame SwiftUI Tests
//
//  Created by Marco Boerner on 10.11.20.

import SwiftUI

struct ContentView3: View {

    @State var targetFrame: CGRect = .zero
    @State var tapped: Bool = false

    var body: some View {
        ZStack {
            VStack {

                Spacer()
                HStack {
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .openRelativeOffset(tapped ? CGPoint(x: targetFrame.midX, y: targetFrame.midY) : nil, in: .named("TARGET"))
                        .onTapGesture {
                            tapped.toggle()
                        }
                }
                .background(.brown)
                .zIndex(999)
                Spacer()
                HStack {
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.green.opacity(0.5))
                        .coordinateSpace(name: "TARGET")
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        targetFrame = geometry.frame(in: .named("TARGET"))
                                    }
                            }
                        )
                }
                .background(Color.orange.opacity(0.5))
                Spacer()
            }
        }
    }
}

struct ContentView3_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
    }
}
