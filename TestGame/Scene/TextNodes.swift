//
//  TextNode.swift
//  TestGame
//
//  Created by Andrii Drozdov on 5/8/19.
//  Copyright © 2019 Andrii Drozdov. All rights reserved.
//

import SpriteKit

class TextNodes {
    public var bestScore: Int = 0
    
    public var score: Int = 0
    
    private let gameTitleNode: SKLabelNode = SKLabelNode(fontNamed: "ArialRoundedMTBold")
    
    private let bestScoreNode: SKLabelNode = SKLabelNode(fontNamed: "ArialRoundedMTBold")
    
    private let currentScoreNode: SKLabelNode = SKLabelNode(fontNamed: "ArialRoundedMTBold")
    
    private var scene: GameScene!
    
    public init(scene: GameScene) {
        self.scene = scene
        self.bestScore = scene.persistor.readScore()
        
        createGameTitleNode()
        createBestScoreNode()
        createCurrentScoreNode()
    }
    
    public func increseScore() -> Void {
        score += 1
        currentScoreNode.text = "Score: \(score)"
    }
    
    public func resetScore() -> Void {
        score = 0
        currentScoreNode.text = "Score: \(score)"
    }
    
    public func show() -> Void {
        if bestScore < score {
            bestScoreNode.text = "Best score: \(score)"
        }
            
        self.currentScoreNode.run(SKAction.scale(to: 0, duration: 0.4)) {
            self.currentScoreNode.isHidden = true
        }
            
        self.gameTitleNode.isHidden = false
        self.gameTitleNode.run(SKAction.move(by: CGVector(dx: 1000, dy: 0), duration: 0.5))
        
        self.bestScoreNode.run(SKAction.move(to: CGPoint(x: 0, y: self.gameTitleNode.position.y - 50), duration: 0.4))
    }
    
    public func hide(callback: @escaping () -> Void) -> Void {
        gameTitleNode.run(SKAction.move(by: CGVector(dx: -1000, dy: 0), duration: 0.5)) {
            self.gameTitleNode.isHidden = true
        }
        
        bestScoreNode.run(SKAction.move(to: CGPoint(x: 0, y: (scene.frame.size.height / -2) + 20), duration: 0.4)) {
            self.currentScoreNode.setScale(0)
            self.currentScoreNode.isHidden = false
            self.currentScoreNode.run(SKAction.scale(to: 1, duration: 0.4))
            
            callback()
        }
    }
    
    private func createGameTitleNode() -> Void {
        gameTitleNode.zPosition = 1
        gameTitleNode.position = CGPoint(x: 0, y: (scene.frame.size.height / 2) - 200)
        gameTitleNode.fontSize = 60
        gameTitleNode.text = "SNAKE"
        gameTitleNode.fontColor = SKColor.red
        
        scene.addChild(gameTitleNode)
    }
    
    private func createBestScoreNode() -> Void {
        bestScoreNode.zPosition = 1
        bestScoreNode.position = CGPoint(x: 0, y: gameTitleNode.position.y - 50)
        bestScoreNode.fontSize = 40
        bestScoreNode.text = "Best Score: \(bestScore)"
        bestScoreNode.fontColor = SKColor.white
        
        scene.addChild(bestScoreNode)
    }
    
    private func createCurrentScoreNode() -> Void {
        currentScoreNode.zPosition = 1
        currentScoreNode.position = CGPoint(x: 0, y: (scene.frame.size.height / -2) + 60)
        currentScoreNode.fontSize = 40
        currentScoreNode.isHidden = true
        currentScoreNode.text = "Score: 0"
        currentScoreNode.fontColor = SKColor.white
        
        scene.addChild(currentScoreNode)
    }
}
