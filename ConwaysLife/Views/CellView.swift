//
//  CellView.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 3/30/25.
//

import SwiftUI

struct CellView: View {
    let state: CellState
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: state == true ? "heart.circle.fill" : "heart.slash.circle.fill")
                .foregroundColor(state == true ? .black.opacity(0.5) : Color(uiColor: .lightGray))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .background(state == true ? .green : .gray)
        .border(Color.black, width: 1)
        .buttonStyle(ScalingButtonStyle())
        .animation(.easeOut(duration: 0.2), value: state)
    }
}

#Preview {
    CellView(state: .alive, action: {})
        .frame(width: 50, height: 50)
}
