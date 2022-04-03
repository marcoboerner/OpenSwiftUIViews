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
                        .background(Color.orange)
                        .lineLimit(3)
                        .openAlignOffset(column: 10, row: 11, .topLeading)

//                    Text("sit occaecat")
//                       // .openAlignOffset(column: 2, row: 1, .leading)
//                    Text("laborum amet elit")
//                      //  .openAlignOffset(column: 3, row: 1, .leading)
                }
                Spacer()
                HStack() {
//                    Text("lorem aliqua pariatur\nexcepteur aliquip labore\ndo eiusmod ipsum qui non\nfugiat fugiat")
//                        .openAlignOffset(column: 1, row: 2, .leading)
                    Text("sed dolor qui")
                        .background(Color.blue)
                        .openAlignOffset(column: 10, row: 12, .topLeading)
//                    Text("sint consectetur consectetur sit excepteur quis lorem")
//                      //  .openAlignOffset(column: 3, row: 1, .leading)
                }
                Spacer()
            }
        }
    }
}
