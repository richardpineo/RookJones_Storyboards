
import Foundation

class Knight: Piece {
    func getAttackLocations(board: Board, pieceLocation: Location) -> [Location] {
        var attacks = Array<Location>()

        // Walk in each direction until blocked or off the board
        let movements = [
            Location(1, -2),
            Location(1, 2),
            Location(2, 1),
            Location(2, -1),
            Location(-1, 2),
            Location(-1, -2),
            Location(-2, 1),
            Location(-2, -1),
        ]

        for movement in movements {
            let loc = pieceLocation.offset(movement)
            if board.isLocationValid(loc) && !BoardLogic.doesTileBlock(board.getTileType(loc)) {
                attacks.append(loc)
            }
        }

        return attacks
    }
}
