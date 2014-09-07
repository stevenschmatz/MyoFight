//
//  Player.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation

struct Game {
    
    static let numPlayers = 2
    
    let players: [Player]
    let state: State
    
    init() {
        
        var players: [Player] = []
        
        for var i = 0; i < Game.numPlayers; i++ {
            players.append(Player())
        }
        
        self.players = players
        self.state = .Starting
    }
    
    init(players: [Player], state: State) {
        
        self.players = players;
        self.state = state;
    }
    
    struct Player {
        
        init() {
            
            self.position = 0.0
            self.health = 1.0
            self.stamina = 0.5
        }
        
        init(position: Double, health: Double, stamina: Double, action: Action?) {
            
            self.position = position
            self.health = health
            self.stamina = stamina
            self.action = action
        }
        
        enum Action: String {
            case Punch = "Punch"
            //case Blast = "Blast"
        }
        
        let position: Double
        let health: Double
        let stamina: Double
        let action: Action?
    }
    
    enum State: String {
        
        case Starting = "Starting"
        case Playing = "Playing"
        case Finished = "Finished"
    }
}
