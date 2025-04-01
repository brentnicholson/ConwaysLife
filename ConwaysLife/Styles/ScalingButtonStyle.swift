//
//  ScalingButtonStyle.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 4/1/25.
//

import SwiftUI

struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.25 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
