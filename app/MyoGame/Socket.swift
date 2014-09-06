//
//  Socket.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation

struct Packet {
    
    let position: Double
}

protocol SocketDelegate {
    
    func socket(socket: Socket, didReceivePacket packet: Packet)
}

class Socket: NSObject, GCDAsyncSocketDelegate {
    
    // MARK: Socket
    
    let host: String
    let port: UInt16
    
    let socket = GCDAsyncSocket()
    let separatorData = "\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    
    func connect() {
        
        var possibleConnectError: NSError?
        socket.connectToHost(host, onPort: port, withTimeout: -1, error: &possibleConnectError)
        
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
        
        var possibleError: NSError?
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &possibleError)
        
        if let error = possibleError {
            println(error)
        } else if let dictionary = json as? [String: AnyObject] {
            
            println("JSON: \(dictionary)")
            
            let position = (dictionary["Random"] as NSNumber).doubleValue
            
            let packet = Packet(position: position)
            
            delegate?.socket(self, didReceivePacket: packet)
            
        } else {
            
            println("Invalid JSON")
        }
        
        socket.readDataToData(separatorData, withTimeout: -1.0, tag: 0)
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        
        println("Disconnected")
        
        connect()
    }
}
