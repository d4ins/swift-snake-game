//
//  Buttons.swift
//  TestGame
//
//  Created by Andrii Drozdov on 5/8/19.
//  Copyright © 2019 Andrii Drozdov. All rights reserved.
//


import SpriteKit

class Buttons {
    private let playButton: SKShapeNode = SKShapeNode()

    private var scene: GameScene!
    
    public init(scene: GameScene) {
        self.scene = scene
        
        createButton()
    }
    
    public func show() -> Void {
        playButton.isHidden = false
        playButton.run(SKAction.move(by: CGVector(dx: -1000, dy: 0), duration: 0.5))
        playButton.run(SKAction.scale(to: 1, duration: 0.2))
    }
    
    public func hide() -> Void {
        playButton.run(SKAction.move(by: CGVector(dx: 1000, dy: 0), duration: 0.5))
        playButton.run(SKAction.scale(to: 0, duration: 0.2)) {
            self.playButton.isHidden = true
        }
    }
    
    private func createButton() -> Void {
        let topCorner: CGPoint = CGPoint(x: -50, y: 50)
        let bottomCorner: CGPoint = CGPoint(x: -50, y: -50)
        let middle: CGPoint = CGPoint(x: 50, y: 0)
        let path: CGMutablePath = CGMutablePath()
        
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (scene.frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        playButton.path = path
        
        scene.addChild(playButton)
    }
}
