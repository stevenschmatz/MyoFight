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
            
            if oldValue.state == Game.State.Starting && game.state == Game.State.Playing {
                
                logo.runAction(SKAction.moveToY(600.0, duration: 1.0))
                
                instruction.removeAllActions()
                instruction.hidden = true
                
                for (_, sprite) in playerSprites {
                    
                    sprite.alpha = 1.0
                }
            }
            
            for player in game.players {
                
                let sprite = playerSprites[player.identifier]!
                
                if let playerAction = player.action {
                    
                    sprite.removeAllActions()
                    
                    let action: SKAction = {
                        
                        switch playerAction {
                        case .Punch:
                            return self.punchAction()
                        case .Blast:
                            self.startBlastFromPlayer(player)
                            return self.powerUpAction()
                        }
                    }()
                    
                    let actionSequence = SKAction.sequence([action, restAction()])
                    
                    sprite.runAction(actionSequence)
                }
            }
            
            updatePlayerSpriteLocationsAnimated(false)
            updateHealthBarFrames()
            updateStaminaBarFrames()
        }
    }
    
    // MARK: Stage
    
    let stage: SKSpriteNode = {
        
        let stage = SKSpriteNode(imageNamed: "Stage")
        
        stage.zPosition = -1
        
        return stage
    }()
    
    // MARK: Logo
    
    let logo: SKSpriteNode = {
        
        let logo = SKSpriteNode(imageNamed: "Logo")
        
        logo.zPosition = 2
        logo.alpha = 0.0
        
        return logo
    }()
    
    // MARK: Instruction
    
    let instruction: SKSpriteNode
    
    // MARK: Win
    
    //let win: SKSpriteNode
    
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
    
    // MARK: Health bars
    
    let healthBars: [Game.Player.Identifier: SKSpriteNode]
    let maxHealthBarWidth: CGFloat
    
    func updateHealthBarFrames() {
        
        for player in game.players {
            
            let bar = healthBars[player.identifier]!
            
            let width = maxHealthBarWidth * CGFloat(player.health)
            
            bar.size = CGSizeMake(maxHealthBarWidth * CGFloat(player.health), 5.0)
            bar.position = CGPointMake((size.width / 6.0 + (maxHealthBarWidth - width) + width / 2.0) * player.geometricFactor, size.height / 2.0 - 2.5)
        }
    }
    
    // MARK: Stamina bars
    
    let staminaBars: [Game.Player.Identifier: SKSpriteNode]
    let maxStaminaBarWidth: CGFloat
    
    func updateStaminaBarFrames() {
        
        for player in game.players {
            
            let bar = staminaBars[player.identifier]!
            
            let width = maxStaminaBarWidth * CGFloat(player.stamina)
            
            bar.size = CGSizeMake(maxStaminaBarWidth * CGFloat(player.stamina), 5.0)
            bar.position = CGPointMake((size.width / 4.0 + (maxStaminaBarWidth - width) + width / 2.0) * player.geometricFactor, size.height / 2.0 - 7.5)
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
    
    func powerUpAction() -> SKAction {
        
        let textures = KenTexture.texturesForAction(.PowerUp)
        let animationAction = SKAction.animateWithTextures(textures, timePerFrame: frameRate)
        
        let soundAction = SKAction.playSoundFileNamed("Charge Up.wav", waitForCompletion: false)
        
        return SKAction.group([animationAction, soundAction])
    }
    
    // MARK: Ball sprites
    
    var ballSprites = [SKSpriteNode]()
    
    func startBlastFromPlayer(player: Game.Player) {
        
        let textures = KenTexture.texturesForAction(.Blast)
        let textureAction = SKAction.animateWithTextures(textures, timePerFrame: 0.125)
        
        let moveAction = SKAction.moveByX(100.0 * player.geometricFactor, y: 0.0, duration: 0.5)
        let soundAction = SKAction.playSoundFileNamed("Blast.wav", waitForCompletion: false)
        let blastAction = SKAction.repeatAction(SKAction.group([soundAction, moveAction, textureAction]), count: 6)
        
        let ballSprite = SKSpriteNode(texture: textures.first!)
        
        var position = playerSprites[player.identifier]!.position
        position.x += 80.0 * player.geometricFactor
        position.y += 20.0
        
        ballSprite.position = position
        ballSprite.zPosition = 1
        ballSprite.xScale = player.geometricFactor
        ballSprite.alpha = 0.0
        
        addChild(ballSprite)
        
        ballSprite.runAction(SKAction.sequence([SKAction.fadeInWithDuration(0.5), blastAction]))
    }
    
    // MARK: Initialization
    
    init(size: CGSize, game: Game) {
        
        self.game = game
        
        // Set up player sprites
        
        var playerSprites: [Game.Player.Identifier: SKSpriteNode] = [:]
        
        for player in game.players {
            
            let sprite = SKSpriteNode(texture: KenTexture.texturesForAction(.Rest).first!)
            
            sprite.position.y = -50.0
            sprite.xScale = 2.0 * player.geometricFactor
            sprite.yScale = 2.0
            sprite.alpha = 0.5
            
            playerSprites[player.identifier] = sprite
        }
        
        self.playerSprites = playerSprites
        
        // Set up health bars
        
        var healthBars: [Game.Player.Identifier: SKSpriteNode] = [:]
        
        for player in game.players {
            
            let bar = SKSpriteNode(color: UIColor.redColor(), size: CGSizeZero)
            
            healthBars[player.identifier] = bar
        }
        
        self.healthBars = healthBars
        
        self.maxHealthBarWidth = size.width / 3.0
        
        // Set up stamina bars
        
        var staminaBars: [Game.Player.Identifier: SKSpriteNode] = [:]
        
        for player in game.players {
            
            let bar = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeZero)
            
            staminaBars[player.identifier] = bar
        }
        
        self.staminaBars = staminaBars
        
        self.maxStaminaBarWidth = size.width / 4.0
        
        // Set up instruction
        
        instruction = SKSpriteNode(imageNamed: "Instruction")
        instruction.zPosition = 2
        instruction.position.y = -125.0
        instruction.hidden = true
        
        // Initialize super
        
        super.init(size: size)
        
        // Set up scene
        
        scaleMode = .AspectFit
        anchorPoint = CGPointMake(0.5, 0.5)
        
        backgroundColor = SKColor.whiteColor()
        
        // Add stage
        
        let stageScaleFactor = size.height / stage.size.height
        
        //stage.xScale = stageScaleFactor
        stage.yScale = stageScaleFactor
        
        self.addChild(stage)
        
        // Add logo
        
        logo.runAction(SKAction.fadeInWithDuration(3.0))
        
        addChild(logo)
        
        // Add Instruction
        
        let flashAction = SKAction.sequence([SKAction.unhide(), SKAction.waitForDuration(0.5), SKAction.hide(), SKAction.waitForDuration(0.5)])
        
        instruction.runAction(SKAction.sequence([SKAction.waitForDuration(3.0), SKAction.repeatActionForever(flashAction)]))
        
        addChild(instruction)
        
        // Add players
        
        updatePlayerSpriteLocationsAnimated(false)
        
        for (_, sprite) in self.playerSprites {
            
            sprite.runAction(restAction())
            
            addChild(sprite)
        }
        
        // Add health bars
        
        updateHealthBarFrames()
        
        for (_, bar) in self.healthBars {
            
            addChild(bar)
        }
        
        // Add stamina bars
        
        updateStaminaBarFrames()
        
        for (_, bar) in self.staminaBars {
            
            addChild(bar)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.game = Game()
        self.playerSprites = [:]
        self.healthBars = [:]
        self.maxHealthBarWidth = 0.0
        self.staminaBars = [:]
        self.maxStaminaBarWidth = 0.0
        self.instruction = SKSpriteNode()
        
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
