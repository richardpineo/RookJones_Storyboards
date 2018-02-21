//
//  BoardLayout.swift
//  RookJones
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import UIKit


class Board {
    
    //MARK: Properties
    
    let numRows: Int
    let numCols: Int
    var tiles: Array<TileType>

    //MARK: Initialization
    
    init(numRows: Int, numCols: Int) throws {
        if( numRows == 0 || numCols == 0 ) {
            throw BoardError.invalidBoardInitialization(numRows: numRows, numCols: numCols)
        }
        self.numRows = numRows
        self.numCols = numCols
        self.tiles = Array(repeating: TileType.Empty, count: numRows * numCols)
    }
   
    private func NumberCells() -> Int {
        return self.numRows *  self.numCols
    }
    
    //MARK: Functions
    
    private func TileIndex(row: Int, col: Int) throws -> Int {
        if( row < 0 || row >= self.numRows || col < 0 || col >= self.numCols ) {
            throw BoardError.invalidCell(row: row, col: col)
        }
        return row + (col * self.numRows)
    }
    
    func GetTileType(row: Int, col: Int) -> TileType {
        do {
            return try self.tiles[self.TileIndex(row: row, col: col)]
        }
        catch {
            return TileType.Empty
        }
    }
    
    func SetTileType(row: Int, col: Int, tile: TileType) throws {
        try self.tiles[self.TileIndex(row: row, col: col)] = tile
    }
}
