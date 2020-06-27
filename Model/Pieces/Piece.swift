
import Foundation

// Pieces implement this protocol which contains common piece functions
protocol Piece {
    // Returns a set of locations that can be attacked by this piece type
    func getAttackLocations(board: Board, pieceLocation: Location) -> [Location]
}
