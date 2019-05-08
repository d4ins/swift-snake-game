//
//  GameBoard.swift
//  TestGame
//
//  Created by Andrii Drozdov on 5/8/19.
//  Copyright © 2019 Andrii Drozdov. All rights reserved.
//

import SpriteKit

class GameBoard {
    public let ROWS: Int = 40
    
    public let COLUMNS: Int = 20
    
    public var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    
    public var snakePosition: [(Int, Int)] = []
    
    public var foodPosition: [(Int, Int)] = []
    
    private var scene: GameScene!
    
    private var backgroundNode: SKShapeNode!
    
    public init(scene: GameScene) {
        self.scene = scene
        
        let width: CGFloat = scene.frame.size.width - 200
        let height: CGFloat = scene.frame.size.height - 240
        
        createBackgroundNode(width: width, height: height)
        createGameBoard(width: width, height: height)
    }
    
    public func show() {
        backgroundNode.setScale(0)
        backgroundNode.isHidden = false
        backgroundNode.run(SKAction.scale(to: 1, duration: 0.4))
    }
    
    public func hide(callback: @escaping () -> Void) {
        backgroundNode.run(SKAction.scale(to: 0, duration: 0.4)) {
            self.backgroundNode.isHidden = false
            callback()
        }
    }
    
    private func createBackgroundNode(width: CGFloat, height: CGFloat) -> Void {
        let rect: CGRect = CGRect(x: -width / 2, y: (-height / 2) - 6, width: width, height: height + 6)
        
        backgroundNode = SKShapeNode(rect: rect, cornerRadius: 0.02)
        backgroundNode.fillColor = SKColor.darkGray
        backgroundNode.zPosition = 2
        backgroundNode.isHidden = true
        backgroundNode.position = CGPoint(x: 0, y: 50)
        
        scene.addChild(backgroundNode)
    }
    
    private func createGameBoard(width: CGFloat, height: CGFloat) -> Void {
        let cellWidth: CGFloat = 27.5
        
        var x: CGFloat = CGFloat(width / -2) + (cellWidth / 2)
        var y: CGFloat = CGFloat(height / 2) - (cellWidth / 2)
        
        for i in 0...ROWS - 1 {
            for j in 0...COLUMNS - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                
                cellNode.strokeColor = SKColor.black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
        
                gameArray.append((node: cellNode, x: i, y: j))
                backgroundNode.addChild(cellNode)
    
                x += cellWidth
            }
        
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
}
