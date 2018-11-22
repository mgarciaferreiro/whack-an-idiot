//
//  WhackSlot.swift
//  Project14
//
//  Created by Marta García Ferreiro on 5/14/17.
//  Copyright © 2017 Marta García Ferreiro. All rights reserved.
//  Followed and modified the tutorial from https://www.hackingwithswift.com/read/14
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var bad = SharingManager.sharedInstance.bad
    var good = SharingManager.sharedInstance.good

	var charNode: SKSpriteNode!

	var isVisible = false
	var isHit = false

	func configure(at position: CGPoint) {
		self.position = position

		let sprite = SKSpriteNode(imageNamed: "whackHole")
		addChild(sprite)

		let cropNode = SKCropNode()
		cropNode.position = CGPoint(x: 0, y: 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

		charNode = SKSpriteNode(imageNamed: good)
		charNode.position = CGPoint(x: 0, y: -90)
		charNode.name = "character"
		cropNode.addChild(charNode)

		addChild(cropNode)
	}

	func show(hideTime: Double) {
		if isVisible { return }

		charNode.xScale = 1
		charNode.yScale = 1
		charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))

		isVisible = true
		isHit = false

		if RandomInt(min: 0, max: 2) == 0 {
			charNode.texture = SKTexture(imageNamed: good)
			charNode.name = "charFriend"
		} else {
			charNode.texture = SKTexture(imageNamed: bad)
			charNode.name = "charEnemy"
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [unowned self] in
			self.hide()
		}
	}

	func hide() {
		if !isVisible { return }

		charNode.run(SKAction.moveBy(x: 0, y:-80, duration:0.05))
		isVisible = false
	}

	func hit() {
		isHit = true

		let delay = SKAction.wait(forDuration: 0.25)
		let hide = SKAction.moveBy(x: 0, y:-80, duration:0.5)
		let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
		charNode.run(SKAction.sequence([delay, hide, notVisible]))
	}

}
