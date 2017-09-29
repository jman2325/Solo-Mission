import Foundation
import SpriteKit

class GameOverScene: SKScene{

    let restartLabel = SKLabelNode(fontNamed: "theBoldFont.ttf")
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "space background")
        background.size =  self.size
        background.position = CGPoint(x:self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "theBoldFont.ttf")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        
        let scoreLabel = SKLabelNode(fontNamed: "theBoldFont.ttf")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        
        let defaults = UserDefaults()
        var highScoreNum = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNum{
            
            highScoreNum = gameScore
            defaults.set(highScoreNum, forKey: "highScoreSaved")
            
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "theBoldFont.ttf")
        highScoreLabel.text = "High Score: \(highScoreNum)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
        
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
            
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                
            }
            
            
            
        }
    }
    
    
    
    
    
    
}
