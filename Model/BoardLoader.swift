//
//  BoardLoader.swift
//  RookJones
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

struct BoardLoader {
    
    static func fromFile(_ path: String) throws -> Board {
        let boardDataString = try NSString( contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        let boardData = String(boardDataString).split( separator: "\n" ).map { String($0) }
        return try BoardLoader.fromAscii(boardData)
    }

    static func fromAscii(_ boardData: Array<String>) throws -> Board {
        let numRows = boardData.count;
        if(numRows == 0) {
            throw BoardError.invalidBoardDefinition("No rows round");
        }
        let numCols = boardData[0].count;
        for index in 1...(numRows-1) {
            let colCountForRow = boardData[index].count;
            if(numCols != colCountForRow) {
                throw BoardError.invalidBoardDefinition("Row \(index) had \(colCountForRow) columns, expected \(numCols)");
            }
        }
        let board = try Board(numRows: numRows, numCols: numCols)
        for row in 0...numRows-1 {
            let rowData = boardData[row];
            for col in 0...numCols-1 {
                let loc = Location(row, col)
                let char = rowData[rowData.index(rowData.startIndex, offsetBy: col)]
                let type = try tileTypeFromChar(char)
                try board.setTileType(location: loc, tileType: type)
            }
        }
        return board;
    }
    
    static func toAscii(_ board: Board ) throws -> Array<String> {
        var ascii = Array<String>()
        for row in 0...board.numRows-1 {
            var line = "";
            for col in 0...board.numCols-1 {
                let loc = Location(row, col)
                let type = board.getTileType(loc)
                let char = try charFromTileType(type)
                line.append(char)
            }
            ascii.append(line)
        }
        return ascii
    }
    
    private static func tileTypeFromChar(_ c: Character) throws -> TileType {
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
            throw BoardError.invalidBoardDefinition("Unknown character found \(c)")
        }
    }
    
    private static func charFromTileType(_ t: TileType) throws -> Character {
        switch( t ) {
            case TileType.Empty:
                return " "
            case TileType.Wall:
                return "-"
            case TileType.LockedDoor:
                return "x"
            case TileType.WhiteRook:
                return "R"
            case TileType.BlackRook:
                return "r"
            case TileType.Key:
                return "*"
            case TileType.RookJones:
                return "J"
            case TileType.Exit:
                return "O"
            default:
                throw BoardError.invalidBoardDefinition("Unknown type found \(t)")
        }
    }
}

