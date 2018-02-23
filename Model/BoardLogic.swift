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
            let piece = makePiece(board.getTileType(loc))
            if( piece != nil ) {
                attacked = attacked.union(piece!.getAttackLocations(board: board, pieceLocation: loc))
            }
        }
        return Array(attacked)
    }
    
    private static func makePiece(_ tileType: TileType) -> Piece? {
        switch(tileType) {
        case TileType.WhiteRook:
            return Rook()
        default:
            return nil
        }
    }
    
    static func doesTileBlock(_ tileType: TileType) -> Bool {
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

