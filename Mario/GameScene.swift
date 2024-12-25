//
//  GameScene.swift
//  Mario
//
//  Created by Aleksei on 10.12.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mario: SKSpriteNode!
    var background: SKNode!
    var marioController: MarioController!
    var buttonUp: SKSpriteNode!
    var buttonBack: SKSpriteNode!
    var buttonFront: SKSpriteNode!
    var restartButton: SKSpriteNode!
    var backDoor: SKSpriteNode!
    var mashDead: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var blackNode: SKSpriteNode!
    var coinLabel: SKLabelNode!
    var thanks: SKLabelNode!
    var productionLabel: SKLabelNode!
    var quesBlocks: [SKSpriteNode] = []
    
    
    var lastContactDirection: CGVector?
    var coinCol = 0
    
    
    var areButtonsEnabled = true

    
    var isMovingLeft = false
    var isMovingRight = false

    var nodesArray: [SKNode] = []
    
    struct PhysicsBodies {
        static let marioPhMask: UInt32 = 1
        static let groundPhMask: UInt32 = 2
        static let mashDeadPhMask: UInt32 = 3
        static let quesPhMask: UInt32 = 4
        static let flagPhMask: UInt32 = 5
        static let wallPhMask: UInt32 = 6
        static let pitsPhMask: UInt32 = 7
    }
    
    var gifTexturesRight: [SKTexture] = []
    var gifTexturesLeft: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        
        background = self.childNode(withName: "background")
        mario = self.childNode(withName: "mario") as? SKSpriteNode
        buttonUp = self.childNode(withName: "buttonUp") as? SKSpriteNode
        buttonBack = self.childNode(withName: "buttonBack") as? SKSpriteNode
        buttonFront = self.childNode(withName: "buttonFront") as? SKSpriteNode
        restartButton = self.childNode(withName: "restartButton") as? SKSpriteNode
        mashDead = self.childNode(withName: "background/mashDead") as? SKSpriteNode
        gameOver = self.childNode(withName: "gameOver") as? SKSpriteNode
        blackNode = self.childNode(withName: "blackNode") as? SKSpriteNode
        coinLabel = self.childNode(withName: "coinLabel") as? SKLabelNode
        backDoor = self.childNode(withName: "background/backDoor") as? SKSpriteNode
        thanks = self.childNode(withName: "thanks") as? SKLabelNode
        productionLabel = self.childNode(withName: "productionLabel") as? SKLabelNode
        
        self.enumerateChildNodes(withName: "background/quesBlock_*") { node, _ in
            if let block = node as? SKSpriteNode {
                self.quesBlocks.append(block)
            }
        }

           
        gifTexturesRight = [
            SKTexture(imageNamed: "gifka-1R"),
            SKTexture(imageNamed: "gifka-2R"),
            SKTexture(imageNamed: "gifka-3R"),
            SKTexture(imageNamed: "player")
        ]
        
        gifTexturesLeft = [
            SKTexture(imageNamed: "gifka-1L"),
            SKTexture(imageNamed: "gifka-2L"),
            SKTexture(imageNamed: "gifka-3L"),
            SKTexture(imageNamed: "mirror_player")
        ]
        
        self.physicsWorld.contactDelegate = self
        
        if let mashDead = mashDead {
            let moveLeft = SKAction.moveTo(x: mashDead.position.x + 80, duration: 3)
            let moveRight = SKAction.moveTo(x: mashDead.position.x - 80, duration: 3)
            let moveSequence = SKAction.sequence([moveLeft, moveRight])
            let repeatAction = SKAction.repeatForever(moveSequence)
            mashDead.run(repeatAction)
        }
        
        marioController = MarioController(
                   mario: mario,
                   background: background,
                   gifTexturesRight: gifTexturesRight,
                   gifTexturesLeft: gifTexturesLeft
        )
        
        gameOver?.alpha = 0
        blackNode?.alpha = 0
        coinLabel?.text = "Coin: \(coinCol)"
    }
    
    func handleQuesContact(with block: SKSpriteNode) {
        if quesBlocks.contains(block) {
            block.texture = SKTexture(imageNamed: "emptyBlock")
            block.physicsBody?.categoryBitMask = PhysicsBodies.wallPhMask
            block.zPosition = 1
            addCoin(from: block)
        }
    }

    
    func addCoin(from block: SKSpriteNode) {
        let coin = SKSpriteNode(imageNamed: "coin")
        let marioPos = mario.position
        coin.zPosition = 2
        coin.size = CGSize(width: 40, height: 60)
        coin.position = CGPoint(x: marioPos.x, y: marioPos.y)
        self.addChild(coin)

        let moveUp = SKAction.moveTo(y: coin.position.y + 100, duration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let remove = SKAction.removeFromParent()
        coin.run(SKAction.sequence([moveUp, fadeOut, remove]))
        
        coinCol += 1
        coinLabel.text = "Coin: \(coinCol)"
    }
    
    func died() {
        blackNode.run(SKAction.fadeIn(withDuration: 1))
        gameOver.run(SKAction.fadeIn(withDuration: 5))
        
        if let view = self.view {
            if let scene = SKScene(fileNamed: "Menu") {
                scene.scaleMode = .aspectFill
                
                self.run(SKAction.wait(forDuration: 7.0)) { view.presentScene(scene) }
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func end() {
         blackNode.run(SKAction.fadeIn(withDuration: 1))
         thanks.run(SKAction.fadeIn(withDuration: 5))
         if let view = self.view {
             if let scene = SKScene(fileNamed: "Menu") {
                 scene.scaleMode = .aspectFill
                 
                 self.run(SKAction.wait(forDuration: 7.0)) { view.presentScene(scene) }
             }
             
             view.ignoresSiblingOrder = true
             
             view.showsFPS = true
             view.showsNodeCount = true
         }
     }
    
    func endScene() {
        areButtonsEnabled = false
        let moveMario = SKAction.move(by: CGVector(dx: 20, dy: 0), duration: 0.2)
        mario.run(moveMario)
        
        self.run(SKAction.wait(forDuration: 3)){ [self] in
            physicsWorld.gravity = CGVector(dx: 0, dy: -3)
            let moveRight = SKAction.move(by: CGVector(dx: 250, dy: 0), duration: 7)
            let dviz = SKAction.animate(with: gifTexturesRight, timePerFrame: 0.125)
            mario.run(moveRight)
            mario.run(SKAction.repeatForever(dviz))
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
          
          
        let bodyA = contact.bodyA.node?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask ? contact.bodyA.node : contact.bodyB.node
        let bodyB = contact.bodyA.node?.physicsBody?.categoryBitMask != PhysicsBodies.marioPhMask ? contact.bodyA.node : contact.bodyB.node
                
          
        if (bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask && bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.groundPhMask) {
            
            marioController.set_isOnGround(val: true)
            marioController.continueMoving()
        }


        if bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask && bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.mashDeadPhMask {
            if !marioController.get_isOnGround(){
                bodyB?.removeFromParent()
            }
            else {
                died()
                bodyA?.removeFromParent()
            }
        }
        
        if bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask &&
            bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.pitsPhMask{
            died()
        }
          
          
        if (bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask &&
          bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.quesPhMask) {
            
            lastContactDirection = contact.contactNormal
            
            
            if contact.contactNormal.dy < 0 {
                marioController.set_isOnGround(val: true)
                marioController.continueMoving()
            }
            if contact.contactNormal.dy > 0{
                if let block = bodyB as? SKSpriteNode {
                    handleQuesContact(with: block)
                }
            }
            if contact.contactNormal.dx > 0 {
                marioController.set_canMoveRight(val: false)
                marioController.stopMoving()
                marioController.startMovingRight()
            }
            if contact.contactNormal.dx < 0 {
                marioController.set_canMoveLeft(val: false)
                marioController.stopMoving()
                marioController.startMovingLeft()
            }
        }

        
        if (bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask && bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.flagPhMask &&
            !marioController.get_isOnGround()) {
              bodyB?.removeFromParent()
              endScene()
            self.run(SKAction.wait(forDuration: 10)){
                bodyA?.removeFromParent()
                self.run(SKAction.wait(forDuration: 1)) { [self] in
                    end()
                }
            }
        }
        
        
        if (bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask && bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.wallPhMask) {
            
            lastContactDirection = contact.contactNormal

            if contact.contactNormal.dy < 0 {
                marioController.set_isOnGround(val: true)
                marioController.continueMoving()
            } else if contact.contactNormal.dx > 0 {
                marioController.set_canMoveRight(val: false)
                marioController.stopMoving()
                marioController.startMovingRight()
            } else if contact.contactNormal.dx < 0 {
                marioController.set_canMoveLeft(val: false)
                marioController.stopMoving()
                marioController.startMovingLeft()

            }
            
        }

    }
    
    func checkLastDirection(){
        if let lastDirection = lastContactDirection {
            if lastDirection.dx > 0 {
                marioController.set_canMoveRight(val: true)
                if isMovingRight {
                    marioController.startMovingRight()
                }
            } else if lastDirection.dx < 0 {
                marioController.set_canMoveLeft(val: true)
                if isMovingLeft {
                    marioController.startMovingLeft()
                }
            }
        }
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
    
        let bodyA = contact.bodyA.node?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask ? contact.bodyA.node : contact.bodyB.node
        let bodyB = contact.bodyA.node?.physicsBody?.categoryBitMask != PhysicsBodies.marioPhMask ? contact.bodyA.node : contact.bodyB.node
        
        
        if (bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask && bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.wallPhMask) {
            checkLastDirection()
        }
        if (bodyA?.physicsBody?.categoryBitMask == PhysicsBodies.marioPhMask && bodyB?.physicsBody?.categoryBitMask == PhysicsBodies.quesPhMask) {
            checkLastDirection()
        }
        
        
        
    }
    
    
    func restartGame(){
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene)
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard areButtonsEnabled else { return }

        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)
            if let nodeName = nodesAtPoint.first?.name {
                if nodeName == "buttonBack" {
                    isMovingLeft = true
                    marioController.startMovingLeft()
                } else if nodeName == "buttonFront" {
                    isMovingRight = true
                    marioController.startMovingRight()
                } else if nodeName == "buttonUp" {
                    marioController.marioJump()
                } else if nodeName == "restartButton"{
                    restartGame()
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)
            if let nodeName = nodesAtPoint.first?.name {
                if nodeName == "buttonBack" {
                    isMovingLeft = false
                    marioController.stopMoving()
                } else if nodeName == "buttonFront" {
                    isMovingRight = false
                    marioController.stopMoving()
                }
            }
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
    }
}
