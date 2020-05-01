//
//  BossScene.swift
//  DungeonMaster
//
//  Created by Yuanrong Han on 4/30/20.
//  Copyright © 2020 Yuanrong Han. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class BossScene: SKScene {
       
    enum collitionType: UInt32 {
        case player = 1
        case wall = 2
    }
        
    let animation = Animation()
    let attackButton = SKShapeNode(circleOfRadius: 64)
    let moveJoystick = TLAnalogJoystick(withDiameter: 64)
    let playerCam = SKCameraNode()
    var bossHpBar: SKShapeNode!
    var player = Player(imageNamed: "player_s1")
    var playerAngle: CGFloat!
    var playerhp: SKShapeNode!
    var keepPrevAnimation: Bool!
    var leftMosterNumber: SKLabelNode!
    var boss1: Monster!
    var bossDead: Bool!
    
    override func didMove(to view: SKView) {
        bossDead = false
        self.camera = playerCam
        keepPrevAnimation = true
        setupPlayer()
        setupJoystick()
        setupHPbar()
        setupBoss()
        setupBossHPbar()
    }
    
    func setupBossHPbar() {
        let hpBar = SKShapeNode(rect: CGRect(x: -250, y: 265, width: 500*self.boss1.hitPoint/1000, height: 10))
        hpBar.fillColor = .red
        hpBar.zPosition = player.zPosition
        hpBar.name = "BossHP"
        hpBar.lineWidth = 1

        player.addChild(hpBar)
        self.bossHpBar = hpBar
    }
    
    func setupBoss() {
        let boss1 = Monster(imageNamed: "boss1_1")
        boss1.position = CGPoint(x: 100, y: 100)
        boss1.zPosition = 0
        boss1.run(SKAction.repeatForever(animation.Boss1))
        boss1.name = "Boss1"
        self.boss1 = boss1
//        circleAttack(from: boss1)
        self.addChild(boss1)
    }
    
    func randomMove(for boss: Monster) {
        let randomX = CGFloat.random(in: -200 ... 200)
        let randomY = CGFloat.random(in: -300 ... 300)
        let randomPoint = CGPoint(x: randomX, y: randomY)
        boss.run(SKAction.move(to: randomPoint, duration: 1))
    }
    
    func circleAttack(from boss: Monster) {
        let attackDisappear = SKAction.fadeOut(withDuration: 0.1)
        let attackDone = SKAction.removeFromParent()
        for i in 0..<30{
            let magic = SKShapeNode(circleOfRadius: 8)
            magic.lineWidth = 0
            magic.fillColor = .purple
            magic.alpha = 0.7
            magic.zPosition = 0
            magic.name = "Magic"
            magic.position = boss.position
            self.addChild(magic)
            let angle = CGFloat(2 * i) * CGFloat.pi / 30
            let x = 500 * cos(angle)
            let y = 500 * sin(angle)
            let a = SKAction.move(to: CGPoint(x: x, y: y), duration: 4)
            magic.run(SKAction.sequence([a, attackDisappear, attackDone]))
        }
    }
    
    func straightAttack(from boss: Monster) {
        let attackDisappear = SKAction.fadeOut(withDuration: 0.1)
        let attackDone = SKAction.removeFromParent()
        let magic = SKShapeNode(circleOfRadius: 8)
        magic.lineWidth = 0
        magic.fillColor = .purple
        magic.alpha = 0.7
        magic.zPosition = 0
        magic.name = "Magic"
        magic.position = boss.position
        self.addChild(magic)
        let goal = player.position
        
//        print("Player position is \(goal)")
//        print("Boss position is \(magic.position)")
        let attack = SKAction.move(to: goal, duration: 2)
        magic.run(SKAction.sequence([attack ,attackDisappear, attackDone]))
    }
    
    
    
    
    func setupHPbar() {
        let hpBar = SKShapeNode(rect: CGRect(x: -16, y: 20, width: 32*self.player.hitPoint/1000, height: 4))
        hpBar.fillColor = SKColor.green
        hpBar.zPosition = player.zPosition
        hpBar.name = "HP"
        hpBar.lineWidth = 1
        player.addChild(hpBar)
        self.playerhp = hpBar
    }
        
        func setupPlayer() {
            player.zPosition = 1
            player.position = CGPoint(x: frame.midX, y: frame.midY)
            player.physicsBody = SKPhysicsBody(circleOfRadius: 8)
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.collisionBitMask = collitionType.player.rawValue
            player.physicsBody?.categoryBitMask = collitionType.player.rawValue
            player.name = "Player"
            addChild(player)
            attackButton.position = CGPoint(x: frame.midX + 300, y: frame.midY - 200)
            attackButton.fillColor = SKColor.white
            attackButton.name = "AttackButton"
            attackButton.alpha = 0.1
            attackButton.zPosition = Constants.playerZpos
            player.run(SKAction.repeatForever(animation.South))
            player.addChild(self.attackButton)
        }
        
        func setupJoystick() {
            
            moveJoystick.handleImage = UIImage(named: "jStick")
            moveJoystick.baseImage = UIImage(named: "jSubstrate")
            let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: 0, y: 0, width: -500, height: -500))
            moveJoystickHiddenArea.joystick = moveJoystick
            moveJoystickHiddenArea.lineWidth = 0
            moveJoystick.isMoveable = false
            moveJoystick.on(.move) { [unowned self] joystick in
                let pVelocity = joystick.velocity
                let speed = CGFloat(0.05)
                self.player.position = CGPoint(x: self.player.position.x + (pVelocity.x * speed), y: self.player.position.y + (pVelocity.y * speed))
                self.playerAngle = joystick.angular
                self.keepPrevAnimation = false
            }
            
            moveJoystick.on(.end) { [unowned self] joystick in
                self.keepPrevAnimation = true
            }

            player.addChild(moveJoystickHiddenArea)
        }
    func updateAnimation() {
        guard let lastAngle = self.playerAngle else {return}
        if abs(lastAngle - self.moveJoystick.angular) >= 0.01 {
            guard var currAng = self.playerAngle else {
                return
            }
            if currAng < 0 {
                currAng += 2 * CGFloat.pi
            }
            if currAng < 1.75 * CGFloat.pi && currAng >= 1.25 * CGFloat.pi{
                player.run(SKAction.repeatForever(animation.South))
            } else if currAng < 1.25 * CGFloat.pi && currAng >= 0.75 * CGFloat.pi  {
                player.run(SKAction.repeatForever(animation.West))
            } else if currAng < 0.25 * CGFloat.pi && currAng >= 0 || currAng > 1.75 * CGFloat.pi && currAng <= 2 * CGFloat.pi {
                player.run(SKAction.repeatForever(animation.East))
            } else if currAng < 0.75 * CGFloat.pi && currAng >= 0 {
                player.run(SKAction.repeatForever(animation.North))
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        playerCam.position = player.position
        print("Boss hp: \(self.boss1.hitPoint)")
        if !keepPrevAnimation {
            updateAnimation()
        }
        let r = Int.random(in: 0..<1000)
        if r > 980 && !bossDead {
            straightAttack(from: self.boss1)
        } else if r > 970 && r <= 980 && !bossDead{
            circleAttack(from: self.boss1)
            randomMove(for: self.boss1)
        }
        for c in self.children {
            if c.name == "Magic" {
                if let magic = c as? SKShapeNode {
                    if magic.intersects(self.childNode(withName: "Player")!) {
                        magic.removeFromParent()
                        player.hitPoint -= 50
                        self.playerhp.removeFromParent()
                        setupHPbar()
                    }
                }
            }
            if c.name == "PlayerMagic" {
                if let magic = c as? Magic {
                    if let b = self.childNode(withName: "Boss1") as? Monster {
                        if magic.intersects(b) {
                            magic.removeFromParent()
                            boss1.hitPoint -= 25
                            self.bossHpBar.removeFromParent()
                            setupBossHPbar()
                            if boss1.hitPoint <= 0 {
                                self.bossDead = true
                                let bossDisappear = SKAction.fadeOut(withDuration: 3)
                                let bossDead = SKAction.removeFromParent()
                                boss1.run(SKAction.sequence([bossDisappear, bossDead]))
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            let x_max = 200 * cos(playerAngle)
            let y_max = 200 * sin(playerAngle)
            let magicAction = SKAction.moveBy(x: x_max, y: y_max, duration: 0.5)
            let magicDisappear = SKAction.fadeOut(withDuration: 0.1)
            let magicActionDone = SKAction.removeFromParent()
            let playerMagic = Magic(imageNamed: "energy_bolt")
            playerMagic.name = "PlayerMagic"
            playerMagic.blendMode = .alpha
            playerMagic.zPosition = player.zPosition
            playerMagic.position = player.position
            playerMagic.atk = 200
            if touchNode.name == "AttackButton"{
                attackButton.alpha = 0.5
                self.addChild(playerMagic)
                playerMagic.run(SKAction.sequence([magicAction, magicDisappear, magicActionDone]))
                }
            }
        }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            if touchNode.name == "AttackButton" {
                attackButton.alpha = 0.1
            }
        }
    }
}


