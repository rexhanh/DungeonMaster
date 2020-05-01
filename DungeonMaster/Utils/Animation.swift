//
//  Animation.swift
//  DungeonMaster
//
//  Created by Yuanrong Han on 4/19/20.
//  Copyright © 2020 Yuanrong Han. All rights reserved.
//

import SpriteKit
class Animation {
    var North: SKAction!
    var South: SKAction!
    var East: SKAction!
    var West: SKAction!
    var Boss1: SKAction!

    init() {
        setupNorth()
        setupSouth()
        setupEast()
        setupWest()
        setupBoss1()
    }
    
    private func setupBoss1() {
        var texture: [SKTexture] = []
        for i in 0...2 {
            texture.append(SKTexture(imageNamed: "boss1_\(i)"))
        }
        texture.append(SKTexture(imageNamed: "boss1_1"))
        self.Boss1 = SKAction.animate(with: texture, timePerFrame: 0.2)
    }
    
    
    private func setupSouth() {
        var texture: [SKTexture] = []
        for i in 1...3 {
            texture.append(SKTexture(imageNamed: "player_s\(i)"))
        }
        texture.append(SKTexture(imageNamed: "player_s\(2)"))
        self.South = SKAction.animate(with: texture, timePerFrame: 0.2)
    }
    private func setupNorth() {
        var texture: [SKTexture] = []
        for i in 1...3 {
            texture.append(SKTexture(imageNamed: "player_n\(i)"))
        }
        texture.append(SKTexture(imageNamed: "player_n\(2)"))
        self.North = SKAction.animate(with: texture, timePerFrame: 0.2)
    }

    private func setupEast() {
        var texture: [SKTexture] = []
        for i in 1...3 {
            texture.append(SKTexture(imageNamed: "player_e\(i)"))
        }
        texture.append(SKTexture(imageNamed: "player_e\(2)"))
        self.East = SKAction.animate(with: texture, timePerFrame: 0.2)
    }

    private func setupWest() {
        var texture: [SKTexture] = []
        for i in 1...3 {
            texture.append(SKTexture(imageNamed: "player_w\(i)"))
        }
        texture.append(SKTexture(imageNamed: "player_w\(2)"))
        self.West = SKAction.animate(with: texture, timePerFrame: 0.2)
        }
    }
