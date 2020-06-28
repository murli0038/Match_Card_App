//
//  CardModel.swift
//  MatchCard
//
//  Created by Nikunj Prajapati on 27/06/20.
//  Copyright © 2020 Nikunj Prajapati. All rights reserved.
//

import Foundation

class CardModel
{
    func getCards() -> [Card]
    {
        //declare an empty array to store numbers that we have generated
        var generatedNumbers = [Int]()
        
        //declarating en empty array
        var generatedCards = [Card]()
        
        //Randomly generate 8 pairs of cards
        while generatedNumbers.count < 8
        {
            //generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false
            {
                
                //create two new card objects
                let cardOne = Card()
                let cardTwo = Card()
                
                //set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                //add them to the array
                generatedCards += [cardOne, cardTwo]
                
                //add this numbers to the list of generated numbers
                generatedNumbers.append(randomNumber)
                print(randomNumber)
            }
            
        }
        
        //randomize the cards within the array
        generatedCards.shuffle()
        
        
        
        //return the array
        return generatedCards
    }
}
