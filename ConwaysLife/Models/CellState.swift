//
//  CellState.swift
//  ConwaysLife
//
//  Created by Brent Nicholson on 3/30/25.
//

import SwiftUI

typealias CellState = Bool

extension CellState {
    static var alive: CellState { true }
    static var dead: CellState { false }
}
