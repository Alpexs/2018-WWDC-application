//: This is my application for the *WWDC 2018 scolarship*, I was thinking of something to let people express their creativity, and I tought about a game to do so. A game where you create your character and your enemies. I wanted it to be quite minimalist, that's why there is a single button to interact with. I wanted also to use UIKit alongside of SpriteKit just to see if it was possible... and it is ! So the concept is quite easy, you jump to avoid the obstacles you drew and try to do the best score !


//#-hidden-code

import PlaygroundSupport
import UIKit


let viewController = DrawViewController()
viewController.preferredContentSize = CGSize(width: 768, height: 1024)


//#-end-hidden-code

/*:
 Change the following proprieties to make the game looks good to you then run the playground.
 Try modifying:
 * `playerColorSelection` , `obstacleColorSelection`, this is the fill of the shape for each player and obstacles
 * `backgroundGameColorSelection` , for the background color
 * `strokeColorPlayer` , `strokeColorObstacle` , for the stroke of each entity
 */
/*:
 * Just replace the value of each property by one of the following strings :
 * `Black`, `Dark Gray`, `Light Gray`, `Gray`, `White`, `Red`, `Blue`, `Cyan`, `Yellow`, `Magenta`, `Orange`, `Purple`, `Brown`, `Green`
 */

//#-editable-code
var playerColorSelection : String = "Blue"
var strokeColorPlayer : String = "Red"
var obstacleColorSelection : String = "Black"
var strokeColorObstacle : String  = "Brown"
var backgroundGameColorSelection : String = "Green"
//#-end-editable-code












//#-hidden-code

playerColor = colorArray[playerColorSelection] ?? colorArray["Blue"]!
playerStroke = colorArray[strokeColorPlayer] ?? colorArray["Black"]!
obstacleColor = colorArray[obstacleColorSelection] ?? colorArray["Red"]!
obstacleStroke = colorArray[strokeColorObstacle] ?? colorArray["Black"]!
gameBGColor = colorArray[backgroundGameColorSelection] ?? colorArray["White"]!



PlaygroundPage.current.liveView = viewController.view


//#-end-hidden-code


