import Foundation
import SpriteKit


    // This is is the Draw Scene, where the drawing happens. We draw on the canvasView using the touches methods ( touchesBegan, Moved, Ended..) then our drawings ( that are UIBezierPath ) are converted into SKSpriteNode because it's easier to use it as that on a SKScene mainly because UIKit and SpriteKit have different coordinate system


public class DrawScene: SKScene {
    public var mainLabel = SKLabelNode()
    public var startPoint = CGPoint()
    public var touchPoint = CGPoint()
    public var ending = CGPoint()
    var ended = false
    

    public override init(size: CGSize) {
        
        super.init(size: size)
        self.backgroundColor = gameBGColor
        pathFill.lineJoinStyle = .bevel
        self.removeAllChildren()
        mainLabel.removeFromParent()
        mainLabel.position = CGPoint(x : self.frame.width / 2 , y : self.frame.height - mainLabel.frame.height - 40)
        mainLabel.text = "Draw a shape"
        
        // Just so we can see something with a too dark background
        
        if gameBGColor == .white{
        mainLabel.fontColor = SKColor.black
        }
        else {
            mainLabel.fontColor = SKColor.black

        }
        mainLabel.fontSize = 25
        addChild(mainLabel)
        
    }
    
    public  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if ended {
            shape.removeAllChildren()
            self.removeAllChildren()
        }
        if let point = touch?.location(in: self.scene!) {
            startPoint = point
            path.removeAllPoints()
            path.move(to : point)
            pathFill.move(to : point)
            
        }
        draw()
        
    }
    
    
    public   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self.scene!) {
            touchPoint = point
            path.move(to: startPoint)
            pathFill.addLine(to: touchPoint)
            path.addLine(to: touchPoint)
            startPoint = touchPoint
            
        }
        draw()
        
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self.scene!)
        {
            ending = point
            pathFill.close()
            
            pathFill.move(to : ending)
            moveShape()
            ended = true
            pathFill.removeAllPoints()
        }
        draw()
    }
    
    public func draw() {
        let strokeLayer = SKShapeNode()
        strokeLayer.lineWidth = 5
        if !charDraw {

        strokeLayer.strokeColor = playerStroke
        }
        else {
        strokeLayer.strokeColor = obstacleStroke
        }
        strokeLayer.path = path.cgPath
        
        addChild(strokeLayer)
        path.removeAllPoints()
        self.view?.setNeedsDisplay()
    }
    
    
    
    public func moveShape(){
       
        self.removeAllChildren()
        shape.removeAllChildren()
        obstacle.removeFromParent()
        player.removeFromParent()
        shape.removeFromParent()
    
        // I have to write 2 times the code to define the colors for each element
    
        if !charDraw {
            
          
            shape.path = pathFill.cgPath
            shape.fillColor = playerColor
            shape.lineWidth = 6
            shape.strokeColor = playerStroke
           
            
            // We transform our SKShapeNode into a rendered image so we can assign it to our SKSpriteNode
            
            let texture = self.view?.texture(from : shape, crop:shape.calculateAccumulatedFrame())
            if texture == nil {
                showAlert()
                tooLittle = true
            }
            else{
                let spriteNode = SKSpriteNode(texture:texture)
                player = spriteNode
                player.name = "player"
                player.position = CGPoint(x : self.view!.bounds.width / 2, y : self.view!.bounds.height / 2)
                addPhysics(node : player ,tex : texture!)
                addChild(player)
            }
        }
        else if charDraw && pressed {
            shape.path = pathFill.cgPath
            shape.fillColor = obstacleColor
            shape.strokeColor = obstacleStroke
            shape.lineWidth = 6
            let texture = self.view?.texture(from : shape, crop:shape.calculateAccumulatedFrame())
            if texture == nil {
                showAlert()
                tooLittle = true
            }
            else {
            let spriteNode = SKSpriteNode(texture:texture)
            obstacle = spriteNode
            obstacle.name = "obstacle"
            obstacle.position = CGPoint(x : self.view!.bounds.width / 2, y : self.view!.bounds.height / 2)
            addChild(obstacle)
            addPhysics(node : obstacle, tex : texture!)
            shapeDraw = true
            }
        }
        
    }
    
    
    
    // Here we add the physics to the nodes we created earlier, we wait for the completion of the resize otherwise we'd apply the physics to the original size of the node.
    
    func addPhysics(node : SKSpriteNode ,tex : SKTexture ) {
    
         node.physicsBody = nil
   let resize = SKAction.resize(toWidth : 60, height : 60 , duration : 0.2)
        node.run(resize, completion: {
            
            if node.name == "player" {
           
            node.physicsBody = SKPhysicsBody(texture: tex, size : player.size)
            if  node.physicsBody != nil {
                node.physicsBody?.linearDamping = 1.0
                node.physicsBody?.allowsRotation = true
                node.physicsBody?.isDynamic = false
                node.physicsBody?.categoryBitMask = CollisionCategoryPlayer
                node.physicsBody?.collisionBitMask = 0
                node.physicsBody?.contactTestBitMask = CollisionCategoryObs | CollisionCategoryWall
                tooLittle = false
                
            }
            else {
                 self.showAlert()
                
                }
            }
                //PHYSICS FOR OBSTACLE, we could do just else, but in case we can add other elements
            else if node.name == "obstacle" {
                node.physicsBody = SKPhysicsBody(texture: tex, size : obstacle.size)
                if  node.physicsBody != nil {
                    node.physicsBody?.linearDamping = 1.0
                    node.physicsBody?.allowsRotation = true
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.categoryBitMask = CollisionCategoryObs
                    node.physicsBody?.collisionBitMask = 0
                    node.physicsBody?.contactTestBitMask = CollisionCategoryPlayer
                    tooLittle = false
                }
                else {
                    self.showAlert()
                   
                }

            }
        })
    }
    
    
    // In case we draw a shape that fails to get associated with the physics, or we press the button without drawing anything  we'll have an alert
    
    func showAlert() {
        let tSeq = SKAction.sequence([
            
            SKAction.fadeIn(withDuration : 1),
            SKAction.wait(forDuration : 2),
            SKAction.fadeOut(withDuration : 1),
            
            SKAction.wait(forDuration : 2)
            
            ])
        let label = SKLabelNode()
        if gameBGColor == .black {
            label.fontColor = SKColor.white
            
        }
        else {
             label.fontColor = SKColor.black
        }
        label.position = CGPoint(x: self.view!.frame.width/2 , y: self.view!.frame.height/2)
        label.text = "Please draw something"
        label.alpha = 0.0
        label.fontSize = 25.0
        addChild(label)
        label.run(tSeq)
    
    }
    
    public override func didMove(to view : SKView)
    {
        player.physicsBody?.isDynamic = true

    }
    
}

