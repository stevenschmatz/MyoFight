//
//  ViewController.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/5/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: Socket
    
    let socket = Socket(host: "192.168.0.198", port: 3458)
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        /*
        let socket = GCDAsyncSocket()
        
        socket.setDelegate(self, delegateQueue: dispatch_get_main_queue())
        
        var possibleConnectError: NSError?
        socket.connectToHost("192.168.0.198", onPort: 3458, withTimeout: -1, error: &possibleConnectError)
        
        if let error = possibleConnectError {
            println(error)
        }
        */
        
        //socket.readDataToData(separatorData, withTimeout: -1.0, tag: 0)
    }
}
