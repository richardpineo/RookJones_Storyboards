//
//  PieceTests.swift
//  RookJonesTests
//
//  Created by Richard Pineo on 3/4/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import XCTest

class PieceTests: XCTestCase {
    
    func testRook() throws {
        let level = try Util().loadTestLevel("rook")
        let rook = Rook()
        
        // open location
        testAttacks(board: level.board, piece: rook, location: Location(3,3), attackCount: 23)

        // blocked location
        testAttacks(board: level.board, piece: rook, location: Location(4,5), attackCount: 12)
    }
}
