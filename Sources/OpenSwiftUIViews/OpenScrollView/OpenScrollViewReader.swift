//
//  OpenScrollViewReader.swift
//  SwiftUI_AnimationTest
//
//  Created by Marco Boerner on 03.03.22.
//

import Foundation
import SwiftUI

// MARK: - OpenScrollViewReader

/// Use with OpenScrollView to programmatically scroll to a specific location identified and set with the customID modifier.
public struct OpenScrollViewReader<Content>: View where Content: View {

    public init(content: @escaping (OpenScrollViewProxy) -> Content) {
        self.content = content
    }

    @State private var frames: [AnyHashable: CGRect] = [:]
    @State private var scrollDestination = ScrollDestination()

    var content: (OpenScrollViewProxy) -> Content

    public var body: some View {

        let openScrollViewProxy = OpenScrollViewProxy(frames: frames, scrollDestination: scrollDestination)

        return self.content(openScrollViewProxy)
            .onPreferenceChange(DestinationPreferenceKey.self) { destination in
                self.scrollDestination = destination
            }
            .onPreferenceChange(LocationPreferenceKey.self) { newFrames in
                self.frames = newFrames
            }
    }
}
