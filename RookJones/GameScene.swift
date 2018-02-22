//
//  GameScene.swift
//  RookJones
//
//  Created by Richard Pineo on 2/18/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var boardTileMap : SKTileMapNode?
    private var pieceTileMap : SKTileMapNode?
    private var movementTileMap : SKTileMapNode?
    private var board: Board?
    private var attacked = Set<Location>()
    private var blocked = Set<Location>()

    // Scene Nodes
    var rookJones: SKSpriteNode!
    
    // Destination for rookJones
    var targetBoardLocation: Location = Location(0,0)
    
    // Values stolen from example project
    var maxSpeed: CGFloat = 500
    var acceleration: CGFloat = 0
    
    // if within threshold range of the target, rookJones begins slowing
    let targetThreshold: CGFloat = 100

    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Pass this in from level selection.
        do {
            try loadBoard("Level13")
        }
        catch BoardError.invalidBoardDefinition(let error) {
            fatalError("An error occurred: \(error)")
        }
        catch {
            fatalError("Couldn't load board")
        }

        initializeTileMaps()
        initalizeTiles()
        computeAttacked()
        computeBlocked()
        updateMovementTiles()
        initializeRookJones()
        printDebugInfo()
    }

    private func printDebugInfo() {
        print("Tile size: \(self.boardTileMap!.tileSize)")
        print("Rook Jones size: \(self.rookJones.size)")
        print("Tile scale: \(self.boardTileMap!.xScale) x \(self.boardTileMap!.yScale)")
        print("Rook Jones scale: \(self.rookJones.xScale) x \(self.rookJones.yScale)")
    }

    private func boardToScreen(_ loc: Location) -> Location {
        return Location(self.board!.numRows - loc.row - 1, loc.col )
    }

    private func screenToBoard(_ loc: Location) -> Location {
        // It's actually the same conversion as boardToScreen
        return boardToScreen(loc)
    }

    private func pointToScreenLocation(_ point: CGPoint) -> Location {
        let col = self.boardTileMap!.tileColumnIndex(fromPosition: point)
        let row = self.boardTileMap!.tileRowIndex(fromPosition: point)
        return Location(row, col)
    }
    
    private func screenLocationToPoint(_ loc: Location) -> CGPoint {
        return self.boardTileMap!.centerOfTile(atColumn: loc.col, row: loc.row)
    }

    private func loadBoard( _ boardName: String ) throws {
        // Pass this in from level selection.
        let path = Bundle.main.path( forResource: boardName, ofType: "lvl")
        self.board = try BoardLoader.fromFile( path! )
    }
    
    private func initializeRookJones() {
        guard let rookJones = childNode(withName: "rookJones") as? SKSpriteNode else {
            fatalError("RookJones not loaded")
        }
        self.rookJones = rookJones

        self.targetBoardLocation = rookJonesBoardLocation()
        self.rookJones.position = screenLocationToPoint( boardToScreen(self.targetBoardLocation) )
    }
    
    private func rookJonesBoardLocation() -> Location {
        let location = self.board!.locations().first(where: {self.board!.getTileType($0) == TileType.RookJones})
        if( location == nil ) {
            fatalError("No RookJones!")
        }
        return location!
    }
    
    private func initializeTileMaps() {
        // Size the board tile map
        self.boardTileMap = self.childNode(withName: "//board") as? SKTileMapNode
        self.boardTileMap!.numberOfColumns = self.board!.numCols
        self.boardTileMap!.numberOfRows = self.board!.numRows
        
        // Size the piece tile map
        self.pieceTileMap = self.childNode(withName: "//pieces") as? SKTileMapNode
        self.pieceTileMap!.numberOfColumns = self.board!.numCols
        self.pieceTileMap!.numberOfRows = self.board!.numRows

        // Size the movement tile map
        self.movementTileMap = self.childNode(withName: "//movement") as? SKTileMapNode
        self.movementTileMap!.numberOfColumns = self.board!.numCols
        self.movementTileMap!.numberOfRows = self.board!.numRows
    }
    
    private func initalizeTiles() {
        // Load the tiles.
        let boardTileSet = SKTileSet(named: "Board Tiles")!
        let pieceTileSet = SKTileSet(named: "Piece Tiles")!
        
        for loc in self.board!.locations() {
            let type = self.board!.getTileType(loc)
            
            let tileIndex = boardToScreen(loc)
            
            let boardTileName = boardTileNameForType(type: type, row: tileIndex.row, col: tileIndex.col)
            let boardTile = boardTileSet.tileGroups.first(where: {$0.name == boardTileName})
            self.boardTileMap!.setTileGroup(boardTile, forColumn: tileIndex.col, row: tileIndex.row)
            
            let pieceTileName = pieceTileNameForType(type: type)
            let pieceTile = pieceTileSet.tileGroups.first(where: {$0.name == pieceTileName})
            self.pieceTileMap!.setTileGroup(pieceTile, forColumn: tileIndex.col, row: tileIndex.row)
        }
    }
    
    private func updateMovementTiles() {
        let movementTiles = SKTileSet(named: "Movement Tiles")!
        let attackedTile = movementTiles.tileGroups.first(where: {$0.name == "Attacked"})
        
        for loc in self.board!.locations() {
            let tileIndex = boardToScreen(loc)
            let tile = attacked.contains(tileIndex) == true ? attackedTile : nil
            self.movementTileMap!.setTileGroup(tile, forColumn: tileIndex.col, row: tileIndex.row)
        }
    }

    private func cellTileName( row: Int, col: Int ) -> String {
        return (0 == (row + col) % 2) ? "Black Cell" : "White Cell"
    }
    
    private func boardTileNameForType( type: TileType, row: Int, col: Int ) -> String {
        switch( type ) {
        case TileType.Wall:
            return "Wall"
        default:
            return cellTileName(row: row, col: col);
        }
    }
    
    private func pieceTileNameForType( type: TileType ) -> String {
        switch( type ) {
        case TileType.RookJones:
            return "Rook Jones"
        case TileType.Key:
            return "Key"
        case TileType.WhiteRook:
            return "White Rook"
        case TileType.BlackRook:
            return "Black Rook"
        case TileType.Exit:
            return "Exit"
        case TileType.LockedDoor:
            return "Locked"
        case TileType.UnlockedDoor:
            return "Unlocked"
        default:
            return "";
        }
    }
    
    private func computeAttacked() {
        let attackedTiles = BoardLogic.attackedLocations( self.board! )
        attacked.removeAll()
        for loc in attackedTiles {
            attacked.insert(self.boardToScreen(loc))
        }
    }
    
    private func computeBlocked() {
        let blockedTiles = BoardLogic.blockedLocations( self.board! )
        blocked.removeAll()
        for loc in blockedTiles {
            blocked.insert(self.boardToScreen(loc))
        }
    }
    
    private func isMoveValid(starting: Location, possible: Location) -> Bool {
        // Rooks only move to the same row or column
        if( starting.row != possible.row && starting.col != possible.col) {
            return false;
        }
        return true;
    }
    
    private func moveRookJones(boardLocation: Location) {
        let old = rookJonesBoardLocation()
        self.targetBoardLocation = boardLocation
        do {
            try self.board!.setTileType(location: old, tileType: TileType.Empty)
            try self.board!.setTileType(location: boardLocation, tileType: TileType.RookJones)
            
            // too heavy handed but 
            // initalizeTiles()
        }
        catch {
            // Do nothing
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        // Set the targetLocation to the destination
        let point = touch.location(in: self)
        let boardLocation = screenToBoard(pointToScreenLocation(point))
        if(isMoveValid(starting: rookJonesBoardLocation(), possible: boardLocation)) {
            moveRookJones(boardLocation: boardLocation)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        /*
        let position = rookJones.position
        let column = landBackground.tileColumnIndex(fromPosition: position)
        let row = landBackground.tileRowIndex(fromPosition: position)
        let tile = landBackground.tileDefinition(atColumn: column, row: row)
        
        let objectTile = objectsTileMap.tileDefinition(atColumn: column, row: row)
        
        if let _ = objectTile?.userData?.value(forKey: "gascan") {
            run(gascanSound)
            objectsTileMap.setTileGroup(nil, forColumn: column, row: row)
        }
        
        if let _ = objectTile?.userData?.value(forKey: "duck") {
            run(duckSound)
            objectsTileMap.setTileGroup(nil, forColumn: column, row: row)
        }
 */
    }
    
    override func didSimulatePhysics() {
        let targetPoint = screenLocationToPoint(boardToScreen(targetBoardLocation))
        let offset = CGPoint(x: targetPoint.x - rookJones.position.x, y: targetPoint.y - rookJones.position.y)
        
        let distance = sqrt(offset.x * offset.x + offset.y * offset.y)
        let rookJonesDirection = CGPoint(x:offset.x / distance, y:offset.y / distance)
        let rookJonesVelocity = CGPoint(x: rookJonesDirection.x * acceleration, y: rookJonesDirection.y * acceleration)
        
        rookJones.physicsBody?.velocity = CGVector(dx: rookJonesVelocity.x, dy: rookJonesVelocity.y)
        
        if distance < targetThreshold {
            let delta = targetThreshold - distance
            acceleration = acceleration * ((targetThreshold - delta)/targetThreshold)
            if( acceleration < 0.1 ) {
                self.rookJones.position = targetPoint
                acceleration = 0
            }
        } else {
            if acceleration > maxSpeed {
                acceleration -= min(acceleration - maxSpeed, 80)
            }
            if acceleration < maxSpeed {
                acceleration += min(maxSpeed - acceleration, 40)
            }
        }
    }
}
