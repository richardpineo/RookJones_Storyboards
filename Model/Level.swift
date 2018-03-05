//
//  Level.swift
//  RookJones
//
//  Created by Richard Pineo on 2/22/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

enum LevelType {
    case Test
    case Real
}

class Level {
    init(board: Board, name: String, type: LevelType) {
        self.board = board
        self.name = name
        self.type = type
    }
    let board: Board
    let name: String
    let type: LevelType
}
