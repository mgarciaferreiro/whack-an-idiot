//
//  GameScene.swift
//  Project14
//
//  Created by Marta García Ferreiro on 5/14/17.
//  Copyright © 2017 Marta García Ferreiro. All rights reserved.
//  Inspired by the tutorial from https://www.hackingwithswift.com/read/14
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
	var gameScore: SKLabelNode!
	var score: Int = 0 {
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}

    var slots = [WhackSlot]()
    var popupTime = 0.85
    var numRounds = 0
    var malletNode: SKSpriteNode!
    var malletIsVisible = false

    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "whackBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)

		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.position = CGPoint(x: 8, y: 8)
		gameScore.horizontalAlignmentMode = .left
		gameScore.fontSize = 48
		addChild(gameScore)

		for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
		for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
		for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
		for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }

		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
			self.createEnemy()
		}
    }

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
            
        if (malletIsVisible == false){
			let location = touch.location(in: self)
			let tappedNodes = nodes(at: location)
            malletNode = SKSpriteNode(imageNamed: "mallet")
            malletNode.position = location
            malletNode.zPosition = 1
            addChild(malletNode)
            malletIsVisible = true
            malletNode.run(SKAction.moveBy(x: 25, y: 15, duration: 0))
            malletNode.run(SKAction.moveBy(x: 0, y: -20, duration: 0.1))
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.1)) { self.malletNode.isHidden = true
                self.malletIsVisible = false
            }
            
			for node in tappedNodes {
				if node.name == "charFriend" {
					// they shouldn't have whacked this character
					let whackSlot = node.parent!.parent as! WhackSlot
					if !whackSlot.isVisible { continue }
					if whackSlot.isHit { continue }

					whackSlot.hit()
					score -= 5
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
                    
				} else if node.name == "charEnemy" {
					// they should have whacked this character
					let whackSlot = node.parent!.parent as! WhackSlot
					if !whackSlot.isVisible { continue }
					if whackSlot.isHit { continue }

					whackSlot.charNode.xScale = 0.85
					whackSlot.charNode.yScale = 0.85

					whackSlot.hit()
					score += 1
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
				}
			}
		}
        }
	}
    
	func createSlot(at position: CGPoint) {
		let slot = WhackSlot()
		slot.configure(at: position)
		addChild(slot)
		slots.append(slot)
	}

	func createEnemy() {
		numRounds += 1

		if numRounds >= 40 {
			for slot in slots {
				slot.hide()
			}
			let gameOver = SKSpriteNode(imageNamed: "gameOver")
			gameOver.position = CGPoint(x: 512, y: 384)
			gameOver.zPosition = 1
			addChild(gameOver)

			return
		}

		popupTime *= 0.95

		slots = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: slots) as! [WhackSlot]
		slots[0].show(hideTime: popupTime)

		if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
		if RandomInt(min: 0, max: 12) > 8 {  slots[2].show(hideTime: popupTime) }
		if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
		if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime)  }

		let minDelay = popupTime / 2.0
		let maxDelay = popupTime * 2
		let delay = RandomDouble(min: minDelay, max: maxDelay)

		DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
			self.createEnemy()
		}
	}
}
