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
        testAttacks(board: level.board, piece: rook, location: Location(3, 3), attackCount: 23)

        // blocked location
        testAttacks(board: level.board, piece: rook, location: Location(4, 5), attackCount: 12)
    }

    func testKnight() throws {
        let level = try Util().loadTestLevel("knight")
        let knight = Knight()

        // open location
        testAttacks(board: level.board, piece: knight, location: Location(4, 4), attackCount: 8)

        // blocked location
        testAttacks(board: level.board, piece: knight, location: Location(11, 5), attackCount: 4)
    }

    func testBishop() throws {
        let level = try Util().loadTestLevel("bishop")
        let bishop = Bishop()

        // open location
        testAttacks(board: level.board, piece: bishop, location: Location(9, 5), attackCount: 14)

        // blocked location
        testAttacks(board: level.board, piece: bishop, location: Location(3, 5), attackCount: 11)
    }

    func testQueen() throws {
        let level = try Util().loadTestLevel("queen")
        let queen = Queen()

        // open location
        testAttacks(board: level.board, piece: queen, location: Location(9, 5), attackCount: 37)

        // blocked location
        testAttacks(board: level.board, piece: queen, location: Location(3, 5), attackCount: 25)
    }
}
