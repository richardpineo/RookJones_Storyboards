//
//  util.swift
//  RookJonesTests
//
//  Created by Richard Pineo on 3/4/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func testAttacks(board: Board, piece: Piece, location: Location, attackCount: Int) {
        let attacks = piece.getAttackLocations(board: board, pieceLocation: location)
        XCTAssertEqual(attacks.count, attackCount)
    }
}

class Util {
    private func testBundle() -> Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadTestLevel(_ name: String) throws -> Level {
        let path = testBundle().path( forResource: name, ofType: "test" )
        let board = try BoardLoader.fromFile(path!)
        return Level(board: board, name: name, type: LevelType.Test)
    }
    
    func loadAllLevels() -> [Level] {
        var levels = Array<Level>()
        levels.append(contentsOf: BoardLoader.loadLevels())
        levels.append(contentsOf: loadTestLevels())
        return levels
    }
    
    func loadTestLevels() -> [Level] {
        return BoardLoader.loadLevelsOfType(bundle: testBundle(), ofType: LevelType.Test)
    }
}
