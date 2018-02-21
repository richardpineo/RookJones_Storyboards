//
//  ScreenLocation.swift
//  RookJones
//
//  Created by Richard Pineo on 2/20/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class TileIndex: Hashable {
    init( row: Int, col: Int ) {
        self.row = row
        self.col = col
    }
    
    static func FromBoard(board: Board, row: Int, col: Int) -> TileIndex {
        return TileIndex(row: board.numRows - row - 1, col: col )
    }
    
    public var hashValue: Int {
        return row.hashValue ^ col.hashValue
    }
    
    public static func == (lhs: TileIndex, rhs: TileIndex) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    let row: Int
    let col: Int
}

