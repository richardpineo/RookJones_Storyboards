//
//  BoardError.swift
//  RookJones
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

enum BoardError: Error {
    case invalidBoardInitialization(numRows: Int, numCols: Int)
    case invalidCell(row: Int, col: Int)
    case invalidBoardFile(String)
}
