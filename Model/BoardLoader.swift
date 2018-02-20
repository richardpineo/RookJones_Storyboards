//
//  BoardLoader.swift
//  RookJones
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

struct BoardLoader {
    
    static func FromFile(_ path: String) throws -> Board {
        let boardDataString = try NSString( contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        let boardData = String(boardDataString).split( separator: "\n" ).map { String($0) }
        return try BoardLoader.FromAscii(boardData)
    }

    static func FromAscii(_ boardData: Array<String>) throws -> Board {
        let numRows = boardData.count;
        if(numRows == 0) {
            throw BoardError.invalidBoardFile("No rows round");
        }
        let numCols = boardData[0].count;
        for index in 1...(numRows-1) {
            let colCountForRow = boardData[index].count;
            if(numCols != colCountForRow) {
                throw BoardError.invalidBoardFile("Row \(index) had \(colCountForRow) columns, expected \(numCols)");
            }
        }
        let board = try Board(numRows: numRows, numCols: numCols)
        for row in 0...numRows-1 {
            let rowData = boardData[row];
            for col in 0...numCols-1 {
                let char = rowData[rowData.index(rowData.startIndex, offsetBy: col)]
                let type = try TileTypeFromChar(char)
                try board.SetTileType(row: row, col: col, tile: type)
            }
        }
        return board;
    }
    
    private static func TileTypeFromChar(_ c: Character) throws -> TileType {
        switch( c ) {
        case " ":
            return TileType.Empty
        case "-":
            return TileType.Wall
        case "x":
            return TileType.LockedDoor
        case "R":
            return TileType.WhiteRook
        case "r":
            return TileType.BlackRook
        case "*":
            return TileType.Key
        case "J":
            return TileType.RookJones
        case "O":
            return TileType.Exit
        default:
            throw BoardError.invalidBoardFile("Unknown character found \(c)")
        }
    }
}
