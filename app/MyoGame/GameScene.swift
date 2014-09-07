//
//  GameScene.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import SpriteKit

let frameRate = 1.0 / 6.0

class GameScene: SKScene {
    
    // MARK: Metrics
    
    let xPad: CGFloat = 50.0
    
    var xFactor: CGFloat {
        return size.width / 2.0 - xPad
    }
    
    // MARK: Game
    
    var game: Game = Game() {
        
        didSet {
            
            for player in game.players {
                
                let sprite = playerSprites[player.identifier]!
                
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
            
            updatePlayerSpriteLocationsAnimated(true)
        }
    }
    
    // MARK: Stage
    
    let stage: SKSpriteNode = {
        
        let stage = SKSpriteNode(imageNamed: "Stage")
        
        return stage
    }()
    
    // MARK: Player sprites
    
    let playerSprites: [Game.Player.Identifier: SKSpriteNode]
    
    func updatePlayerSpriteLocationsAnimated(animated: Bool) {
        
        for player in game.players {
            
            let sprite = playerSprites[player.identifier]!
            
            let x = CGFloat(player.position) * xFactor * player.geometricFactor
            
            if animated {
                sprite.runAction(SKAction.moveToX(x, duration: 0.1))
            } else {
                sprite.position.x = x
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
    
    init(size: CGSize, game: Game) {
        
        // Set up sprites
        
        self.game = game
        
        var playerSprites: [Game.Player.Identifier: SKSpriteNode] = [:]
        
        for player in game.players {
            
            let sprite = SKSpriteNode(texture: KenTexture.texturesForAction(.Rest).first!)
            
            sprite.position.y = -50.0
            sprite.xScale = 2.0 * player.geometricFactor
            sprite.yScale = 2.0
            
            playerSprites[player.identifier] = sprite
        }
        
        self.playerSprites = playerSprites
        
        // Initialize super
        
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
        
        updatePlayerSpriteLocationsAnimated(false)
        
        for (_, sprite) in self.playerSprites {
            
            sprite.runAction(restAction())
            
            self.addChild(sprite)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.game = Game()
        self.playerSprites = [:]
        
        super.init(coder: aDecoder)
    }
    
    // MARK: Size change
    
    override func didChangeSize(oldSize: CGSize) {
        
        updatePlayerSpriteLocationsAnimated(false)
    }
}

extension Game.Player {
    
    var geometricFactor: CGFloat { return self.identifier == .Player2 ? -1.0 : 1.0 }
}
