//
//  StartScene.swift
//  DungeonMaster
//
//  Created by Yuanrong Han on 5/1/20.
//  Copyright © 2020 Yuanrong Han. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    var startButton: SKSpriteNode!
    var GameTitle: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setupTitle()
        setupButton()
    }
    
    func setupTitle() {
        GameTitle = SKSpriteNode(imageNamed: "title")
        self.GameTitle.position = CGPoint(x: 0, y: 100)
        self.addChild(GameTitle)
        let m1 = SKAction.move(to: CGPoint(x: 0, y: 90), duration: 2)
        let m2 = SKAction.move(to: CGPoint(x: 0, y: 100), duration: 2)
        GameTitle.run(SKAction.repeatForever(SKAction.sequence([m1,m2])))
    }
    
    func setupButton() {
        self.startButton = SKSpriteNode(imageNamed: "startButton")
        startButton.position = CGPoint(x: 0, y: -50)
        startButton.zPosition = 0
        startButton.name = "StartButton"
        self.addChild(startButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            if touchNode.name == "StartButton" {
                let moveup = SKAction.move(to: CGPoint(x: touchNode.position.x, y: touchNode.position.y + 5), duration: 0.5)
                let movedown = SKAction.move(to: CGPoint(x: touchNode.position.x, y: touchNode.position.y - 5), duration: 0.5)
                touchNode.run(SKAction.repeatForever(SKAction.sequence([moveup, movedown])))
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
        let location = touch.location(in: self)
        let touchNode = atPoint(location)
        if touchNode.name == "StartButton" {
            touchNode.removeAllActions()
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
            }
            }
        }
    }
    
}
