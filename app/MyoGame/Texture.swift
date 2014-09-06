//
//  Texture.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import SpriteKit

class Texture {
    
    let texture = SKTexture(imageNamed: "Ken")
    
    lazy var kenTexture: SKTexture = {
        return SKTexture(rect: CGRectMake(0.0, 9.0 / 10.0, 1.0 / 7.0, 1.0 / 10.0), inTexture: self.texture)
    }()
}
