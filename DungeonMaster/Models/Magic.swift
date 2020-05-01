//
//  testMagic.swift
//  spritekitTest
//
//  Created by Yuanrong Han on 4/18/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import SpriteKit

class Magic: SKSpriteNode {
    var atk = 40
    var range = 50
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name = "magic"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
