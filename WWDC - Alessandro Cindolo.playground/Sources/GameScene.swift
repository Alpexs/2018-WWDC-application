import Foundation
import SpriteKit


public class GameScene : SKScene, SKPhysicsContactDelegate{
    
    var gameLabel = SKLabelNode()
    var playAgainNode = SKLabelNode()
    var obstacles = SKSpriteNode()
    var levelPassed = false
    var duration : TimeInterval = 1.7
    var delay: TimeInterval = 0.7
    public override init(size: CGSize) {

        super.init(size: size)
        timer = 0
        gameOver = false
        gameLabel.removeFromParent()
        gameLabel.position = CGPoint(x : self.frame.width / 2 , y : self.frame.height / 2)
        gameLabel.text = "Score : \(timer) "
        gameLabel.fontSize = 45
        playAgainNode.text = "Level 1"
        playAgainNode.fontSize = 20
        
        playAgainNode.position = CGPoint(x : self.frame.width / 2 , y : self.frame.height - playAgainNode.frame.height - 5)
        addChild(playAgainNode)
        
        self.view?.isUserInteractionEnabled = false
        addChild(gameLabel)
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        player.physicsBody?.isDynamic = true
        self.name = "border"
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx : 0.0, dy:  -4.5);
        addChild(player)
        obsSpawner(delay: delay)
        borderBody.categoryBitMask = CollisionCategoryWall
        borderBody.contactTestBitMask = 0
        addChild(obstacles)
    }
    
    public  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Methods to handle the spawn of the obstacle.
    
    func obsSpawner(delay: TimeInterval){
        removeAction(forKey: "spawnobs")
        
        self.delay = delay
        
        let delayAction = SKAction.wait(forDuration: delay)
        let spawnAction = SKAction.run {
            self.spawnobs()
        }
        
        let sequenceAction = SKAction.sequence([delayAction, spawnAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        run(repeatAction, withKey: "spawnobs")
    }
    
    func spawnobs(){
        
        //size
        var obsSize = CGSize(width: 40 , height: 40)
        
        let randomSize = arc4random() % 3
        
        switch randomSize {
        case 1:
            obsSize.width /= 1.1
            obsSize.height /= 1.1
        case 2:
            obsSize.width /= 1.4
            obsSize.height /= 1.4
        default:
            break
        }
        
        //position
        
        let randomX = CGFloat(arc4random() % UInt32(size.height-obsSize.width)) + 45.0
        
        //init
        
        let obs = SKSpriteNode(texture : obstacle.texture)
        obs.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size : obsSize)
        obs.name = "obs"
        obs.physicsBody?.isDynamic = false
        obs.physicsBody?.categoryBitMask = CollisionCategoryObs
        obs.physicsBody?.collisionBitMask = 0
        obs.physicsBody?.contactTestBitMask = 0
        obs.size = obsSize
        obs.physicsBody?.affectedByGravity = false
        obs.position = CGPoint(x: 0, y:  randomX)
        obstacles.addChild(obs)
        
        //move
        
        
        if timer > 300 && timer < 650 && !gameOver  {
            duration = 1.4
            playAgainNode.text = "Level 2"
        }
        else if timer > 700 && !levelPassed && !gameOver{
            duration = 1.2
            playAgainNode.text = "Level 3"
        }
    
        let moveDownAction = SKAction.moveBy(x: size.width-obs.size.height, y: 0, duration: duration)
        let destroyAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveDownAction, destroyAction])
        obs.run(sequenceAction)
        
        //rotation
        var rotateAction = SKAction.rotate(byAngle: 1, duration: 1)
        
        let randomRotation = arc4random() % 2
        
        if randomRotation == 1  {
            rotateAction = SKAction.rotate(byAngle: -1, duration: 1)
        }
        
        let repeatForeverAction = SKAction.repeatForever(rotateAction)
        obs.run(repeatForeverAction, withKey : "obstacleMovement")
    }

    // Next two methods are for the restart game part, if the player don't want to draw everything again he can play with the same shapes again and try to beat his score.
    
    public   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first

        if gameOver {
            
            if touch?.location(in: self.scene!) != nil {
            newGame()
            }
        }
    }
    

    func newGame() {
        scene!.removeAllChildren()
        obstacles.removeFromParent()
        player.position = CGPoint(x : self.view!.bounds.width / 2, y : self.view!.bounds.height / 2)
        let newScene = GameScene(size: self.scene!.size)
        let transition = SKTransition.fade( withDuration: 0.5)
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addTarget(DrawViewController(), action:#selector(DrawViewController.jumpTap), for: .touchDown)
        button.setTitle("Jump", for : .normal)
        
        view!.presentScene(newScene, transition: transition)
    }
    
    
    
    //    MARK: Physic handling
    
   public func didBegin(_ contact: SKPhysicsContact) {

        let nodeB = contact.bodyB.node!
        let nodeA = contact.bodyA.node!
    if nodeA.name == "border" {
            gameOver = true
        playAgainNode.text = "Game over, tap anywhere to play again or start over"
            player.physicsBody?.isDynamic = false
        }
        if nodeB.name == "obs"  {
            gameOver = true
            playAgainNode.text = "Game over, tap anywhere to play again or start over"
            nodeB.removeFromParent()
            player.physicsBody?.isDynamic = false
        }

    

    }
    
    
    
    // MARK: Calls from DrawViewController
    
    public func jump() {
        let mass = player.physicsBody?.mass ?? 50
        player.physicsBody?.applyImpulse(CGVector(dx :0.0, dy : 35.5))
        // make player run sequence
        if timer > 800 && !levelPassed && !gameOver{
            playAgainNode.text = "Level 4"
            delay = 0.2
            obsSpawner(delay: delay)
            levelPassed = true
        }
        
    }
    
    
    
    
    //MARK : Overrides
    
     public override func update(_ currentTime: TimeInterval) {
        if !gameOver {
        timer+=1
        gameLabel.text = "Score : \(timer)"
        }
        else {
            self.view?.isUserInteractionEnabled = true
            if bestScore <= timer {
                bestScore = timer
            }
            obstacles.removeFromParent()
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(DrawViewController(), action:#selector(DrawViewController.clearPressed), for: .touchDown)
            button.setTitle("Reset", for : .normal)
                NotificationCenter.default.post(name: Notification.Name("scoreUpdate"), object: nil)
        }
    }
    
    public override func didMove(to view : SKView) {
        
                self.backgroundColor = gameBGColor
        if gameBGColor == .white {
            gameLabel.fontColor = SKColor.black
            playAgainNode.fontColor = SKColor.black
            
        }
        else {
            gameLabel.fontColor = SKColor.white
            playAgainNode.fontColor = SKColor.white
        }

        }
}
    


