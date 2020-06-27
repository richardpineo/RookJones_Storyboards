
import Foundation

class RookJones: Piece {
    init(hasKey: Bool, hasAllies: Bool) {
        self.hasKey = hasKey
        self.hasAllies = hasAllies
    }

    private let hasAllies: Bool
    private let hasKey: Bool

    func getAttackLocations(board: Board, pieceLocation: Location) -> [Location] {
        // Rook jones acts a lot like a rook, but can 'attack' doors

        var attacks = Array<Location>()

        // Walk in each direction until blocked or off the board
        let movements = [
            Location(1, 0),
            Location(-1, 0),
            Location(0, 1),
            Location(0, -1),
        ]

        for movement in movements {
            var loc = pieceLocation.offset(movement)
            while board.isLocationValid(loc) {
                var addLoc: Bool
                let tileType =  board.getTileType(loc)
                switch tileType
                {
                case .LockedDoor:
                    addLoc = hasKey
                    break
                    
                case .Exit:
                    addLoc = hasAllies
                    break
                    
                default :
                    addLoc = true
                }

                // If this is a blocking tile like a wall, then stop
                if BoardLogic.doesTileBlock(tileType) {
                    addLoc = false
                }

                // This one is good, add it in and keep walking.
                if(addLoc)
                {
                    attacks.append(loc)
                    loc = loc.offset(movement)
                }
            }
        }

        return attacks
    }
}
