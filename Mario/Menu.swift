//
//  Menu.swift
//  Mario
//
//  Created by Aleksei on 30.07.2022.
//

import SpriteKit

class Menu: SKScene {
    
    var contLable: SKSpriteNode!
    override func didMove(to view: SKView) {
        
        contLable = self.childNode(withName: "contLable") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "contLable" {

                if let view = self.view {
                    if let scene = SKScene(fileNamed: "GameScene") {
                        scene.scaleMode = .aspectFill

                        view.presentScene(scene)
                    }
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
}
