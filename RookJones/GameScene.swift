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
    private var label : SKLabelNode?
    private var boardTileMap : SKTileMapNode?
    private var pieceTileMap : SKTileMapNode?
    private var board: Board?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Pass this in from level selection.
        do {
            try loadBoard("Level13")
        }
        catch BoardError.invalidBoardDefinition(let error) {
            // handle error
            print("An error occurred: \(error)")
            return
        }
        catch {
            return
        }

        initializeLabel()
        initializeTileMaps()
        initalizeTiles()
    }
    
    private func loadBoard( _ boardName: String ) throws {
        // Pass this in from level selection.
        let path = Bundle.main.path( forResource: boardName, ofType: "lvl")
        self.board = try BoardLoader.FromFile( path! )
    }
    
    private func initializeLabel() {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//rookJones") as? SKLabelNode
        self.label!.alpha = 0.0
        self.label!.run(SKAction.fadeIn(withDuration: 5.0))
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
    }
    
    private func initalizeTiles() {
        // Load the tiles.
        let boardTileSet = SKTileSet(named: "Board Tiles")!
        let pieceTileSet = SKTileSet(named: "Piece Tiles")!
        
        for row in 0...self.board!.numRows-1 {
            for col in 0...self.board!.numCols-1 {
                let type: TileType;
                do {
                    type = try self.board!.GetTileType(row: row, col: col)
                }
                catch {
                    print("Couldn't get tile type (\(row), \(col))")
                    type = TileType.Empty;
                }
                
                let boardTileName = boardTileNameForType(type: type, row: row, col: col)
                let boardTile = boardTileSet.tileGroups.first(where: {$0.name == boardTileName})
                self.boardTileMap!.setTileGroup(boardTile, forColumn: col, row: row)
                
                let pieceTileName = pieceTileNameForType(type: type)
                let pieceTile = pieceTileSet.tileGroups.first(where: {$0.name == pieceTileName})
                self.pieceTileMap!.setTileGroup(pieceTile, forColumn: col, row: row)
            }
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
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Pulse the label
        self.label!.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
