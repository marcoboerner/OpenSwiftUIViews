//
//  OpenAlignViewExample.swift
//  OpenSwiftUIViewsExample
//
//  Created by Marco Boerner on 01.04.22.
//

import Foundation
import SwiftUI
import OpenSwiftUIViews

struct OpenAlignOffsetExample: View {

    var body: some View {
        OpenAlignView {
            VStack(alignment: .leading) {
                Spacer()
                HStack() {
                    Text("XXX")
                        .background(Color.yellow)
                    Text("Laboris nisi aute\nenim sunt qui aute ut lorem")
                        .lineLimit(3)
                        .background(Color.orange)
                        .openAlignOffset(column: 10, row: 10, .leading)

                    Text("sit occaecat")
                        .background(Color.green)
                        .openAlignOffset(column: 11, row: 10, .trailing)
                    Text("laborum amet elit")
                        .background(Color.orange)
                        .openAlignOffset(column: 12, row: 10, .topTrailing)
                }
                Spacer()
                HStack() {
                    Text("lorem aliqua pariatur\nexcepteur aliquip labore\ndo eiusmod ipsum qui non\nfugiat fugiat")
                        .background(Color.orange)
                        .openAlignOffset(column: 10, row: 11, .leading)
                    Text("sed dolor qui")
                        .background(Color.green)
                        .openAlignOffset(column: 11, row: 11, .trailing)

                    Text("sint consectetur consectetur sit excepteur quis lorem")
                        .background(Color.orange)
                        .openAlignOffset(column: 12, row: 11, .topTrailing)
                }
                Spacer()
            }
        }
    }
}

// FIXME: - I think right now it's possible by using offset that column 2 won't always be column two, it could even be after three of one is using trailing and the other leading. hmm
// FIXME: - Currently when I add also the align view, it gets pretty big and over the edge of the screen. Maybe there is a way of clipping it or keeping the size contained. Try with custom coordinate space maybe
