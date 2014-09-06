//
//  GameScene.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: Texture
    
    let texture = Texture()
    
    // MARK: Sprites
    
    var ken: SKNode!
    
    func updateSquarePosition(position: CGFloat) {
        
        let x = (position * 2.0 - 1.0) * 100.0
        
        ken.runAction(SKAction.moveToX(x, duration: 0.1))
    }
    
    // MARK: Initialization
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        scaleMode = .ResizeFill
        anchorPoint = CGPointMake(0.5, 0.5)
        
        backgroundColor = SKColor.whiteColor()
        
        ken = SKSpriteNode(texture: texture.kenTexture)
        self.addChild(ken)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
