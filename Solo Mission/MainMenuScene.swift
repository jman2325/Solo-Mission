import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "space background.jpg")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        let gameBy = SKLabelNode(fontNamed: "theBoldFont.ttf")
        gameBy.text = "Jacob Bailey's"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.white
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        let gameName1 = SKLabelNode(fontNamed: "theBoldFont.ttf")
        gameName1.text = "Solo"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "theBoldFont.ttf")
        gameName2.text = "Mission"
        gameName2.fontSize = 200
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        let startGame = SKLabelNode(fontNamed: "theBoldFont.ttf")
        startGame.text = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            if  nodeITapped.name == "startButton" {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        
        }
        
        
        
    }
    
    

}
