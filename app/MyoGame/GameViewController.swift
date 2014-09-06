//
//  ViewController.swift
//  MyoGame
//
//  Created by Russell Ladd on 9/5/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SocketDelegate {
    
    // MARK: Socket
    
    // Steven: 35.2.107.128
    
    let socket = Socket(host: "35.2.76.217", port: 3458)
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        socket.delegate = self
    }
    
    // MARK: Socket delegate
    
    func socket(socket: Socket, didReceivePacket packet: Packet) {
        
        scene.updateSquarePosition(CGFloat(packet.position))
    }
    
    // MARK: View
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        spriteView.presentScene(scene)
    }
    
    // MARK: SKView
    
    var spriteView: SKView { return view as SKView }
    
    // MARK: Scene
    
    let scene = GameScene(size: CGSizeMake(480.0, 320.0))
}
