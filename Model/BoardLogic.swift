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
        
        // Walk through all the pieces and add the attacked locations to the set.
        for loc in board.locations() {
            let tileType = board.getTileType(loc);
            if( !isAlly(tileType) && tileType != TileType.RookJones ) {
                let piece = makePiece(tileType)
                if( piece != nil ) {
                    attacked = attacked.union(piece!.getAttackLocations(board: board, pieceLocation: loc))
                }
            }
        }
        return Array(attacked)
    }
    
    static func hasAlliesOnBoard(_ board: Board) -> Bool {
        return board.locations().contains {
            return isAlly( board.getTileType( $0 ) )
        }
    }
    
    static func isAlly(_ tileType: TileType) -> Bool {
        switch( tileType ) {
        case TileType.BlackRook:
            return true
        default:
            return false
        }
    }
    
    static func makePiece(_ tileType: TileType) -> Piece? {
        switch(tileType) {
        case TileType.RookJones:
            return Rook()
        case TileType.BlackRook:
            return Rook()
        case TileType.WhiteRook:
            return Rook()
        case TileType.WhiteKnight:
            return Knight()
        case TileType.WhiteBishop:
            return Bishop()
        case TileType.WhiteQueen:
            return Queen()
        default:
            return nil
        }
    }
    
    static func doesTileBlock(_ tileType: TileType) -> Bool {
        switch(tileType) {
        case TileType.Wall:
            return true
        case TileType.WhiteRook:
            return true
        case TileType.WhiteKnight:
            return true
        case TileType.WhiteBishop:
            return true
        case TileType.WhiteQueen:
            return true
        case TileType.LockedDoor:
            return true
        default:
            return false
        }
    }
}

