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
                VStack(spacing: 20) {
                    NavigationLink {
                        OpenRelativeOffsetExample()
                    } label: {
                        Text("OpenRelativeOffset Example")
                    }
                    NavigationLink {
                        OpenRelativePositionExample()
                    } label: {
                        Text("OpenRelativePosition Example")
                    }
                    NavigationLink {
                        OpenScrollViewExample()
                    } label: {
                        Text("OpenScrollView Example")
                    }
                    NavigationLink {
                        OpenDragAndDropExample()
                    } label: {
                        Text("OpenDragAndDrop Example")
                    }
                    NavigationLink {
                        OpenDragAndDropAnyExample()
                    } label: {
                        Text("OpenDragAndDrop (Any) Example")
                    }
                    NavigationLink {
                        OpenDragAndDropAnyToTypeExample()
                    } label: {
                        Text("OpenDragAndDrop (Any with Type) Example")
                    }
                    NavigationLink {
                        OpenAlignOffsetExample()
                    } label: {
                        Text("OpenAlignOffset Example")
                    }
                    NavigationLink {
                        OpenAlignViewExample()
                    } label: {
                        VStack {
                        Text("OpenAlignView Example")
                        Text("Recommended landscape mode and large devices for better view")
                                .font(.footnote)
                        }
                    }
                }
                    .navigationTitle("OpenSwiftUIViews")
                    .navigationBarTitleDisplayMode(.inline)

            }
        }
    }
}
