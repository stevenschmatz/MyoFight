//
//  Player.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation

struct Player {
    
    enum Action: String {
        case Punch = "Punch"
        //case Blast = "Blast"
    }
    
    let position: Double?
    let health: Double?
    let stamina: Double?
    let action: Action?
}
