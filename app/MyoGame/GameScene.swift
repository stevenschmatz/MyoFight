//
//  GameScene.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import SpriteKit

let frameRate = 1.0 / 6.0

let numPlayers = 1

class GameScene: SKScene {
    
    // MARK: Metrics
    
    let xPad: CGFloat = 50.0
    
    var xFactor: CGFloat {
        return size.width / 2.0 - xPad
    }
    
    // MARK: Stage
    
    let stage: SKSpriteNode = {
        
        let stage = SKSpriteNode(imageNamed: "Stage")
        
        return stage
    }()
    
    // MARK: Player sprites
    
    let playerSprites: [SKSpriteNode] = {
        
        var playerSprites = [SKSpriteNode]()
        
        let restTextures = KenTexture.texturesForAction(.Rest)
        let restAction = SKAction.repeatActionForever(SKAction.animateWithTextures(restTextures, timePerFrame: frameRate))
        
        for var i = 0; i < numPlayers; i++ {
            
            let sprite = SKSpriteNode(texture: restTextures.first!)
            
            sprite.position.x = -1.0
            sprite.position.y = -50.0
            sprite.xScale = 2.0
            sprite.yScale = 2.0
            
            if (i == 1) {
                sprite.position.x *= -1.0
                sprite.xScale *= -1.0
            }
            
            sprite.runAction(restAction)
            
            playerSprites.append(sprite)
        }
        
        return playerSprites
    }()
    
    func updatePlayers(players: [Player]) {
        
        for var i = 0; i < numPlayers; i++ {
            
            let player = players[i]
            let sprite = playerSprites[i]
            
            if let position = player.position {
                
                let x = CGFloat(position) * xFactor
                
                sprite.runAction(SKAction.moveToX(x, duration: 0.1))
            }
        }
    }
    
    // MARK: Initialization
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        // Set up scene
        
        scaleMode = .AspectFit
        anchorPoint = CGPointMake(0.5, 0.5)
        
        backgroundColor = SKColor.whiteColor()
        
        // Add stage
        
        let stageScaleFactor = size.height / stage.size.height
        
        stage.xScale = stageScaleFactor
        stage.yScale = stageScaleFactor
        
        self.addChild(stage)
        
        // Add players
        
        for sprite in self.playerSprites {
            
            sprite.position.x *= xFactor
            
            self.addChild(sprite)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
