
import Foundation
    
class Location: Hashable {
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }

   func hash(into hasher: inout Hasher)
   {
        hasher.combine(self.row)
        hasher.combine(self.col)
    }
    
    public static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

    // Returns the location that is offset by the values in the row and col
    // of the offset. The return location may be not be valid for your board.
    public func offset(_ offset: Location) -> Location {
        return Location(row + offset.row, col + offset.col)
    }

    let row: Int
    let col: Int
}
