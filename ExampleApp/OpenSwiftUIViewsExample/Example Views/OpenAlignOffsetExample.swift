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
                    Text("Laboris nisi aute\nenim sunt\n qui aute ut lorem")

                        .openAlignSize(column: 10, row: 77, .leading)
                        .background(Color.orange)
                        .openAlignOffset(column: 10, row: 77, .leading)




                    Text("sit occaecat")

                        .openAlignSize(column: 11, row: 77, .leading)
                        .background(Color.green)
                        .openAlignOffset(column: 11, row: 77, .leading)



                    Text("laborum amet elit")
                        .background(Color.orange)
                      //  .openAlignOffset(column: 12, row: 10, .leading)
                }
                Spacer()
                HStack() {
                    Text("lorem aliqua pariatur\nexcepteur aliquip labore\ndo eiusmod ipsum qui non\nfugiat fugiat")
                        .openAlignSize(column: 10, row: 88, .leading)
                        .background(Color.orange)
                        .openAlignOffset(column: 10, row: 88, .leading)



                    Text("sed dolor qui")
                        .openAlignOffset(column: 11, row: 88, .leading)
                        .background(Color.green)
                        .openAlignSize(column: 11, row: 88, .leading)



                    Text("sint consectetur consectetur sit excepteur quis lorem")
                        .background(Color.orange)
                   //     .openAlignOffset(column: 12, row: 11, .leading)
                }
                Spacer()
            }
        }
    }
}

// FIXME: - I think right now it's possible by using offset that column 2 won't always be column two, it could even be after three of one is using trailing and the other leading. hmm
// FIXME: - Currently when I add also the align view, it gets pretty big and over the edge of the screen. Maybe there is a way of clipping it or keeping the size contained. Try with custom coordinate space maybe
