//
//  Bishop.swift
//  RookJones
//
//  Created by Richard Pineo on 2/22/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class Bishop : Piece {
    func getAttackLocations(board: Board, pieceLocation: Location) -> [Location] {
        var attacks = Array<Location>()
        
        // Walk in each direction until blocked or off the board
        let movements = [
            Location(1, 1),
            Location(-1, -1),
            Location(-1, 1),
            Location(1, -1)
        ]
        
        for movement in movements {
            var loc = pieceLocation.offset(movement)
            while( board.isLocationValid(loc) && !BoardLogic.doesTileBlock(board.getTileType(loc))) {
                attacks.append( loc )
                loc = loc.offset(movement)
            }
        }
        
        return attacks
    }
}
