//
//  MarioController.swift
//  Mario
//
//  Created by Aleksei on 10.12.2024.
//

import SpriteKit

class MarioController {
    private var mario: SKSpriteNode
    private var background: SKNode
    private var isOnGround = true
    private var marioLookFront = true
    private var gifTexturesRight: [SKTexture]
    private var gifTexturesLeft: [SKTexture]
    private var isMoving = false
    private var canMoveLeft = true
    private var canMoveRight = true


    init(mario: SKSpriteNode, background: SKNode, gifTexturesRight: [SKTexture], gifTexturesLeft: [SKTexture]) {
        self.mario = mario
        self.background = background
        self.gifTexturesRight = gifTexturesRight
        self.gifTexturesLeft = gifTexturesLeft
    }

    func get_isOnGround() -> Bool {
            return self.isOnGround
        }
        
    func set_isOnGround(val: Bool) {
        self.isOnGround = val
    }
    
    func get_marioLookFront() -> Bool {
            return self.marioLookFront
        }
        
    func set_marioLookFront(val: Bool) {
        self.marioLookFront = val
    }
    
    func get_isMoving() -> Bool {
            return self.isMoving
    }
        
    func set_isMoving(val: Bool) {
        self.isMoving = val
    }
    
    func get_canMoveLeft() -> Bool {
            return self.canMoveLeft
    }
        
    func set_canMoveLeft(val: Bool) {
        self.canMoveLeft = val
    }
    
    func get_canMoveRight() -> Bool {
            return self.canMoveRight
    }
        
    func set_canMoveRight(val: Bool) {
        self.canMoveRight = val
    }
    
    func marioJump(){
        guard isOnGround else { return }
        mario.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
        mario.removeAction(forKey: "animateLeft")
        mario.removeAction(forKey: "animateRight")
        isOnGround = false
        let textureName = marioLookFront ? "jump" : "mirror_jump"
        mario.run(SKAction.playSoundFileNamed("jump.mp3", waitForCompletion: true))
        mario.texture = SKTexture(imageNamed: textureName)
    }

    func startMovingLeft() {
        if canMoveLeft {
            let moveBackground = SKAction.repeatForever(SKAction.move(by: CGVector(dx: 20, dy: 0), duration: 0.2))
            
            background.run(moveBackground, withKey: "moveBackgroundLeft")
        }
        
            
        if mario.position.x != -20 {
            mario.position.x = -20
        }
        
        let animateLeft = SKAction.repeatForever(SKAction.animate(with: gifTexturesLeft, timePerFrame: 0.125))
        
        if isOnGround{
             mario.run(animateLeft, withKey: "animateLeft")
         }
        else {
             mario.texture = SKTexture(imageNamed: "mirror_jump")
        }
        
        isMoving = true
        
        marioLookFront = false
    }

    func startMovingRight() {
        
        if canMoveRight {
            let moveBackground = SKAction.repeatForever(SKAction.move(by: CGVector(dx: -20, dy: 0), duration: 0.2))
            
            background.run(moveBackground, withKey: "moveBackgroundRight")
        }
        
            
        if mario.position.x != -20 {
            mario.position.x = -20
        }
        
        let animateRight = SKAction.repeatForever(SKAction.animate(with: gifTexturesRight, timePerFrame: 0.125))
        
        if isOnGround{
            mario.run(animateRight, withKey: "animateRight")
        }
        else {
            mario.texture = SKTexture(imageNamed: "jump")
        }
        
        isMoving = true
        
        marioLookFront = true
    }
    
    func continueMoving(){
        if isMoving {
            let animate = SKAction.repeatForever(SKAction.animate(with: marioLookFront ? gifTexturesRight : gifTexturesLeft, timePerFrame: 0.125))
            let animateKey = marioLookFront ? "animateRight" : "animateLeft"
            mario.run(animate, withKey: animateKey)
        }
        else {
            mario.texture = marioLookFront ? SKTexture(imageNamed: "player") : SKTexture(imageNamed: "mirror_player")
        }
    }

    func stopMoving() {
        background.removeAction(forKey: "moveBackgroundLeft")
        background.removeAction(forKey: "moveBackgroundRight")
        mario.removeAction(forKey: "animateLeft")
        mario.removeAction(forKey: "animateRight")
        
        isMoving = false
        
        if isOnGround{
            mario.texture = marioLookFront ? SKTexture(imageNamed: "player") : SKTexture(imageNamed: "mirror_player")
        } else {
            let textureName = marioLookFront ? "jump" : "mirror_jump"
            mario.texture = SKTexture(imageNamed: textureName)
        }
    }
}
