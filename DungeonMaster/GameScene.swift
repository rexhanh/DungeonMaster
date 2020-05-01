//
//  GameScene.swift
//  DungeonMaster
//
//  Created by Yuanrong Han on 4/14/20.
//  Copyright © 2020 Yuanrong Han. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    enum collitionType: UInt32 {
        case player = 1
        case wall = 2
    }
    
    let animation = Animation()
    let attackButton = SKShapeNode(circleOfRadius: 32)
    let columns = 100
    let rows = 100
    let tileSize = CGSize(width: 32, height: 32)
    let moveJoystick = TLAnalogJoystick(withDiameter: 32)
    let playerCam = SKCameraNode()
    var tileMap = SKTileMapNode()
    var tileset = SKTileSet()
    var player = Player(imageNamed: "player_s1")
    var playerAngle: CGFloat!
    var playerhp: SKShapeNode!
    var keepPrevAnimation: Bool!
    var leftMosterNumber: SKLabelNode!
    override func didMove(to view: SKView) {
        setupBoundary()
        
//        setupBGM()
        playerCam.setScale(0.5)
        self.camera = playerCam
        setupPlayer()
        setupJoystick()
        setupHPbar()
        keepPrevAnimation = true
        setupPhysics()
        addRandomMonster(to: self.childNode(withName: "D1") as! SKTileMapNode, of: 10, with: "enemy_0")
        addRandomMonster(to: self.childNode(withName: "D2") as! SKTileMapNode, of: 20, with: "enemy_1")
        addRandomMonster(to: self.childNode(withName: "D3") as! SKTileMapNode, of: 30, with: "enemy_2")
        addRandomMonster(to: self.childNode(withName: "D4") as! SKTileMapNode, of: 40, with: "enemy_3")
        setupMonsterNumber()
    }
    
    func setupBoundary() {
        if let upperwall = self.childNode(withName: "UpperWall") as? SKTileMapNode {
            upperwall.physicsBody = SKPhysicsBody(rectangleOf: upperwall.mapSize)
            upperwall.physicsBody?.isDynamic = false
            upperwall.physicsBody?.affectedByGravity = false
        }
        if let lowerwall = self.childNode(withName: "LowerWall") as? SKTileMapNode {
            lowerwall.physicsBody = SKPhysicsBody(rectangleOf: lowerwall.mapSize)
            lowerwall.physicsBody?.isDynamic = false
            lowerwall.physicsBody?.affectedByGravity = false
        }
        if let leftwall = self.childNode(withName: "LeftWall") as? SKTileMapNode {
            leftwall.physicsBody = SKPhysicsBody(rectangleOf: leftwall.mapSize)
            leftwall.physicsBody?.isDynamic = false
            leftwall.physicsBody?.affectedByGravity = false
        }
        if let rightwall = self.childNode(withName: "RightWall") as? SKTileMapNode {
            rightwall.physicsBody = SKPhysicsBody(rectangleOf: rightwall.mapSize)
            rightwall.physicsBody?.isDynamic = false
            rightwall.physicsBody?.affectedByGravity = false
        }
    }
    
    
    func setupMonsterNumber() {
        self.leftMosterNumber = SKLabelNode()
        leftMosterNumber.position = CGPoint(x: 150, y: 120)
        leftMosterNumber.numberOfLines = 0
        leftMosterNumber.fontColor = .black
        leftMosterNumber.fontSize = 10
        self.player.addChild(leftMosterNumber)
    }
    
    func setupBGM() {
        let bgm = SKAudioNode(fileNamed: "bgm")
        bgm.autoplayLooped = true
        self.addChild(bgm)
        bgm.run(SKAction.changeVolume(to: Float(0.03), duration: 0))
    }
    
    func addMonster(to map: SKTileMapNode, with name: String) {
        let monster = Monster(imageNamed: name)
        monster.name = "Monster"
        let xrange = map.mapSize.width / 2 - 32
        let yrange = map.mapSize.height / 2 - 32
        let randomX = CGFloat.random(in: -xrange  ... xrange)
        let randomY = CGFloat.random(in: -yrange ... yrange)
        monster.position = CGPoint(x: randomX + map.position.x, y:randomY+map.position.y)
        monster.zPosition = Constants.playerZpos
        monster.run(SKAction.repeatForever(SKAction.sequence([SKAction.move(to: randCGpoint(for: map), duration: 10), SKAction.move(to: randCGpoint(for: map), duration: 10),SKAction.move(to: randCGpoint(for: map), duration: 10)])))
        self.addChild(monster)
    }
    
    private func randCGvec() -> CGVector {
        let randomX = CGFloat.random(in: -100  ... 100)
        let randomY = CGFloat.random(in: -100 ... 100)
        return CGVector(dx: randomX, dy: randomY)
    }
    
    private func randCGpoint(for map: SKTileMapNode) -> CGPoint {
        let randomX = CGFloat.random(in: -200  ... 200)
        let randomY = CGFloat.random(in: -200 ... 200)
        return CGPoint(x: randomX + map.position.x, y:randomY + map.position.y)
    }
    
    func addRandomMonster(to map: SKTileMapNode, of total: Int, with name: String) {
        for _ in 0 ..< total  {
            addMonster(to: map, with: name)
        }
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
        player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.collisionBitMask = collitionType.player.rawValue
        player.physicsBody?.categoryBitMask = collitionType.player.rawValue
        player.name = "Player"
        addChild(player)
        attackButton.position = CGPoint(x: frame.midX + 150, y: -frame.midY-100)
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
    
    func setupDungeonWall(at center: CGPoint) {
        let wall = self.tileset.tileGroups.first { $0.name == "Wall" }
        let wallLayerTop = SKTileMapNode(tileSet: self.tileset, columns: 16, rows: 1, tileSize: tileSize)
        let wallLayerBottom = SKTileMapNode(tileSet: self.tileset, columns: 16, rows: 1, tileSize: tileSize)
        let wallLeft = SKTileMapNode(tileSet: self.tileset, columns: 1, rows: 16, tileSize: tileSize)
        let wallRight = SKTileMapNode(tileSet: self.tileset, columns: 1, rows: 16, tileSize: tileSize)
        for i in 0 ..< 16 {
            wallLayerTop.setTileGroup(wall, forColumn: i, row: 0)
            wallLayerBottom.setTileGroup(wall, forColumn: i, row: 0)
            wallLeft.setTileGroup(wall, forColumn: 0, row: i)
            wallRight.setTileGroup(wall, forColumn: 0, row: i)
        }
        
        let walls = [wallLayerTop,wallLayerBottom,wallLeft,wallRight]

        let x = 2 * center.x
        let y = 2 * center.y
        wallLayerTop.position = CGPoint(x: x, y: y+8 * 32 - 16)
        wallLayerBottom.position = CGPoint(x: x, y: y - 8 * 32 + 16)
        wallLeft.position = CGPoint(x: -8*32+16+x, y: y)
        wallRight.position = CGPoint(x: 8*32 - 16 + x, y: y)
        let tbSize = CGSize(width: 32*16, height: 32)
        let lrSize = CGSize(width: 32, height: 32*16)
        wallLayerTop.physicsBody = SKPhysicsBody(rectangleOf: tbSize)
        wallLayerBottom.physicsBody = SKPhysicsBody(rectangleOf: tbSize)
        wallRight.physicsBody = SKPhysicsBody(rectangleOf: lrSize)
        wallLeft.physicsBody = SKPhysicsBody(rectangleOf: lrSize)
        for w in walls {
            w.physicsBody?.affectedByGravity = false
            w.physicsBody?.isDynamic = false
            w.physicsBody?.collisionBitMask = collitionType.wall.rawValue
            w.zPosition = Constants.layerZpos
            self.addChild(w)
        }
    }
    
    func setupPhysics() {
        guard let d1 = self.childNode(withName: "D1") as! SKTileMapNode? else {return}
        guard let d2 = self.childNode(withName: "D2") as! SKTileMapNode? else {return}
        guard let d3 = self.childNode(withName: "D3") as! SKTileMapNode? else {return}
        guard let d4 = self.childNode(withName: "D4") as! SKTileMapNode? else {return}
//        if let d1 = self.childNode(withName: "D1") as? SKTileMapNode{
//            print("level1")
            let col = d1.numberOfColumns
            let row = d1.numberOfRows
            let width = d1.tileSize.width
            let height = d1.tileSize.height
            let halfWidth = (CGFloat(col) / 2.0) * tileSize.width
            let halfHeight = (CGFloat(row) / 2.0) * tileSize.height
//            print("colums \(col), row: \(row)")
            for i in 0..<col {
                for j in 0..<row {
                    let tiledefination1 = d1.tileDefinition(atColumn: i, row: j)
                    let tiledefination2 = d2.tileDefinition(atColumn: i, row: j)
                    let tiledefination3 = d3.tileDefinition(atColumn: i, row: j)
                    let tiledefination4 = d4.tileDefinition(atColumn: i, row: j)
                    if let iswall1 = tiledefination1?.userData?["wallType"] as? Bool {
                        if (iswall1) {
//                            print("col\(i) row\(j) is wall")
                            let x = CGFloat(i) * width - halfWidth
                            let y = CGFloat(j) * height - halfHeight
//                            print("x \(x), y \(y)")
                            let rect = CGRect(x: 0, y: 0, width: width, height: height)
                            let tileNode = SKShapeNode(rect: rect)
                            tileNode.position = CGPoint(x: x, y: y+16)
                            tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: CGPoint(x: width / 2.0, y: height / 2.0))
                            tileNode.physicsBody?.isDynamic = false
                            tileNode.physicsBody?.collisionBitMask = collitionType.wall.rawValue
                            tileNode.lineWidth = 0
//                            tileNode.fillColor = SKColor.black
//                            tileNode.alpha = 0.5
                            d1.addChild(tileNode)
//                        }
                    }
                }
                    if let iswall2 = tiledefination2?.userData?["wallType"] as? Bool {
                        if (iswall2) {
//                            print("col\(i) row\(j) is wall")
                            let x = CGFloat(i) * width - halfWidth
                            let y = CGFloat(j) * height - halfHeight
//                            print("x \(x), y \(y)")
                            let rect = CGRect(x: 0, y: 0, width: width, height: height)
                            let tileNode = SKShapeNode(rect: rect)
                            tileNode.position = CGPoint(x: x, y: y+16)
                            tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: CGPoint(x: width / 2.0, y: height / 2.0))
                            tileNode.physicsBody?.isDynamic = false
                            tileNode.physicsBody?.collisionBitMask = collitionType.wall.rawValue
                            tileNode.lineWidth = 0
                            d2.addChild(tileNode)
                        }
                    }
                    
                    if let iswall3 = tiledefination3?.userData?["wallType"] as? Bool {
                        if (iswall3) {
//                            print("col\(i) row\(j) is wall")
                            let x = CGFloat(i) * width - halfWidth
                            let y = CGFloat(j) * height - halfHeight
//                            print("x \(x), y \(y)")
                            let rect = CGRect(x: 0, y: 0, width: width, height: height)
                            let tileNode = SKShapeNode(rect: rect)
                            tileNode.position = CGPoint(x: x, y: y+16)
                            tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: CGPoint(x: width / 2.0, y: height / 2.0))
                            tileNode.physicsBody?.isDynamic = false
                            tileNode.physicsBody?.collisionBitMask = collitionType.wall.rawValue
                            tileNode.lineWidth = 0
                            d3.addChild(tileNode)
                        }
                    }
                    
                    if let iswall4 = tiledefination4?.userData?["wallType"] as? Bool {
                        if (iswall4) {
//                            print("col\(i) row\(j) is wall")
                            let x = CGFloat(i) * width - halfWidth
                            let y = CGFloat(j) * height - halfHeight
//                            print("x \(x), y \(y)")
                            let rect = CGRect(x: 0, y: 0, width: width, height: height)
                            let tileNode = SKShapeNode(rect: rect)
                            tileNode.position = CGPoint(x: x, y: y+16)
                            tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileSize, center: CGPoint(x: width / 2.0, y: height / 2.0))
                            tileNode.physicsBody?.isDynamic = false
                            tileNode.physicsBody?.collisionBitMask = collitionType.wall.rawValue
                            tileNode.lineWidth = 0
                            d4.addChild(tileNode)
                        }
                    }
            }
        }
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
        // Called before each frame is rendered
        playerCam.position = player.position
        if !keepPrevAnimation {
            updateAnimation()
        }
        let magics = player.children
        var monsterNumber = 0
        for child in self.children {
            if child.name == "Monster" {
                monsterNumber += 1
                if player.intersects(child) {
                    if let m = child as? Monster{
                        player.attacked(by: m)
                        self.playerhp.removeFromParent()
                        setupHPbar()
                    }
                }
                for m in magics {
                    if child.intersects(m) && m.name == "Magic"{
                        m.removeFromParent()
                        if let magic = m as? Magic {
                            if let monster = child as? Monster {
                                monster.attacked(by: magic)
//                                print("Monster HP: \(monster.hitPoint)")
                                monster.checkHP()
                            }
                        }
                    }
                }
            }
        }
        if monsterNumber >= 99 {
            self.leftMosterNumber.text = "\(monsterNumber)/100"
        } else  {
            let s = SKScene(fileNamed: "BossScene")!
            s.scaleMode = .aspectFill
//            self.view?.presentScene(s)
            self.view?.presentScene(s, transition: SKTransition.fade(withDuration: 2))
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
            playerMagic.name = "Magic"
            playerMagic.blendMode = .alpha
            playerMagic.zPosition = player.zPosition
            playerMagic.position = CGPoint(x: frame.midX, y: frame.midY)
            playerMagic.atk = 200
            if touchNode.name == "AttackButton"{
                attackButton.alpha = 0.5
                player.addChild(playerMagic)
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
