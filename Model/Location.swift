//
//  Location.swift
//  RookJones
//
//  Created by Richard Pineo on 2/20/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

class Location: Hashable {
    init(_ row: Int,_ col: Int ) {
        self.row = row
        self.col = col
    }
    
    public var hashValue: Int {
        return row.hashValue ^ col.hashValue
    }
    
    public static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    // Returns the location that is offset by the values in the row and col
    // of the offset. The return location may be not be valid for your board.
    public func offset(_ offset: Location) -> Location {
        return Location( row + offset.row, col + offset.col )
    }
    
    let row: Int
    let col: Int
}

