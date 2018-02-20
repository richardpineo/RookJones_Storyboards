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
    private var spinnyNode : SKShapeNode?
    private var board : SKTileMapNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        do {
            // Get label node from scene and store it for use later
            self.label = self.childNode(withName: "//rookJones") as? SKLabelNode
            self.label?.alpha = 0.0
            self.label?.run(SKAction.fadeIn(withDuration: 2.0))
            
            let path = Bundle.main.path( forResource: "Level13", ofType: "lvl")
            let board = try BoardLoader.FromFile( path! )
        
            let tileSet = SKTileSet(named: "Board Tiles")
            let tileGroups = tileSet?.tileGroups
            
            // Fill in the board with the scene.
            self.board = self.childNode(withName: "//board") as? SKTileMapNode
            self.board?.numberOfColumns = board.numCols
            self.board?.numberOfRows = board.numRows
            
            for row in 0...board.numRows-1 {
                for col in 0...board.numCols-1 {

                    let type = try board.GetTileType(row: row, col: col)
                    let tileName = tileNameForType(type: type, row: row, col: col)
                    let tile = tileGroups?.first(where: {$0.name == tileName})
                    self.board?.setTileGroup(tile, forColumn: col, row: row)
                }
            }
 
        }
        catch {
            self.label?.text = "OH NO"
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    private func tileNameForType( type: TileType, row: Int, col: Int ) -> String {
        switch( type ) {
        case TileType.RookJones:
            return "RookJones"
        case TileType.Empty:
            return (0 == (row + col) % 2) ? "Black Cell" : "White Cell"
        case TileType.Wall:
            return "Wall"
        case TileType.LockedDoor:
            return  "Door Locked"
        case TileType.UnlockedDoor:
            return "Door Unlocked"
        case TileType.Key:
            return "Key"
        case TileType.WhiteRook:
            return "White Rook"
        case TileType.BlackRook:
            return "Black Rook"
        case TileType.Exit:
            return "Exit"
        }
    }
    
    func fillBoard() {
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
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
