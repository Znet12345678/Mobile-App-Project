//
//  GameScene.swift
//  UNO
//
//  Created by Wall, Nicholas E on 4/5/18.
//  Copyright © 2018 Wall, Nicholas E. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //Filtered cards to be used with GameRules and Players
    var playableCards: [Card] = []
    
    
    //whos turn 1:player 2:cpu
    var currentTurn:Int = 1
    //is game running
    var gameStarted:Bool = false
    //determine who won
    var playerWin:Bool = false
    var computerWin:Bool = false
    //player's cards
    var playerDeck:[Card] = []
    //computer's cards
    var computerDeck:[Card] = []
    //creates a LIFO structure
    struct Stack {
        //make the array properties part of stack, use.array for array functionality
        fileprivate var array: [Card] = []
        var count : Int = 0
        //addcards to the last position of the array
        mutating func push(_ element:Card)
        {
            array.append(element)
            count+=1
        }
        //take the last card from the array removing it and returning it
        mutating func pop() -> Card?
        {
            count-=1
            return array.popLast()
        }
        //returns the last card in the array
        func peek() -> Card? {
            return array.last
        }
    }
    //players play their card and place here
    var pool : [Card] = []
    //players draw cards from
    var drawPile : [Card] = []
    

    func shuffle( deck: [Card])-> [Card]{
        var i = deck.count-1
        var d = deck
        while(i >= 1){

            let r = Int(arc4random()) % (i)
            let sv : Card = d[i]
            d[i] = d[r]
            d[r] = sv

            i-=1
        }
        return d
    }
    var iDeck : [Card] = []
    var iDecks  = Stack()
    //takes all cards and assigns a location for them
    func fillDecks()
    {
        //drawPile.push(CARD) adds the card to the stack
        //CARD.position gives a location for the touchesMoved method to use for testing the drawing and rearranging of cards logic
        //addChild(CARD) activates the node to be used by the game handler
        NSLog("Filling deck")
        //NOTE @CARDS(BLUE & YELLOW STILL NEED TEMPORARY POSITIONS)
        var i = 0
        while(i < 11){
            iDeck.append(Card(clr:.red,typ:.normal,num:i))
            iDeck.append(Card(clr:.yellow,typ:.normal,num:i))
            iDeck.append(Card(clr:.blue,typ:.normal,num:i))
            iDeck.append(Card(clr:.green,typ:.normal,num:i))
            i+=1
        }
       iDeck = shuffle(deck : iDeck)
        var x = -Int(self.frame.width)/2+80,y = Int(self.frame.height)/2-80
        for var c : Card in iDeck{
            c.position = CGPoint(x:0,y:0)
            addChild(c)
        }

        for var c : Card in iDeck{
            iDecks.push(c)
        }
        i = 0
        while(i < 7){
            playerDeck.append(iDecks.pop()!)
            playerDeck[playerDeck.count-1].position = CGPoint(x:x,y:-Int(self.frame.height)/2+80)
            computerDeck.append(iDecks.pop()!)
            computerDeck[computerDeck.count-1].isHidden = true
            x+=80
            i+=1
        }
        while(iDecks.count > 0){
            drawPile.append(iDecks.pop()!)
        }
       
    
        //divide into intial groups of cards
        i = 1
        while i <= 10 {
            playerDraw()
            computerDraw()
            i += 1
        }
    }
    //player takes a card from the draw pile
    func playerDraw()
    {
        playerDeck.append(drawPile[drawPile.count-1])
        drawPile.remove(at: drawPile.count-1)
    }
    //computer takes a card from the draw pile
    func computerDraw()
    {
        computerDeck.append(drawPile[drawPile.count-1])
        drawPile.remove(at: drawPile.count-1)
    }
    //checks to see if either the player or cpu has meet the parameters to win
    func checkDeckSize()
    {
        if playerDeck.count == 0
        {
            playerWin = true
        }
        else if computerDeck.count == 0
        {
            computerWin = true
        }
    }
   
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameStarted == false
        {
            
            fillDecks()
            gameStarted = true
        }
        //label?.text = "\(playerDeck.count)"
        checkDeckSize()
        //if 1 then it is the player's turn
        if currentTurn == 1
        {
            //logic for player placing a card and then changing the turn counter to 1
        }
        else
        {
            //logic for the computer placing a card and then changing the turn counter to 2
        }
    }
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        //self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        //if let label = self.label {
         //   label.alpha = 0.0
          //  label.run(SKAction.fadeIn(withDuration: 2.0))
            //label.text = "\(playerDeck.count)"
            
            
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //self.touchMoved(toPoint: t.location(in: self))
            
            //Code to allow cards to be moved and rearranged by the player
            let location = t.location(in: self)
            if let card = atPoint(location) as? Card {
                card.position = location
            }
        
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    } 
}
