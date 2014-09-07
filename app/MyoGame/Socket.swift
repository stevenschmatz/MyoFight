//
//  Socket.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation

protocol SocketDelegate {
    
    func socket(socket: Socket, didReceiveGame game: Game)
}

class Socket: NSObject, GCDAsyncSocketDelegate {
    
    // MARK: Socket
    
    let host: String
    let port: UInt16
    
    let socket = GCDAsyncSocket()
    let separatorData = "\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    
    func connect() {
        
        var possibleConnectError: NSError?
        socket.connectToHost(host, onPort: port, withTimeout: 5.0, error: &possibleConnectError)
        
        if let error = possibleConnectError {
            println(error)
        }
        
        socket.readDataToData(separatorData, withTimeout: -1.0, tag: 0)
    }
    
    // MARK: Delegate
    
    var delegate: SocketDelegate?
    
    // MARK: Initialization
    
    init(host: String, port: UInt16) {
        
        self.host = host
        self.port = port
        
        super.init()
        
        socket.setDelegate(self, delegateQueue: dispatch_get_main_queue())
        
        connect()
    }
    
    // MARK: Socket delegate
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        
        println("Connected to \(host).")
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        
        if let game = gameForData(data) {
            
            delegate?.socket(self, didReceiveGame: game)
        }
        
        socket.readDataToData(separatorData, withTimeout: -1.0, tag: 0)
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        
        println("Disconnected")
        
        connect()
    }
    
    // MARK: Parse packet
    
    func gameForData(data: NSData) -> Game? {
        
        var possibleError: NSError?
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &possibleError)
        
        if let error = possibleError {
            
            println(error)
            return nil
            
        } else if let dictionary = json as? NSDictionary {
            
            println("JSON: \(dictionary)")
            
            if let playerArray = dictionary["PlayerData"] as? NSArray {
                
                if playerArray.count == Game.Player.Identifier.identifiers.count {
                    
                    var players: [Game.Player] = []
                    
                    for identifier in Game.Player.Identifier.identifiers {
                        
                        if let playerDictionary = playerArray[identifier.toRaw()] as? NSDictionary {
                            
                            let position = (playerDictionary["Position"] as? NSNumber)?.doubleValue
                            let health = (playerDictionary["Health"] as? NSNumber)?.doubleValue
                            let stamina = (playerDictionary["Stamina"] as? NSNumber)?.doubleValue
                            let action = Game.Player.Action.fromRaw(playerDictionary["Action"] as? String ?? "")
                            
                            if (position != nil && health != nil && stamina != nil) {
                                
                                players += [Game.Player(identifier: identifier, position: position!, health: health!, stamina: stamina!, action: action)]
                                
                            } else {
                                
                                println("Invalid player data")
                                return nil
                            }
                            
                        } else {
                            
                            println("Invalid player data")
                            return nil
                        }
                    }
                    
                    return Game(players: players, state: .Starting)
                    
                } else {
                    
                    println("Invalid players array")
                    return nil
                }
                
            } else {
                
                println("Invalid player data")
                return nil
            }
            
        } else {
            
            println("Invalid JSON")
            return nil
        }
    }
}
