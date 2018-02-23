//
//  BoardLayout.swift
//  RookJones
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import UIKit

class Board: Equatable {
    
    let numRows: Int
    let numCols: Int
    var tiles: Array<TileType>
    
    init(numRows: Int, numCols: Int) throws {
        if( numRows == 0 || numCols == 0 ) {
            throw BoardError.invalidBoardInitialization(numRows: numRows, numCols: numCols)
        }
        self.numRows = numRows
        self.numCols = numCols
        self.tiles = Array(repeating: TileType.Empty, count: numRows * numCols)
    }
    
    public static func == (lhs: Board, rhs: Board) -> Bool {
        return lhs.tiles == rhs.tiles
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
    
    // Returns all the locations on this board
    func locations() -> [Location] {
        var locs = Array<Location>()
        for row in 0...numRows-1 {
            for col in 0...numCols-1 {
                locs.append(Location(row, col))
            }
        }
        return locs
    }
    
    func isLocationValid(_ loc: Location) -> Bool {
        return loc.row >= 0 && loc.row < self.numRows && loc.col >= 0 && loc.col < self.numCols
    }
    
    func numberOfTiles() -> Int {
        assert(self.numRows * self.numCols == self.tiles.count)
        return self.tiles.count;
    }
    
    private func arrayIndex(_ loc: Location) throws -> Int {
        if( !isLocationValid(loc) ) {
            throw BoardError.invalidCell(loc)
        }
        return loc.row + (loc.col * self.numRows)
    }
}
