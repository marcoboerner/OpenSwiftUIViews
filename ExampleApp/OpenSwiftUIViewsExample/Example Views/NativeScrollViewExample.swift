//
//  OpenScrollViewExample.swift
//
//  Created by Marco Boerner on 27.02.22.
//

import SwiftUI
import OpenSwiftUIViews

import UIKit

extension UIScrollView {
    open override var clipsToBounds: Bool {
        get { false }
        set { }
    }
}

struct NativeScrollViewExample: View {

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                    Button {
                        proxy.scrollTo(30, anchor: .top)
                    } label: {
                        Text("Go to 30, .top")
                    }
                    .padding(10)
                    ForEach(0..<40, id: \.self) { id in
                        JustSomeElement(stringNumber: "\(id)")
                            .id(id)
                            .frame(maxWidth: .infinity)
                    }
            }
        }
    }
}

// MARK: - Preview

struct OpenGoToViewExample_Previews: PreviewProvider {
    static var previews: some View {
        NativeScrollViewExample()
    }
}
