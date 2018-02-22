//
//  BoardLogic.swift
//  RookJones
//
//  Created by Richard Pineo on 2/21/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class BoardLogic {
    
    static func attackedLocations(_ board: Board) -> [Location] {
        var attacked = Set<Location>()
        attacked.insert(Location(1,1))
        attacked.insert(Location(5,5))
        return Array(attacked)
    }

    static func blockedLocations(_ board: Board) -> [Location] {
        return board.locations().filter { BoardLogic.doesTileBlock( board.getTileType($0) ) }
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

