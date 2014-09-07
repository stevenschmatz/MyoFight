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
        
        for identifier in Player.Identifier.identifiers {
            players.append(Player(identifier: identifier))
        }
        
        self.players = players
        self.state = .Starting
    }
    
    init(players: [Player], state: State) {
        
        self.players = players;
        self.state = state;
    }
    
    struct Player: Hashable {
        
        let identifier: Identifier
        let position: Double
        let health: Double
        let stamina: Double
        let action: Action?
        
        init(identifier: Identifier) {
            
            self.identifier = identifier
            self.position = -1.0
            self.health = 1.0
            self.stamina = 0.5
        }
        
        init(identifier: Identifier, position: Double, health: Double, stamina: Double, action: Action?) {
            
            self.identifier = identifier
            self.position = position
            self.health = health
            self.stamina = stamina
            self.action = action
        }
        
        enum Identifier: Int {
            case Player1 = 1
            case Player2 = 2
            
            static let identifiers = [Player1, Player2]
        }
        
        enum Action: String {
            case Punch = "Punch"
            //case Blast = "Blast"
        }
        
        var hashValue: Int { return identifier.toRaw() }
    }
    
    enum State: String {
        
        case Starting = "Starting"
        case Playing = "Playing"
        case Finished = "Finished"
    }
}

func ==(lhs: Game.Player, rhs: Game.Player) -> Bool {
    return lhs.identifier == rhs.identifier
}
