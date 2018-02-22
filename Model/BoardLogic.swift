//
//  BoardUtil.swift
//  RookJones
//
//  Created by Richard Pineo on 2/21/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class BoardLogic {
    
    static func attackedLocations(_ board: Board) -> Set<Location> {
        var attacked = Set<Location>()
        attacked.insert(Location(1,1))
        attacked.insert(Location(5,5))
        return attacked
    }

    static func blockedLocations(_ board: Board) -> Set<Location> {
        var blocked = Set<Location>()
            for row in 0...board.numRows-1 {
                for col in 0...board.numCols-1 {
                    let loc = Location(row, col)
                    let tileType = board.getTileType(loc)
                    if( BoardLogic.doesTileBlock(tileType) ) {
                        blocked.insert(loc)
                    }
                }
            }
        return blocked
    }
    
    private static func doesTileBlock(_ t: TileType) -> Bool {
        switch(t) {
        case TileType.Wall:
            return true
        case TileType.LockedDoor:
            return true
        case TileType.WhiteRook:
            return true
        default:
            return false
        }
    }
}

