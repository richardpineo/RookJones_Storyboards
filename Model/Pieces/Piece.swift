//
//  Piece.swift
//  RookJones
//
//  Created by Richard Pineo on 2/22/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

// Pieces implement this protocol which contains common piece functions
protocol Piece {

    // Returns a set of locations that can be attacked by this piece type
    func getAttackLocations(board: Board, pieceLocation: Location) -> [Location]

}

