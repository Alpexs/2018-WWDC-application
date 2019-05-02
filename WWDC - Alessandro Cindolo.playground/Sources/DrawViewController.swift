import UIKit
import SpriteKit
public var pressed : Bool = false
public var tooLittle : Bool = true



public class DrawViewController : UIViewController {
    public  var imgTransformed = UIImageView()
    public  var startPoint = CGPoint()
    public  var touchPoint = CGPoint()
    public  var ending = CGPoint()
    public  let canvasView = SKView()
    public var label = UILabel()
    public override func loadView() {
        let view = UIView()
        player.name = "cleared"
        view.frame = CGRect( x : 0 , y: 0 , width : 768, height : 1024)
        button.frame = CGRect(x: view.frame.midX - 150 , y: 100, width: 300, height: 50)
        button.setTitle("Next", for :.normal)
        button.addTarget(self, action:#selector(buttonTap), for: .touchDown)
        button.backgroundColor = buttonColor
        label.frame = CGRect(x : view.frame.midX - 150, y :  button.frame.origin.y - button.frame.height - 25 , width : 300, height : 80 )
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28.0)
        label.text = "Draw character !"
        bestScore = 0
        NotificationCenter.default.addObserver(self, selector: #selector(scoreUpdate(notification:)), name: Notification.Name("scoreUpdate"), object: nil)
        
        canvasView.frame = CGRect(x: view.frame.midX - 250 , y: view.frame.midY - 300, width: 500, height: 500)
        canvasView.clipsToBounds = true
        canvasView.isMultipleTouchEnabled = false
        canvasView.backgroundColor = gameBGColor
        let drawScene = DrawScene(size : canvasView.bounds.size)
        drawScene.name = "DrawScene"
        drawScene.backgroundColor = gameBGColor
        view.addSubview(button)
        canvasView.presentScene(drawScene)
        view.addSubview(label)
        view.addSubview(canvasView)
        self.view = view
        self.view.backgroundColor = .gray
    }
    
    public   override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Here we draw first the character then once you press the button we present again the drawscene to let the player draw the obstacle, with all the little conditions to be sure that the drawing phase went good.. once everything is ok we present the game scene.
    
    @objc public func buttonTap() {
        
        let drawScene = DrawScene(size : canvasView.bounds.size)
        let transition = SKTransition.fade(withDuration : 0.7)
        
        //check for invalid or not drawn shape
        if player.name == "cleared"  {
            canvasView.presentScene(drawScene)
            charDraw = false
            drawScene.showAlert()
        }
        else {
            label.text = "Draw obstacle !"
            button.setTitle("Play!", for :.normal)
            canvasView.presentScene(drawScene)
            pressed = true
            
            if !shapeDraw && charDraw {
                canvasView.presentScene(drawScene)
                drawScene.showAlert()
            }
            charDraw = true
        }
        
        
        if shapeDraw && charDraw {
            
            label.text = "Best score : \(bestScore) !"
            let gameScene = GameScene(size : canvasView.bounds.size)
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(self, action:#selector(jumpTap), for: .touchDown)
            button.setTitle("Jump", for : .normal)
            canvasView.presentScene(gameScene, transition: transition)
            
        }
        
    }
    
    // We call the jump method to add impulse to the player during the game

    
    @objc public func jumpTap(_ sender : UIButton) {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = highlightColor.cgColor
        colorAnimation.duration = 0.8
        sender.layer.add(colorAnimation, forKey: "PulseColor")
        if let game = canvasView.scene as? GameScene {
            game.jump()
            
        }
    }
    
    
    // Since it is an UILabel I had to use an observer to update the label at the end of the game.
    
    @objc public func scoreUpdate(notification: Notification) {
        label.text = "Best score : \(bestScore) !"
    }
    
    // Here we try to delete everything in case we press "Reset" at the end of the game and we get back to the draw scene
    
    @objc public func clearPressed(_ sender: UIButton) {
        
        path.removeAllPoints()
        pathFill.removeAllPoints()
        player.removeFromParent()
        obstacle.removeFromParent()
        if player.physicsBody != nil {
            player.physicsBody = nil
        }
        if obstacle.physicsBody != nil {
            obstacle.physicsBody = nil
        }
        let drawScene = DrawScene(size : canvasView.bounds.size)
        drawScene.name = "DrawScene"
        canvasView.layer.sublayers = nil
        canvasView.setNeedsDisplay()
        canvasView.presentScene(drawScene)
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addTarget(self, action:#selector(buttonTap), for: .touchDown)
        button.setTitle("Shape!", for :.normal)
        label.text = "Draw character !"
        pressed = false
        tooLittle = false
        shapeDraw = false
        charDraw = false
        gameOver = false
        player.name = "cleared"
    }
    
    
}
