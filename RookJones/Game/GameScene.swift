//
//  GameScene.swift
//  RookJones
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()

    private var boardTileMap: SKTileMapNode?
    private var pieceTileMap: SKTileMapNode?
    private var movementTileMap: SKTileMapNode?

    // The initial board state, just after loading
    var initialBoard: Board?

    // The current board state with any changes (e.g. picked up a key)
    private var board: Board?

    // Which screen locations are attacked currently
    private var attackedScreenLocations = Set<Location>()

    // True if Jones is alive and kickin'
    private var rookJonesIsDead: Bool = false

    var hasKey: Bool {
        get {
            return _hasKey
        }
        set(hasKey) {
            _hasKey = hasKey
            guard let keyNode = childNode(withName: "key") as? SKSpriteNode else {
                fatalError("Key not found")
            }
            keyNode.run(hasKey ? SKAction.unhide() : SKAction.hide())
        }
    }

    private var _hasKey: Bool = false

    // Scene Nodes
    var rookJones: SKSpriteNode!

    // Whether there are any allies left on the board
    var hasAllies: Bool = false

    // Currnet location of Rook Jones
    var rookJonesCurrentBoardLocation: Location = Location(0, 0)

    override func didMove(to _: SKView) {
        // Pass this in from level selection.
        assert(initialBoard != nil)
        resetBoardToStartingState()
        initializeRookJones()
    }

    private func resetBoardToStartingState() {
        // reset the map
        do {
            board = try Board(initialBoard!)
        } catch {
            fatalError("Couldn't copy board")
        }
        hasAllies = BoardLogic.hasAlliesOnBoard(board!)
        initializeTileMaps()
        initializeRookJones()
        updateBoardTilesInScene()
        computeAttacked()
        updateMovementTiles()
        hasKey = false
        rookJonesIsDead = false
    }

    private func boardToScreen(_ loc: Location) -> Location {
        return Location(board!.numRows - loc.row - 1, loc.col)
    }

    private func screenToBoard(_ loc: Location) -> Location {
        // It's actually the same conversion as boardToScreen
        return boardToScreen(loc)
    }

    private func pointToScreenLocation(_ point: CGPoint) -> Location {
        let col = boardTileMap!.tileColumnIndex(fromPosition: point)
        let row = boardTileMap!.tileRowIndex(fromPosition: point)
        return Location(row, col)
    }

    private func screenLocationToPoint(_ loc: Location) -> CGPoint {
        return boardTileMap!.centerOfTile(atColumn: loc.col, row: loc.row)
    }

    private func initializeRookJones() {
        if rookJones == nil {
            guard let rookJones = childNode(withName: "rookJones") as? SKSpriteNode else {
                fatalError("RookJones not loaded")
            }
            self.rookJones = rookJones
        }

        rookJones.removeAllActions()
        rookJones.run(SKAction.fadeOut(withDuration: 0.0))
        rookJonesCurrentBoardLocation = rookJonesBoardLocation()
        rookJones.position = screenLocationToPoint(boardToScreen(rookJonesCurrentBoardLocation))
        rookJones.run(SKAction.fadeIn(withDuration: 1.0))
    }

    private func rookJonesBoardLocation() -> Location {
        let location = board!.locations().first(where: { self.board!.getTileType($0) == TileType.RookJones })
        if location == nil {
            fatalError("No RookJones!")
        }
        return location!
    }

    private func initializeTileMaps() {
        // Size the board tile map
        boardTileMap = childNode(withName: "//board") as? SKTileMapNode
        boardTileMap!.numberOfColumns = board!.numCols
        boardTileMap!.numberOfRows = board!.numRows

        // Size the piece tile map
        pieceTileMap = childNode(withName: "//pieces") as? SKTileMapNode
        pieceTileMap!.numberOfColumns = board!.numCols
        pieceTileMap!.numberOfRows = board!.numRows

        // Size the movement tile map
        movementTileMap = childNode(withName: "//movement") as? SKTileMapNode
        movementTileMap!.numberOfColumns = board!.numCols
        movementTileMap!.numberOfRows = board!.numRows
    }

    private func updateBoardTilesInScene() {
        // Load the tiles.
        let boardTileSet = SKTileSet(named: "Board Tiles")!
        let pieceTileSet = SKTileSet(named: "Piece Tiles")!

        for loc in board!.locations() {
            let type = board!.getTileType(loc)

            let tileIndex = boardToScreen(loc)

            let boardTileName = boardTileNameForType(type: type, row: tileIndex.row, col: tileIndex.col)
            let boardTile = boardTileSet.tileGroups.first(where: { $0.name == boardTileName })
            boardTileMap!.setTileGroup(boardTile, forColumn: tileIndex.col, row: tileIndex.row)

            let pieceTileName = pieceTileNameForType(type: type)
            let pieceTile = pieceTileSet.tileGroups.first(where: { $0.name == pieceTileName })
            pieceTileMap!.setTileGroup(pieceTile, forColumn: tileIndex.col, row: tileIndex.row)
        }
    }

    private func updateMovementTiles() {
        let movementTiles = SKTileSet(named: "Movement Tiles")!
        let attackedTile = movementTiles.tileGroups.first(where: { $0.name == "Attacked" })
        let possibleTile = movementTiles.tileGroups.first(where: { $0.name == "Possible" })

        let rookJones = RookJones(hasKey: hasKey, hasAllies: hasAllies)
        let legitMoves = rookJones.getAttackLocations(board: board!, pieceLocation: rookJonesCurrentBoardLocation)

        for loc in board!.locations() {
            let tileIndex = boardToScreen(loc)

            var tile: SKTileGroup?
            if !rookJonesIsDead {
                // is this one attacked?
                if attackedScreenLocations.contains(tileIndex) {
                    tile = attackedTile
                } else if legitMoves.contains(loc) {
                    tile = possibleTile
                }
            }

            movementTileMap!.setTileGroup(tile, forColumn: tileIndex.col, row: tileIndex.row)
        }
    }

    private func cellTileName(row: Int, col: Int) -> String {
        return (1 == (row + col) % 2) ? "Black Cell" : "White Cell"
    }

    private func boardTileNameForType(type: TileType, row: Int, col: Int) -> String {
        switch type {
        case TileType.Wall:
            return "Wall"
        default:
            return cellTileName(row: row, col: col)
        }
    }

    private func pieceTileNameForType(type: TileType) -> String {
        switch type {
        // case TileType.RookJones: We use an empty tile for this
        case TileType.Key:
            return "Key"
        case TileType.WhiteRook:
            return "White Rook"
        case TileType.WhiteKnight:
            return "White Knight"
        case TileType.WhiteBishop:
            return "White Bishop"
        case TileType.WhiteQueen:
            return "White Queen"
        case TileType.BlackRook:
            return "Black Rook"
        case TileType.Treasure:
            return "Diamond"
        case TileType.Exit:
            return hasAllies ? "Closed Door" : "Open Door"
        case TileType.LockedDoor:
            return "Locked"
        default:
            return ""
        }
    }

    private func computeAttacked() {
        let attackedTiles = BoardLogic.attackedLocations(board!)
        attackedScreenLocations.removeAll()
        for loc in attackedTiles {
            attackedScreenLocations.insert(boardToScreen(loc))
        }
    }

    private func changeBoardTile(boardLocation: Location, tileType: TileType) {
        do {
            try board!.setTileType(location: boardLocation, tileType: tileType)
            hasAllies = BoardLogic.hasAlliesOnBoard(board!)
            updateBoardTilesInScene()
            computeAttacked()
        } catch {
        }
    }

    private func isMoveValid(starting: Location, possible: Location) -> Bool {
        let rookJones = RookJones(hasKey: hasKey, hasAllies: hasAllies)
        let legitMoves = rookJones.getAttackLocations(board: board!, pieceLocation: starting)
        return legitMoves.contains(possible)
    }

    /* c = square root(a^2 + b^2)
     Calculate the distance betwen two points
     @return linear distance between two CGPoints
     */
    func distanceBetweenPoints(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y))
    }

    // calculate time using the rate * time = distance formula (solve for time)
    // return a NSTimeInterval to signify time (in seconds as a return value)
    func timeToTravelDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }

    private func moveRookJones(boardLocation: Location, onDoneMoving: @escaping () -> Void) {
        rookJonesCurrentBoardLocation = boardLocation
        let screenLocation = boardToScreen(boardLocation)
        let targetPoint = screenLocationToPoint(screenLocation)

        let distance = distanceBetweenPoints(a: targetPoint, b: rookJones.position)
        let playerSpeed: CGFloat = 1000 // constant speed
        let time = timeToTravelDistance(distance: distance, speed: playerSpeed)
        let move = SKAction.move(to: targetPoint, duration: time)
        rookJones.run(move) {
            // Is this point attacked?
            if self.attackedScreenLocations.contains(screenLocation) {
                // Rook jones is dead
                self.rookJonesIsDead = true
                self.rookJones.run(SKAction.fadeOut(withDuration: 1.0))
            } else if self.board!.getTileType(boardLocation) == TileType.Key {
                // Pick up the key
                self.hasKey = true
                self.changeBoardTile(boardLocation: boardLocation, tileType: TileType.Empty)
            }

            self.updateMovementTiles()

            // Callback
            onDoneMoving()
        }
    }

    func passTheLevel() {
        // Hooray!
        let scale = CGFloat(256.0)
        rookJones.run(SKAction.scale(by: scale, duration: 3)) {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BackToTitle")))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        guard let touch = touches.first else { return }

        // Are we dead yet?
        if rookJonesIsDead {
            // bring him back to life
            resetBoardToStartingState()
            return
        }

        // If moving, then don't allow
        if rookJones.hasActions() {
            return
        }

        // Set the targetLocation to the destination
        let point = touch.location(in: self)
        let boardLocation = screenToBoard(pointToScreenLocation(point))
        let destTileType = board!.getTileType(boardLocation)

        // Is the proposed destination valid?
        if !isMoveValid(starting: rookJonesCurrentBoardLocation, possible: boardLocation) {
            return
        }

        // Perform the move
        moveRookJones(boardLocation: boardLocation, onDoneMoving: {
            // Unlock the door if they clicked on a door
            if destTileType == TileType.LockedDoor && self.hasKey {
                self.changeBoardTile(boardLocation: boardLocation, tileType: TileType.Empty)
            }

            // Is he landing on an ally? If so, save the ally!
            if BoardLogic.isAlly(destTileType) {
                self.changeBoardTile(boardLocation: boardLocation, tileType: TileType.Empty)
            }

            // Is rook jones on the exit?
            if destTileType == TileType.Exit {
                self.passTheLevel()
            }
        })
    }
}
