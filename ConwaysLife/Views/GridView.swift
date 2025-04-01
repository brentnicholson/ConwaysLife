//
//  GridView.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 3/30/25.
//

import SwiftUI

struct GridView: View {
    @Environment(\.gameGrid) var gameGrid: GameGrid
    
    var body: some View {
        GeometryReader { geometry in
            let cellHeight = geometry.frame(in: .global).height / CGFloat(gameGrid.rows)
            let cellWidth = geometry.frame(in: .global).width / CGFloat(gameGrid.columns)
            let cellSize = min(cellHeight, cellWidth)
            
            VStack(spacing: 0) {
                ForEach(0..<gameGrid.cells.endIndex, id: \.self) { rowIndex in
                    let row = gameGrid.cells[rowIndex]
                    HStack(spacing: 0) {
                        ForEach(0..<row.endIndex, id: \.self) { columnIndex in
                            CellView(state: row[columnIndex], action: {
                                gameGrid.toggleCell(at: GridPosition(row: rowIndex, column: columnIndex))
                            })
                            .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
            .border(Color.black, width: 2)
            .offset(x: (geometry.frame(in: .global).width - cellSize * CGFloat(gameGrid.columns)) / 2,
                    y: (geometry.frame(in: .global).height - cellSize * CGFloat(gameGrid.rows)) / 2)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    GridView()
        .environment(\.gameGrid, .default)
}
