//
//  RookJonesTests.swift
//  RookJonesTests
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import XCTest
@testable import RookJones

class RookJonesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoardLogic() {
        let boardData: Array<String> = [
            "----------",
            "-R  -    O",
            "--      --",
            "-   R-   -",
            "-    R-R -",
            "-     R- -",
            "-   -R   -",
            "- R---R  -",
            "- -----  -",
            "-  *-rx --",
            "------- R-",
            "-  ---R  -",
            "-   -R   -",
            "- R      -",
            "- R --  R-",
            "-   R    -",
            "- -   - --",
            "J - -    -",
            "----------"
        ];
        
        do {
            
            // Load it
            let board = try BoardLoader.fromAscii(boardData)
            let ascii = try BoardLoader.toAscii(board)
            XCTAssertEqual(boardData, ascii)

            // Check basics
            XCTAssertEqual(board.numRows, 19)
            XCTAssertEqual(board.numCols, 10)
            XCTAssertEqual(board.numberOfTiles(), 190)
            
            // Check specific pieces
            XCTAssertEqual(board.getTileType(Location(17, 0)), TileType.RookJones)
            XCTAssertEqual(board.getTileType(Location(100, 1)), TileType.Empty)
            
            // Check attacked squares
            let attacks = BoardLogic.attackedLocations(board)
            XCTAssertEqual(attacks.count, 54)
        }
        catch {
            XCTFail("Exception caught")
        }
    }
    
    func testLoadFromFile() {
        do {
            let paths = Bundle.main.paths( forResourcesOfType: "lvl", inDirectory: nil )
            XCTAssertGreaterThan( paths.count, 0 )
            for path in paths {
                let board = try BoardLoader.fromFile(path)
                
                // Convert back and forth to ascii to check board
                let ascii = try BoardLoader.toAscii(board)
                let board2 = try BoardLoader.fromAscii(ascii)
                XCTAssert( board == board2 );
                XCTAssert( try BoardLoader.toAscii( board2 ) == ascii )
                
                print("Loaded board (\(board.numRows)x\(board.numCols)) from \((path as NSString).lastPathComponent)")
            }
        }
        catch {
            XCTFail("Exception caught")
        }
    }
}
