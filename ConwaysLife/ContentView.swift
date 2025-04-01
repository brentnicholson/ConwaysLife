//
//  ContentView.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 3/30/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.gameGrid) var gameGrid
    
    var body: some View {
        VStack {
            Text(generationText)
                .font(.headline)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            GridView()
            
            HStack {
                Button(buttonTitle) {
                    buttonAction()
                }
                .buttonStyle(.bordered)
                
                if gameGrid.state == .seeding {
                    // Gross, but only way we can bind to the gameGrid while it's an @Environment
                    @Bindable var gameGrid = gameGrid
                    
                    HStack(spacing: 0) {
                        Text("Edge Behavior:")
                        Picker("", selection: $gameGrid.edgeBehavior) {
                            ForEach(EdgeBehavior.allCases) { behavior in
                                Text(String(describing: behavior))
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.leading, 20)
                }
                
                if gameGrid.state == .running {    
                    Button("Restart") {
                        gameGrid.restart()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
    
    var generationText: String {
        switch gameGrid.state {
        case .seeding:
            return "Click on cells to configure initial state"
        case .running:
            return "Generation: \(gameGrid.generation)"
        case .completed:
            return "Life ended at generation \(gameGrid.generation)"
        }
    }
    
    var buttonTitle: String {
        switch gameGrid.state {
        case .seeding:
            return "Start"
        case .running:
            return "Next Generation"
        case .completed:
            return "Restart"
        }
    }
    
    func buttonAction() -> Void {
        switch gameGrid.state {
        case .seeding:
            return gameGrid.start()
        case .running:
            return gameGrid.nextGeneration()
        case .completed:
            return gameGrid.restart()
        }
    }
}

#Preview {
    ContentView()
}
