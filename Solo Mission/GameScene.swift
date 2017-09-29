//
//  GameScene.swift
//  Solo Mission
//
//  Created by Jacob on 12/18/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

import SpriteKit
import GameplayKit
var gameScore = 0
class GameScene: SKScene, SKPhysicsContactDelegate {

    
    
    let scoreLabel = SKLabelNode(fontNamed: "theBoldFont.ttf")
    
    var livesNum = 3
    let livesLabel = SKLabelNode(fontNamed: "theBoldFont.ttf")
    
    var levelNum = 0
    
    
    let player = SKSpriteNode(imageNamed: "spaceship sprite.png")
    let bulletSound = SKAction.playSoundFileNamed("4.wav", waitForCompletion: false)
    let explositionSound = SKAction.playSoundFileNamed("Explosion+1.mp3", waitForCompletion: false)
    
    
    let tapToStartLabel = SKLabelNode(fontNamed: "theBoldFont.ttf")
    
    
    enum gameState {
        case preGame // when the game state is before the start of the game
        case inGame // during the game
        case afterGame // after the game
    }
    
    var currentGameState = gameState.preGame
    
    
    
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
        
    }
    
    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
    
        return random() * (max - min) + min
    
    }
    
    
    
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        // the background
        
        
        for i in 0...1{
            
        let background = SKSpriteNode(imageNamed: "space background.jpg")
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
        background.zPosition = 0
        background.name = "Background"
        self.addChild(background)
        }
        
        
        
        // user player
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        
        
    }
    
    
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    let amountToMovePerSec: CGFloat = 600.0 // could be var to speed up the background
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSec * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if self.currentGameState == gameState.inGame{
            background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
        
    }
    
    
    
    
    
    
    func startGame(){
        
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        
        let moveShipOnScreen = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOnScreen, startLevelAction])
        player.run(startGameSequence)
        
    
    }
    
    
    
    
    
    
    func loseALife(){
    
        livesNum -= 1
        livesLabel.text = "Lives: \(livesNum)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNum == 0{
            
            runGameOver()
        
        }
    
    }
    
    
    
    
    func addScore() {
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50{
            startNewLevel()
        }
        
        
        
        
    }
    
    
    func runGameOver(){
        
        
        currentGameState = gameState.afterGame
    
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            
            bullet.removeAllActions()
        
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
        
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        
        let changeSceneAction = SKAction.run(changeScene)
        let watToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([watToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
    
    }
    
    func changeScene(){
    
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // if player hits enemy
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            
    
            if body1.node != nil{
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
            runGameOver()
            
            
        }
        
        // if the bullet hit the enemy
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height{
            
            
            addScore()
            
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
    }
    
    func spawnExplosion(spawnPosition:CGPoint){
        
        let explosition = SKSpriteNode(imageNamed: "Explosition")
        explosition.position = spawnPosition
        explosition.zPosition = 3
        explosition.setScale(0)
        self.addChild(explosition)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explositionSequence = SKAction.sequence([explositionSound,scaleIn, fadeOut, delete])
        
        explosition.run(explositionSequence)
    
    
    }
    
    
    
    // starts a new level
    func startNewLevel(){
    
        levelNum += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
                self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNum {
        case 1:
            levelDuration = 1.2
        case 2:
            levelDuration = 1
        case 3:
            levelDuration = 0.8
        case 4:
            levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    
    
    }
    
    
    
    
    
    func fireBullet() {
    
    
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
        
        
    }
    
    
    
    func spawnEnemy() {
    
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let EndPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "topdownfighter")
        enemy.name = "Enemy"
        enemy.setScale(0.2)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: EndPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        
        if currentGameState == gameState.inGame{
        enemy.run(enemySequence)
        }
        
        let dx = EndPoint.x - startPoint.x
        let dy = EndPoint.y - startPoint.y
        let amounToRotate = atan2(dy, dx)
        enemy.zRotation = amounToRotate
    
    
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if currentGameState == gameState.preGame{
        
            startGame()
        
        } else if currentGameState == gameState.inGame{
        fireBullet()
        }
        
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            
            if currentGameState == gameState.inGame{
            player.position.x += amountDragged
            }
            
            
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            
            if player.position.x < gameArea.minX + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
        
    }
    
    
    
    
    
}
















