//
//  GameScene.swift
//  Snake
//
//  Created by Robert Lent on 3/30/19.
//  Copyright © 2019 Lent Coding. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var logo: SKLabelNode!
    var highScore: SKLabelNode!
    var playButton: SKShapeNode!
    var game: GameManager!
    var currentScore: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var gameBackground: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    var scorePos: CGPoint?
    
    override func didMove(to view: SKView) {
        initializeMenu()
        
        game = GameManager(scene: self)
        
        initializeGameView()
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down

        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
            }
        }
    }
    
    private func startGame() {
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        
        logo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.logo.isHidden = true
        }
        
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        
        highScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBackground.setScale(0)
            self.currentScore.setScale(0)
            self.gameBackground.isHidden = false
            self.currentScore.isHidden = false
            self.gameBackground.run(SKAction.scale(to: 1, duration: 0.4))
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            
            self.game.initGame()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        game.update(time: currentTime)
    }
    
    private func initializeMenu() {
        logo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        logo.zPosition = 1
        logo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        logo.fontSize = 60
        logo.text = "SNAKE"
        logo.fontColor = SKColor.red
        
        highScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        highScore.zPosition = 1
        highScore.position = CGPoint(x: 0, y: logo.position.y - 50)
        highScore.fontSize = 45
        highScore.text = "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))"
        highScore.fontColor = SKColor.white
        
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        
        self.addChild(logo)
        self.addChild(highScore)
        self.addChild(playButton)
    }
    
    private func initializeGameView() {
        currentScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        currentScore.fontSize = 45
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        
        let width = Int(frame.size.width - 190)
        let height = width * 2
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        
        gameBackground = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBackground.fillColor = SKColor.darkGray
        gameBackground.zPosition = 2
        gameBackground.isHidden = true
        
        self.addChild(currentScore)
        self.addChild(gameBackground)

        createGameBoard(width: width, height: height)
    }
    
    private func createGameBoard(width: Int, height: Int) {
        let numCols = 20
        let numRows = numCols * 2
        let cellWidth: CGFloat = CGFloat(width) / CGFloat(numCols)
        
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)

        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)

                gameArray.append((node: cellNode, x: i, y: j))
                gameBackground.addChild(cellNode)

                x += cellWidth
            }

            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
}
