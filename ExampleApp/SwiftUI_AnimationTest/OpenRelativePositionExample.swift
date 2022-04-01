//  ContentView.swift
//  SameSame SwiftUI Tests
//
//  Created by Marco Boerner on 10.11.20.

import SwiftUI

struct ContentView2: View {

    @State var targetFrame: CGRect = .zero
    @State var tapped: Bool = false

    var body: some View {
            VStack {
                Spacer()
                HStack {
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                        .coordinateSpace(name: "TARGET")
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        targetFrame = geometry.frame(in: .named("TARGET"))
                                        print(targetFrame)
                                    }
                            }
                        )
                        .position(CGPoint(x: 100, y: 120))
                }
                .background(Color.orange.opacity(0.5))
                Spacer()
                HStack {
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .openRelativePosition(tapped ? CGPoint(x: targetFrame.midX, y: targetFrame.midY) : nil, in: .named("TARGET"))
                        .onTapGesture {
                            tapped.toggle()
                        }
                }
                .background(.brown)
                Spacer()
            }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
