//
//  Level.swift
//  RookJones
//
//  Created by Richard Pineo on 2/22/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class Level {
    init(board: Board, name: String) {
        self.board = board
        self.name = name
    }
    let board: Board
    let name: String
}
