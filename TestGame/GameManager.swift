//
//  GameManager.swift
//  TestGame
//
//  Created by Andrii Drozdov on 5/5/19.
//  Copyright © 2019 Andrii Drozdov. All rights reserved.
//

import SpriteKit

class GameManager {
    public var isGameStarted: Bool = false
    
    public var prevFoodPosition: (Int, Int)?
    
    private let AVAILABLE_DIRECTIONS: [String: Int] = ["left": 1, "right": 2, "up": 3, "down": 4]
    
    private var nextTime: Double?
    
    private var scene: GameScene!
    
    private var snakeDirection: Int!
    
    private var snakeLength: Int = 3
    
    private var timeExtension: Double = 0.1
    
    init(scene: GameScene) {
        self.scene = scene
        self.snakeDirection = AVAILABLE_DIRECTIONS["left"]
    }
    
    public func startGame() -> Void {
        isGameStarted = true
        
        for i: Int in 1...snakeLength {
            scene.gameBoard.snakePosition.append((10, 10 + i))
        }
        
        addFood()
        renderChange()
    }
    
    public func endGame() -> Void {
        isGameStarted = false
        scene.endGame()
    }
    
    public func update(time: Double) -> Void {
        switch nextTime {
        case nil:
            nextTime = time + timeExtension
        default:
            if time >= nextTime! {
                nextTime = time + timeExtension
                updateSnakePosition()
            }
        }
    }
    
    public func updateDirection(direction: String) -> Void {
        if AVAILABLE_DIRECTIONS[direction] == snakeDirection ||
            (snakeDirection == AVAILABLE_DIRECTIONS["left"] && AVAILABLE_DIRECTIONS[direction] == AVAILABLE_DIRECTIONS["right"]) ||
            (snakeDirection == AVAILABLE_DIRECTIONS["right"] && AVAILABLE_DIRECTIONS[direction] == AVAILABLE_DIRECTIONS["left"]) ||
            (snakeDirection == AVAILABLE_DIRECTIONS["up"] && AVAILABLE_DIRECTIONS[direction] == AVAILABLE_DIRECTIONS["down"]) ||
            (snakeDirection == AVAILABLE_DIRECTIONS["down"] && AVAILABLE_DIRECTIONS[direction] == AVAILABLE_DIRECTIONS["up"]) {
            return
        }
        
        snakeDirection = AVAILABLE_DIRECTIONS[direction]
    }
    
    private func renderChange() -> Void {
        for (node, x, y) in scene.gameBoard.gameArray {
            if contains(a: scene.gameBoard.snakePosition, v: (x, y)) {
                node.fillColor = SKColor.cyan
            } else if contains(a: scene.gameBoard.foodPosition, v: (x, y)) {
                node.fillColor = SKColor.green
            } else {
                node.fillColor = SKColor.clear
            }
        }
    }
    
    private func addFood() -> Void {
        let foodPosition: (Int, Int) = (unsafeRandomIntFrom(from: 0, to: scene.gameBoard.ROWS - 1), unsafeRandomIntFrom(from: 0, to: scene.gameBoard.COLUMNS - 1))
        
        for item: (Int, Int) in scene.gameBoard.snakePosition {
            if foodPosition == item {
                addFood()
                return
            }
        }
        
        scene.gameBoard.foodPosition.append(foodPosition)
    }
    
    private func removeFood() -> Void {
        self.prevFoodPosition = scene.gameBoard.foodPosition[0]
        scene.gameBoard.foodPosition.remove(at: 0)
        scene.vibrate()
        scene.textNodes.increseScore()
        
        addFood()
    }
    
    private func contains(a: [(Int, Int)], v: (Int,Int)) -> Bool {
        let (c1, c2) = v
        
        for (v1, v2) in a {
            if v1 == c1 && v2 == c2 {
                return true
            }
        }
        
        return false
    }
    
    private func updateSnakePosition() -> Void {
        var horizontal: Int = 0
        var vertical: Int = 0
        
        switch snakeDirection {
        case AVAILABLE_DIRECTIONS["left"]:
            horizontal = -1
            break
        case AVAILABLE_DIRECTIONS["right"]:
            horizontal = 1
            break
        case AVAILABLE_DIRECTIONS["up"]:
            vertical = 1
            break
        case AVAILABLE_DIRECTIONS["down"]:
            vertical = -1
            break
        default:
            break
        }
        
        if scene.gameBoard.snakePosition.count > 0 {
            var start: Int = scene.gameBoard.snakePosition.count - 1
            
            while start > 0 {
                scene.gameBoard.snakePosition[start] = scene.gameBoard.snakePosition[start - 1]
                start -= 1
            }
            
            scene.gameBoard.snakePosition[0] = (newYPosition(vertical: vertical), newXPosition(horizontal: horizontal))
            
            for (index, position) in scene.gameBoard.snakePosition.enumerated() where index != 0 {
                if (scene.gameBoard.snakePosition.first! == position) {
                    endGame()
                    return
                }
            }
            
            if scene.gameBoard.snakePosition[0] == scene.gameBoard.foodPosition[0] {
                removeFood()
            }
            
            
            if prevFoodPosition != nil && scene.gameBoard.snakePosition.last! != prevFoodPosition! {
                scene.gameBoard.snakePosition.append(prevFoodPosition!)
                prevFoodPosition = nil
            }
        }
        
        renderChange()
    }
    
    private func newYPosition(vertical: Int) -> Int {
        let position: Int = scene.gameBoard.snakePosition[0].0 + vertical
        
        return newPosition(newPosition: position, total: scene.gameBoard.ROWS)
    }
    
    private func newXPosition(horizontal: Int) -> Int {
        let position: Int = scene.gameBoard.snakePosition[0].1 + horizontal
        
        return newPosition(newPosition: position, total: scene.gameBoard.COLUMNS)
    }
    
    private func newPosition(newPosition: Int, total: Int) -> Int {
        if newPosition < 0 {
            return total - 1
        } else if newPosition > total - 1 {
            return 0
        } else {
            return newPosition
        }
    }
    
    private func unsafeRandomIntFrom(from: Int, to: Int) -> Int {
        return Int(arc4random_uniform(UInt32(to - from + 1))) + from
    }
}
