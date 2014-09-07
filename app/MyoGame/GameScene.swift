//
//  GameScene.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import SpriteKit

let frameRate = 1.0 / 6.0

let numPlayers = 2

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
        
        for var i = 0; i < numPlayers; i++ {
            
            let sprite = SKSpriteNode(texture: KenTexture.texturesForAction(.Rest).first!)
            
            sprite.position.x = -1.0
            sprite.position.y = -50.0
            sprite.xScale = 2.0
            sprite.yScale = 2.0
            
            if (i == 1) {
                sprite.position.x *= -1.0
                sprite.xScale *= -1.0
            }
            
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
            
            if let playerAction = player.action {
                
                sprite.removeAllActions()
                
                let action: SKAction = {
                    
                    switch playerAction {
                    case .Punch:
                        return self.punchAction()
                    }
                }()
                
                let actionSequence = SKAction.sequence([action, restAction()])
                
                sprite.runAction(actionSequence)
            }
        }
    }
    
    // MARK: Actions
    
    func restAction() -> SKAction {
        
        let textures = KenTexture.texturesForAction(.Rest)
        let action = SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: frameRate))
        
        return action
    }
    
    func punchAction() -> SKAction {
        
        let textures = KenTexture.texturesForAction(.Punch)
        let animationAction = SKAction.animateWithTextures(textures, timePerFrame: frameRate)
        
        let soundAction = SKAction.playSoundFileNamed("Punch.wav", waitForCompletion: false)
        
        return SKAction.group([animationAction, soundAction])
    }
    
    // MARK: Ball sprites
    
    /*
    var ballSprites = [SKSpriteNode]()
    
    func startBlastFromPlayer(sprite: SKSpriteNode) {
        
        let blastTextures = KenTexture.texturesForAction(.Blast)
        
        let ballSprite = SKSpriteNode(texture: blastTextures.first!)
        
        var position = sprite.position
        
        position.x += (sprite == playerSprites.first! ? 1.0 : -1.0) * 30.0
    }
    */
    
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
            
            sprite.runAction(restAction())
            
            self.addChild(sprite)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
