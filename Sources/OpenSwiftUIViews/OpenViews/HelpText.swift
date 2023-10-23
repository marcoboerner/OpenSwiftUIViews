//
//  HelpText.swift
//  Doomsday Raider
//
//  Created by Marco Boerner on 24.08.23.
//

import SwiftUI

public extension View {
    func helpText(_ showHelp: Bool, _ text: String) -> some View {
        self.modifier(HelpText(show: showHelp, text: text))
    }
}

public struct HelpText: ViewModifier {
    public init(show showHelp: Bool = false, text: String) {
        self.showHelp = showHelp
        self.text = text
    }

    var showHelp: Bool = false
    var text: String

    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            if showHelp {
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
