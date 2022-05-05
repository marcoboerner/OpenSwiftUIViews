//  ContentView.swift
//  SameSame SwiftUI Tests
//
//  Created by Marco Boerner on 10.11.20.

import SwiftUI
import OpenSwiftUIViews

struct OpenRelativePositionExample: View {

    @State private var targetFrame: CGRect = .zero
    @State private var tapped: Bool = false

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
                                    }.onChange(of: geometry.frame(in: .named("TARGET"))) { newValue in
                                        targetFrame = newValue
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

struct OpenRelativePositionExample_Previews: PreviewProvider {
    static var previews: some View {
        OpenRelativePositionExample()
    }
}
