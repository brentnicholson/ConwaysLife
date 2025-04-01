//
//  EdgeBehavior.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 4/1/25.
//

import Foundation

enum EdgeBehavior: CaseIterable, Identifiable, CustomStringConvertible {
    case noWrap           // dead cells beyond the edge
    case wrapAround       // grid wraps around
    // Improvement:
    // case infinite      // infinite grid that expands as needed
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .noWrap:
            return "Dead"
        case .wrapAround:
            return "Wrap"
        }
    }
}
