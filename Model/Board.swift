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
   
    private func numberOfTiles() -> Int {
        return self.numRows *  self.numCols
    }
    
    //MARK: Functions
    
    private func arrayIndex(_ loc: Location) throws -> Int {
        if( loc.row < 0 || loc.row >= self.numRows || loc.col < 0 || loc.col >= self.numCols ) {
            throw BoardError.invalidCell(loc)
        }
        return loc.row + (loc.col * self.numRows)
    }
    
    func getTileType(_ loc: Location) -> TileType {
        do {
            return try self.tiles[self.arrayIndex(loc)]
        }
        catch {
            return TileType.Empty
        }
    }
    
    func setTileType(location: Location, tileType: TileType) throws {
        try self.tiles[self.arrayIndex(location)] = tileType
    }
}
