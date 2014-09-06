//
//  GameScene.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: Sprites
    
    var square: SKNode!
    
    func updateSquarePosition(position: CGFloat) {
        
        let x = (position * 2.0 - 1.0) * 100.0
        
        square.runAction(SKAction.moveToX(x, duration: 0.1))
        
        //square.position = CGPointMake(x, 0.0)
    }
    
    // MARK: Initialization
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        scaleMode = .ResizeFill
        anchorPoint = CGPointMake(0.5, 0.5)
        
        backgroundColor = SKColor.whiteColor()
        
        square = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(100.0, 100.0))
        self.addChild(square)
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        println("init with coder")
    }
}
