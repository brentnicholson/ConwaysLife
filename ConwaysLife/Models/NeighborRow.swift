//
//  NeighborRow.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 4/1/25.
//

import Foundation

enum NeighborRow {
    case previous
    case current
    case next
    
    static let all = [previous, current, next]
    
    var offsets: [(Int, Int)] {
        switch self {
        case .previous:
            [(-1, -1), (-1, 0), (-1, 1)]
        case .current:
            [(0, -1), (0, 1)]
        case .next:
            [(1, -1), (1, 0), (1, 1)]
        }
    }
}
