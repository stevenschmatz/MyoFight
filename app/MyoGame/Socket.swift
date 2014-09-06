//
//  Socket.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/6/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation

class Socket: NSObject, GCDAsyncSocketDelegate {
    
    // MARK: Socket
    
    let socket = GCDAsyncSocket()
    let separatorData = "\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    
    // MARK: Initialization
    
    init(host: String, port: UInt16) {
        
        super.init()
        
        socket.setDelegate(self, delegateQueue: dispatch_get_main_queue())
        
        var possibleConnectError: NSError?
        socket.connectToHost(host, onPort: port, withTimeout: -1, error: &possibleConnectError)
        
        if let error = possibleConnectError {
            println(error)
        }
        
        socket.readDataToData(separatorData, withTimeout: -1.0, tag: 0)
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
            
        } else {
            
            println("Invalid JSON")
        }
        
        socket.readDataToData(separatorData, withTimeout: -1.0, tag: 0)
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        
        println("Disconnected")
    }
}
