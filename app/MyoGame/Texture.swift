//
//  Texture.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import SpriteKit

let KenTexture = Texture(imageNamed: "Ken", numSpritesWide: 7, numSpritesHigh: 10)

enum CharacterAction {
    case Rest
    case Punch
    case PowerUp
    case Blast
    case Explosion
    
    var spriteLocations: [SpriteLocation] {
        
        switch self {
            
        case Rest:
            return [
                SpriteLocation(x: 0, y: 8),
                SpriteLocation(x: 1, y: 8),
                SpriteLocation(x: 2, y: 8),
                SpriteLocation(x: 3, y: 8)]
            
        case Punch:
            return [
                SpriteLocation(x: 0, y: 7),
                SpriteLocation(x: 1, y: 7),
                SpriteLocation(x: 2, y: 7)]
            
        case PowerUp:
            return [
                SpriteLocation(x: 0, y: 9),
                SpriteLocation(x: 1, y: 9),
                SpriteLocation(x: 2, y: 9),
                SpriteLocation(x: 3, y: 9)]
            
        case Blast:
            return [
                SpriteLocation(x: 0, y: 5),
                SpriteLocation(x: 1, y: 5),
                SpriteLocation(x: 0, y: 5),
                SpriteLocation(x: 1, y: 5)]
            
        case Explosion:
            return [
                SpriteLocation(x: 0, y: 4),
                SpriteLocation(x: 1, y: 4),
                SpriteLocation(x: 2, y: 4),
                SpriteLocation(x: 3, y: 4)]
        }
    }
}

struct SpriteLocation {
    let x: Int
    let y: Int
}

class Texture {
    
    // MARK: Properties
    
    let texture: SKTexture
    
    let numSpritesWide: Int
    let numSpritesHigh: Int
    
    var spriteWidth: CGFloat { return 1.0 / CGFloat(numSpritesWide) }
    var spriteHeight: CGFloat { return 1.0 / CGFloat(numSpritesHigh) }
    
    // MARK: Initialization
    
    init(imageNamed imageName: String, numSpritesWide: Int, numSpritesHigh: Int) {
        
        texture = SKTexture(imageNamed: imageName)
        
        self.numSpritesWide = numSpritesWide
        self.numSpritesHigh = numSpritesHigh
    }
    
    // MARK: Get textures
    
    func texturesForLocations(locations: [SpriteLocation]) -> [SKTexture] {
        
        return locations.map { location in
            
            let rect = CGRectMake(CGFloat(location.x) * self.spriteWidth, CGFloat(location.y) * self.spriteHeight, self.spriteWidth, self.spriteHeight)
            
            return SKTexture(rect: rect, inTexture: self.texture)
        }
    }
    
    func texturesForAction(action: CharacterAction) -> [SKTexture] {
        return texturesForLocations(action.spriteLocations)
    }
}
