//
//  GameScene.swift
//  TestGame
//
//  Created by Andrii Drozdov on 5/5/19.
//  Copyright © 2019 Andrii Drozdov. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

class GameScene: SKScene {
    public let persistor: Persistor = Persistor()
    
    public var gameBoard: GameBoard!
    
    public var textNodes: TextNodes!
    
    private var gameManager: GameManager!
    
    private var buttons: Buttons!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.gameBoard = GameBoard(scene: self)
        self.textNodes = TextNodes(scene: self)
        self.buttons = Buttons(scene: self)
        self.gameManager = GameManager(scene: self)
    }

    override func didMove(to view: SKView) {
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handeSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handeSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handeSwipe))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.handeSwipe))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameManager.isGameStarted {
            gameManager.update(time: currentTime)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location: CGPoint = touch.location(in: self)
            let touchedNodes: [SKNode] = self.nodes(at: location)
            
            for node: SKNode in touchedNodes {
                if node.name == "play_button" {
                    startGame()
                }
            }
        }
    }
    
    public func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    @objc private func handeSwipe(swipe: UISwipeGestureRecognizer) {
        var direction: String = "left"
        
        switch swipe.direction {
        case UISwipeGestureRecognizer.Direction.right:
            direction = "right"
        case UISwipeGestureRecognizer.Direction.up:
            direction = "down"
        case UISwipeGestureRecognizer.Direction.down:
            direction = "up"
        default:
            direction = "left"
        }
        
        gameManager.updateDirection(direction: direction)
    }
    
    public func endGame() -> Void {
        gameManager = GameManager(scene: self)
        gameBoard.snakePosition = []
        gameBoard.foodPosition = []
        
        vibrate()
        
        if textNodes.bestScore < textNodes.score {
            persistor.saveScore(score: textNodes.score)
        }
        
        gameBoard.hide(callback: {
            self.buttons.show()
            self.textNodes.show()
        })
    }
    
    private func startGame() -> Void {
        vibrate()
        
        buttons.hide()
        textNodes.hide(callback: {
            self.gameBoard.show()
            self.gameManager.startGame()
        })
    }
}
