//
//  BaseTests.swift
//  RookJonesTests
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

@testable import RookJones
import XCTest

class BaseTests: XCTestCase {
    func testBoardLogic() throws {
        let level = try Util().loadTestLevel("logic")

        // Check basics
        XCTAssertEqual(level.board.numRows, 19)
        XCTAssertEqual(level.board.numCols, 10)
        XCTAssertEqual(level.board.numberOfTiles(), 190)

        // Check specific pieces
        XCTAssertEqual(level.board.getTileType(Location(17, 0)), TileType.RookJones)
        XCTAssertEqual(level.board.getTileType(Location(100, 1)), TileType.Empty)

        // Check attacked squares
        let attacks = BoardLogic.attackedLocations(level.board)
        XCTAssertEqual(attacks.count, 54)
    }

    func testBadBoards() throws {
        let level = try Util().loadTestLevel("bad - two rook jones")
        do {
            try BoardLogic.checkBoardValid(level.board)
            XCTFail("Should not get here")
        } catch let BoardError.invalidBoardDefinition(errorMessage) {
            XCTAssert(errorMessage.count > 0)
        }
    }

    func testLoadFromFile() throws {
        let util = Util()
        let levels = util.loadAllLevels()
        XCTAssertGreaterThan(levels.count, 0)
        for level in levels {
            // Convert back and forth to ascii to check board
            let ascii = try BoardLoader.toAscii(level.board)
            let board2 = try BoardLoader.fromAscii(ascii)
            XCTAssert(level.board == board2)
            XCTAssert(try BoardLoader.toAscii(board2) == ascii)

            print("Loaded \(level.type) board \(level.name): (\(level.board.numRows)x\(level.board.numCols))")
        }
    }
}
