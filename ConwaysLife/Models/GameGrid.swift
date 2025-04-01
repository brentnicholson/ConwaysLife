//
//  GameGrid.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 3/30/25.
//

import Foundation
import SwiftUI

enum GameState {
    case seeding
    case running
    case completed
}

@Observable
final class GameGrid {
    private(set) var cells: [[CellState]]
    private(set) var generation: Int = 0
    private(set) var state: GameState = .seeding
    
    var edgeBehavior: EdgeBehavior
    
    let rows: Int
    let columns: Int
    
    init(rows: Int, columns: Int, edgeBehavior: EdgeBehavior = .noWrap) {
        self.rows = rows
        self.columns = columns
        self.edgeBehavior = edgeBehavior
        self.cells = Array(repeating: Array(repeating: .dead, count: columns), count: rows)
    }
    
    func start() {
        guard state == .seeding else {
            return
        }
        
        state = .running
        nextGeneration()
    }
    
    func restart() {
        state = .seeding
        cells = Array(repeating: Array(repeating: .dead, count: columns), count: rows)
        generation = 0
    }
    
    func toggleCell(at position: GridPosition) {
        guard state == .seeding, position.row >= 0 && position.row < rows && position.column >= 0 && position.column < columns else {
            return
        }
        
        cells[position.row][position.column] = !cells[position.row][position.column]
    }
    
    /// nextGeneration
    /// - Parameter generationCount: Number of generations to move iterate through
    /// Implementation notes: It was chosen to allocate the minimum number of rows required to calculate the next generation. This is done to avoid allocating a new grid for each generation and potential future support for the infinite edge behavior.
    /// Further improvements could be made by keeping track of the living cells and only iterating through those cells and it's adjacent neighbors. This would reduce the number of cells that need to be checked each generation.
    func nextGeneration(generationCount: Int = 1) {
        switch edgeBehavior {
        case .noWrap:
            nextGenerationNoWrap(generationCount: generationCount)
        case .wrapAround:
            nextGenerationWrapAround(generationCount: generationCount)
        }
    }
    
    private func nextGenerationNoWrap(generationCount: Int = 1) {
        guard edgeBehavior == .noWrap else {
            assertionFailure("nextGenerationNoWrap should only be called when edgeBehavior is .noWrap")
            return
        }
        
        for _ in 0..<generationCount {
            var shouldContinue = false
            
            var previousRow: [CellState] = Array(repeating: .dead, count: columns)
            var updatingRow: [CellState] = Array(repeating: .dead, count: columns)
            
            for (rowIndex, row) in cells.enumerated() {
                for (columnIndex, _) in row.enumerated() {
                    let position = GridPosition(row: rowIndex, column: columnIndex)
                    let neighborPositions = neighborPositions(for: position, in: NeighborRow.all)
                    
                    let previousRowNeighbors = neighborPositions[.previous]?.map { previousRow[$0.column] } ?? []
                    let currentRowNeighbors = neighborPositions[.current]?.map { row[$0.column] } ?? []
                    let nextRowNeighbors = neighborPositions[.next]?.map { cells[$0.row][$0.column] } ?? []
                    
                    let neighborStates = previousRowNeighbors + currentRowNeighbors + nextRowNeighbors
                    let livingNeighbors = neighborStates.filter { $0 == .alive }.count
                    
                    if livingNeighbors == 3 || (row[columnIndex] == .alive && livingNeighbors == 2) {
                        updatingRow[columnIndex] = .alive
                        shouldContinue = true
                    }
                }
                
                previousRow = row
                cells[rowIndex] = updatingRow
                updatingRow = Array(repeating: .dead, count: columns)
            }
            
            generation += 1
            
            if !shouldContinue {
                state = .completed
                return
            }
        }
    }
    
    private func nextGenerationWrapAround(generationCount: Int = 1) {
        guard edgeBehavior == .wrapAround else {
            assertionFailure("nextGenerationWrapAround should only be called when edgeBehavior is .wrapAround")
            return
        }
        
        guard let lastRow = cells.last, let firstRow = cells.first else {
            assertionFailure("nextGenerationWrapAround should only be called when there are cells in the grid")
            return
        }
        
        for _ in 0..<generationCount {
            var shouldContinue = false
            
            var previousRow: [CellState] = lastRow
            var updatingRow: [CellState] = Array(repeating: .dead, count: columns)
            
            for (rowIndex, row) in cells.enumerated() {
                let nextRow = rowIndex + 1 == cells.count ? firstRow : cells[rowIndex + 1]
                
                for (columnIndex, _) in row.enumerated() {
                    let position = GridPosition(row: rowIndex, column: columnIndex)
                    let neighborPositions = neighborPositions(for: position, in: NeighborRow.all)
                    
                    let previousRowNeighbors = neighborPositions[.previous]?.map { previousRow[$0.column] } ?? []
                    let currentRowNeighbors = neighborPositions[.current]?.map { row[$0.column] } ?? []
                    let nextRowNeighbors = neighborPositions[.next]?.map { nextRow[$0.column] } ?? []
                    
                    let neighborStates = previousRowNeighbors + currentRowNeighbors + nextRowNeighbors
                    let livingNeighbors = neighborStates.filter { $0 == .alive }.count
                    
                    if livingNeighbors == 3 || (row[columnIndex] == .alive && livingNeighbors == 2) {
                        updatingRow[columnIndex] = .alive
                        shouldContinue = true
                    }
                }
                
                previousRow = row
                cells[rowIndex] = updatingRow
                updatingRow = Array(repeating: .dead, count: columns)
            }
            
            generation += 1
            
            if !shouldContinue {
                state = .completed
                return
            }
        }
    }
    
    private func neighborPositions(for position: GridPosition, in rows: [NeighborRow]) -> [NeighborRow: [GridPosition]] {
        rows.reduce(into: [NeighborRow: [GridPosition]]()) { result, row in
            result[row] = positionsFrom(position: position, offsets: row.offsets)
        }
    }
    
    private func positionsFrom(position: GridPosition, offsets: [(Int, Int)]) -> [GridPosition] {
        var neighbors: [GridPosition] = []
        for (rowOffset, columnOffset) in offsets {
            let neighborRow = position.row + rowOffset
            let neighborColumn = position.column + columnOffset
            
            // Account for edge behavior
            switch edgeBehavior {
            case .noWrap:
                // Since we're not wrapping around, make sure the neighbor is within the grid
                guard neighborRow >= 0 && neighborRow < rows && neighborColumn >= 0 && neighborColumn < columns else { continue }
                neighbors.append(.init(row: neighborRow, column: neighborColumn))
            case .wrapAround:
                // Since we're wrapping around, adjust the neighbor indeces to wrap around the grid
                let wrappedRow = (neighborRow + rows) % rows
                let wrappedColumn = (neighborColumn + columns) % columns
                neighbors.append(.init(row: wrappedRow, column: wrappedColumn))
            }
        }
        
        return neighbors
    }
}

extension GameGrid {
    static let `default` = GameGrid(rows: 10, columns: 10, edgeBehavior: .noWrap)
}
