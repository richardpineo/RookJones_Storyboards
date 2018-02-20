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
    
    func testLoad() {
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
            let board = try BoardFromAscii(boardData)
            XCTAssertEqual(board.numRows, 19)
            XCTAssertEqual(board.numCols, 10)
        }
        catch {
            XCTFail("Exception caught")
        }
    }
    
    func testLoadFromFile() {
        do {
            let path = Bundle.main.path( forResource: "Level13", ofType: "lvl")
            let boardDataString = try NSString( contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            let boardData = String(boardDataString).split( separator: "\n" ).map { String($0) }
            let board = try BoardFromAscii(boardData)
            XCTAssertEqual(board.numRows, 19)
            XCTAssertEqual(board.numCols, 10)
        }
        catch {
            XCTFail("Exception caught")
        }
    }
}
