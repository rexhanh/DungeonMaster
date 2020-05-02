//
//  EndScene.swift
//  DungeonMaster
//
//  Created by Yuanrong Han on 5/1/20.
//  Copyright © 2020 Yuanrong Han. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    var backButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.position = CGPoint(x: 0, y: -20)
        backButton.zPosition = 0
        backButton.name = "BackButton"
        self.addChild(backButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            if touchNode.name == "BackButton" {
                let s = SKScene(fileNamed: "StartScene")!
                s.scaleMode = .aspectFill
                self.view?.presentScene(s, transition: SKTransition.fade(withDuration: 0.2))
            }
        }
    }
}
