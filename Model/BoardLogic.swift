//
//  BoardLogic.swift
//  RookJones
//
//  Created by Richard Pineo on 2/21/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class BoardLogic {
    
    static func blockedLocations(_ board: Board) -> [Location] {
        return board.locations().filter { BoardLogic.doesTileBlock( board.getTileType($0) ) }
    }
    
    static func attackedLocations(_ board: Board) -> [Location] {
        var attacked = Set<Location>()
        
        // Walk through all the pieces and add the attacked locations to the set.
        for loc in board.locations() {
            
            let tileType = board.getTileType(loc)
            switch(tileType) {
            case TileType.WhiteRook:
                attacked = attacked.union(getRookAttacks(board: board, rookLocation: loc))
            default:
                break;
            }
        }
        return Array(attacked)
    }
    
    private static func getRookAttacks(board: Board, rookLocation: Location) -> [Location] {
        var attacks = Array<Location>()
        
        // Walk in each direction until blocked or off the board
        let movements = [
            Location(1, 0),
            Location(-1, 0),
            Location(0, 1),
            Location(0, -1)
        ]
        
        for movement in movements {
            var loc = rookLocation.offset(movement)
            while( board.isLocationValid(loc) && !doesTileBlock(board.getTileType(loc))) {
                attacks.append( loc )
                loc = loc.offset(movement)
            }
        }
        
        return attacks
    }
    
    private static func doesTileBlock(_ tileType: TileType) -> Bool {
        switch(tileType) {
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

