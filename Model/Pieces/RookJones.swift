//
//  Rook.swift
//  RookJones
//
//  Created by Richard Pineo on 2/22/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class RookJones : Piece {
    init(hasKey: Bool, hasAllies: Bool) {
        self.hasKey = hasKey
        self.hasAllies = hasAllies
    }
    
    private let hasAllies: Bool
    private let hasKey: Bool
    
    func getAttackLocations(board: Board, pieceLocation: Location) -> [Location] {
        
        // Rook jones acts a lot like a rook, but can 'attack' doors
        
        var attacks = Array<Location>()
        
        // Walk in each direction until blocked or off the board
        let movements = [
            Location(1, 0),
            Location(-1, 0),
            Location(0, 1),
            Location(0, -1)
        ]
        
        for movement in movements {
            var loc = pieceLocation.offset(movement)
            while( board.isLocationValid(loc) ) {
                let tileType = board.getTileType(loc);
                
                // Allow attacking a locked door, but don't continue to move
                if( self.hasKey && tileType == TileType.LockedDoor )
                {
                    attacks.append( loc )
                    break;
                }
                
                // Don't allow the exit if there are any allies left on the board
                if( self.hasAllies && tileType == TileType.Exit ) {
                    break;
                }
                
                // If this is a blocking tile like a wall, then stop
                if( BoardLogic.doesTileBlock(tileType) ) {
                    break;
                }
                
                // This one is good, add it in and keep walking.
                attacks.append( loc )
                loc = loc.offset(movement)
            }
        }
        
        return attacks
    }
}
