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
    
    private var boardTileMap : SKTileMapNode?
    private var pieceTileMap : SKTileMapNode?
    private var movementTileMap : SKTileMapNode?
    private var board: Board?
    private var attackedScreenLocations = Set<Location>()
    private var blockedScreenLocations = Set<Location>()
    private var rookJonesIsDead: Bool = false
    
    // Scene Nodes
    var rookJones: SKSpriteNode!
    
    var rookJonesCurrentBoardLocation: Location = Location(0,0)
    
    override func sceneDidLoad() {
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
        if( self.rookJones == nil ) {
            guard let rookJones = childNode(withName: "rookJones") as? SKSpriteNode else {
                fatalError("RookJones not loaded")
            }
            self.rookJones = rookJones
        }
        
        self.rookJonesIsDead = false
        self.rookJones.removeAllActions()
        self.rookJones.run(SKAction.fadeOut(withDuration: 0.0))
        self.rookJonesCurrentBoardLocation = self.rookJonesBoardLocation()
        self.rookJones.position = screenLocationToPoint( boardToScreen(self.rookJonesCurrentBoardLocation) )
        self.rookJones.run(SKAction.fadeIn(withDuration: 1.0))
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
            let tile = attackedScreenLocations.contains(tileIndex) == true ? attackedTile : nil
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
        // case TileType.RookJones: We use an empty tile for this
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
        attackedScreenLocations.removeAll()
        for loc in attackedTiles {
            attackedScreenLocations.insert(self.boardToScreen(loc))
        }
    }
    
    private func computeBlocked() {
        let blockedTiles = BoardLogic.blockedLocations( self.board! )
        blockedScreenLocations.removeAll()
        for loc in blockedTiles {
            blockedScreenLocations.insert(self.boardToScreen(loc))
        }
    }
    
    private func isMoveValid(starting: Location, possible: Location) -> Bool {
        // Rooks only move to the same row or column
        if( starting.row != possible.row && starting.col != possible.col) {
            return false;
        }
        return true;
    }
    
    /* c = square root(a^2 + b^2)
     Calculate the distance betwen two points
     @return linear distance between two CGPoints
     */
    func distanceBetweenPoints(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))
    }
    // calculate time using the rate * time = distance formula (solve for time)
    // return a NSTimeInterval to signify time (in seconds as a return value)
    func timeToTravelDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
    private func moveRookJones(boardLocation: Location) {

        self.rookJonesCurrentBoardLocation = boardLocation
        let screenLocation = boardToScreen(boardLocation)
        let targetPoint = screenLocationToPoint(screenLocation)
        
        let distance = distanceBetweenPoints(a: targetPoint, b: self.rookJones.position)
        let playerSpeed: CGFloat = 700  // constant speed
        let time = timeToTravelDistance(distance: distance, speed: playerSpeed)
        let move = SKAction.move(to: targetPoint, duration: time)
        self.rookJones.run(move) {
            // Is this point attacked?
            if( self.attackedScreenLocations.contains(screenLocation) ) {
                // Rook jones is dead
                self.rookJonesIsDead = true
                self.rookJones.run(SKAction.fadeOut(withDuration: 2.0))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if( self.rookJonesIsDead ) {
            // bring him back to life
            initializeRookJones()
            return;
        }

        // Set the targetLocation to the destination
        let point = touch.location(in: self)
        let boardLocation = screenToBoard(pointToScreenLocation(point))
        if(isMoveValid(starting: self.rookJonesCurrentBoardLocation, possible: boardLocation)) {
            moveRookJones(boardLocation: boardLocation)
        }
    }
}
