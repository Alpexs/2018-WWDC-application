import Foundation
import SpriteKit
import UIKit


// Dictionary with all the colors available.
public let colorArray : [String  : UIColor ] = ["Black" : .black, "Dark Gray" :  .darkGray, "Light Gray" : .lightGray, "White" : .white, "Gray" : .gray , "Red" : .red , "Blue" : .blue , "Cyan" : .cyan , "Yellow" : .yellow , "Magenta" : .magenta, "Orange" : .orange , "Purple" : .purple, "Brown" : .brown, "Green" : .green ]

//Colors that can be set by the player

public  var playerColor : UIColor = .blue
public var playerStroke :UIColor = .black
public var obstacleStroke : UIColor = .black
public var obstacleColor : UIColor = .red
public var gameBGColor : UIColor = .blue


// To use the reference also in the GameScene, and it's colors
public let button = UIButton()
public var buttonColor : UIColor =  UIColor(red:0.39, green:0.68, blue:0.10, alpha:1.0)
public var highlightColor : UIColor = UIColor(red:0.49, green:0.85, blue:0.12, alpha:1.0)


public var timer : Int = 0
public var bestScore : Int = 0

//Conditions variables
public var shapeDraw : Bool = false
public var charDraw : Bool = false
public var gameOver : Bool = false


public var obstacle = SKSpriteNode()
public var player = SKSpriteNode()

// For the drawing

public  var path = UIBezierPath()
public  var pathFill = UIBezierPath()
public var shape = SKShapeNode()


// For the physics collision
public let CollisionCategoryPlayer : UInt32 = 0x1 << 1
public let CollisionCategoryObs : UInt32 = 0x1 << 2
public let CollisionCategoryWall : UInt32 = 0x1 << 3



