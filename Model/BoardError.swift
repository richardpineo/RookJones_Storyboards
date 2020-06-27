
import Foundation

enum BoardError: Error {
    // Called when a board is initialized with no elements for rows or columns.
    case invalidBoardInitialization(numRows: Int, numCols: Int)

    // Called when a cell is accessed with row, col outside of bounds of the board.
    case invalidCell(Location)

    // The board being loaded contained invalid characteristics such as unknown piece identifiers
    // or an incorrect number of columns for a row.
    case invalidBoardDefinition(String)
}
