//
//  SwiftUI_AnimationTestApp.swift
//  SwiftUI_AnimationTest
//
//  Created by Marco Boerner on 27.10.20.
//

import SwiftUI

@main
struct OpenSwiftUIViewsExample: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    Spacer()
                    NavigationLink {
                        OpenRelativeOffsetExample()
                    } label: {
                        Text("OpenRelativeOffset Example")
                    }
                    Spacer()
                    NavigationLink {
                        OpenRelativePositionExample()
                    } label: {
                        Text("OpenRelativePosition Example")
                    }
                    Spacer()
                    NavigationLink {
                        OpenScrollViewExample()
                    } label: {
                        Text("OpenScrollView Example")
                    }
                    Spacer()
                    NavigationLink {
                        OpenAlignViewExample()
                    } label: {
                        VStack {
                        Text("OpenAlignView Example")
                        Text("Recommended landscape mode and large devices for better view")
                                .font(.footnote)
                        }
                    }
                    Spacer()
                    .navigationTitle("OpenSwiftUIViews")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}
