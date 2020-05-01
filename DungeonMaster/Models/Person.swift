//
//  testPlayer.swift
//  spritekitTest
//
//  Created by Yuanrong Han on 4/14/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import SpriteKit
class Person: SKSpriteNode {
    var hitPoint: Int
    var atk: Int
    var def: Int
    var spd: Int
    var action: SKAction!
    var isInvincible: Bool
    var invincivleTimer: Int!
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        hitPoint = 100
        atk = 10
        def = 10
        spd = 2
        isInvincible = false
        invincivleTimer = 0
        super.init(texture: texture, color: color, size: size)
    }
    func attacked(by magic: Magic) {
        self.hitPoint = self.hitPoint - magic.atk * 1/self.def
        
    }
    
    func attacked(by monster: Person) {
        if !self.isInvincible {
            if self.hitPoint <= 0 {
                self.hitPoint = 0
                return
            }
            self.hitPoint = self.hitPoint - 50 //monster.atk * 1/self.def
        }
    }
    
    
    func attack(to person: Person, by magic: Magic) {
        person.hitPoint = person.hitPoint - magic.atk * 1/person.def
    }
    
    func attack(to person: Person) {
        person.hitPoint = person.hitPoint - self.atk * 1/person.def
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    class Player: Person {
        override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
            self.hitPoint = 1000
        }
        override func attacked(by monster: Person) {
            self.hitPoint -= 1
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class Monster: Person {
        override init(texture: SKTexture?, color: UIColor, size: CGSize) {
            super.init(texture: texture, color: color, size: size)
            self.hitPoint = 1000
        }
        
        func checkHP() {
            if self.hitPoint <= 0 {
                self.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2), SKAction.removeFromParent()]))
            }
        }
        
        override func attacked(by magic: Magic) {
            self.hitPoint = 0
            let hitaudio = SKAudioNode(fileNamed: "hit")
            self.addChild(hitaudio)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
