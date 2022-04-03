//
//  OpenAlignViewExample.swift
//  OpenSwiftUIViewsExample
//
//  Created by Marco Boerner on 01.04.22.
//

import Foundation
import SwiftUI
import OpenSwiftUIViews

struct OpenAlignViewExample: View {

    var body: some View {
        OpenAlignView {
            VStack(alignment: .leading) {
                Spacer()
                HStack(alignment: .top) {
                    Text("Laboris nisi aute\nenim sunt qui aute ut lorem")
                        .lineLimit(3)
                        .openAlignSize(column: 1, row: 1, .topLeading)
                    Text("XXX")
                    Text("sit occaecat")
                        .openAlignSize(column: 2, row: 1, .topLeading)
                    Text("laborum amet elit")
                        .openAlignSize(column: 3, row: 1, .topLeading)
                }
                HStack(alignment: .top) {
                    Text("lorem aliqua pariatur\nexcepteur aliquip labore\ndo eiusmod ipsum qui non\nfugiat fugiat")
                        .openAlignSize(column: 1, row: 1, .topLeading)
                    Text("sed dolor qui sint consectetur")
                        .openAlignSize(column: 2, row: 1, .topLeading)
                    Text("consectetur sit excepteur quis lorem")
                        .openAlignSize(column: 3, row: 1, .topLeading)
                }
                Spacer()
            }
        }
    }
}
