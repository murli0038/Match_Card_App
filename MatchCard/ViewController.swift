//
//  ViewController.swift
//  MatchCard
//
//  Created by Nikunj Prajapati on 27/06/20.
//  Copyright © 2020 Nikunj Prajapati. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var miliSeconds:Int = 10 * 1000
    
    var firstFlippedCardIndex: IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getCards()
        
        //initialize timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    //MARK: - timer Functions
    
    @objc func timerFired()
    {
        //decrement the counter
        miliSeconds -= 1
        
        //update the label
        let seconds:Double = Double(miliSeconds)/1000.0
        timerLabel.text = String(format: "Time Left : %.2f", seconds)
        
        //stop the timer if it reaches zero
        if miliSeconds == 0
        {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
        }
        
        //TODO: check if the user has cleared all pairs
        checkForGameEnd()
    }
    
    
    //MARK: - collection view code
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Configure the state of the cell based on the property of the card that it represent
        //get the card from cardArray
        let cardCell = cell as? CardCollectionViewCell
        
        let card = cardsArray[indexPath.row]
        
        //finish confugure cell
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //check if there is any time is left
        if miliSeconds <= 0
        {
            return
        }
        //get the refernce to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        //check the stutas of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false
        {
            //flip the card up
            cell?.flipUP()
            
            //play flip sound
            soundPlayer.playSound(effect: .flip)
            
            //check if it is forst card or second card
            if firstFlippedCardIndex == nil
            {
                //this is the first card flipped over
                firstFlippedCardIndex = indexPath
            }
            else
            {
                //second card is flipped
                
                
                //Run the comparison the logic
                checkForMatch(indexPath)
            }
        }
//        user mannually flipdown which is not required
//        else
//        {
//            //flip the card down
//            cell?.flipDown()
//        }
        
        
    }
    
    //MARK: - Game Logic Functions
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath)
    {
        //get the collection view cell thet represents card one and two
        let cardOnecell = collectionView.cellForItem(at: firstFlippedCardIndex!) as! CardCollectionViewCell
        let cardTwocell = collectionView.cellForItem(at: secondFlippedCardIndex) as! CardCollectionViewCell
        
        
        //get the two card objs for to two indecates and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        //comapare  the two cards
        if cardOne.imageName == cardTwo.imageName
        {
            //its a match
            
            //play match sound
            soundPlayer.playSound(effect: .match)
            
            //set the stutas and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOnecell.reMove()
            cardTwocell.reMove()
            
            //was that the last pair??
            checkForGameEnd()
            
        }
        else
        {
            //its not match
            
            //play sound
            soundPlayer.playSound(effect: .nomatch)
            
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            
            //flip them back over
            cardOnecell.flipDown()
            cardTwocell.flipDown()
        }
        
        //reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd()
    {
        //check if there is any card that is umatched
        //Assume the user has won, loop through all the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardsArray
        {
            if card.isMatched == false
            {
                //we have found a card that is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon == true
        {
            //user has won,show an alert
            showAlert(title: "Congrets", message: "You win thw Game !!")
        }
        else
        {
            //user has not won, check if there is any time left
            if miliSeconds <= 0
            {
                showAlert(title: "Time is Up", message: "Try it once agian")
            }
        }
        
    }

    func showAlert(title:String, message:String)
    {
        //alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //ok button
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        //present alert
        present(alert, animated: true, completion: nil)
    }
    
    
}

