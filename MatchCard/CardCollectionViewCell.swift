//
//  CardCollectionViewCell.swift
//  MatchCard
//
//  Created by Nikunj Prajapati on 27/06/20.
//  Copyright © 2020 Nikunj Prajapati. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    
    var card: Card?
    
    
    func configureCell(card: Card)
    {
        //keep track of the card this cell represents
        self.card = card
        
        //set the image to the image that represent the card
        frontImage.image = UIImage(named: card.imageName)
        
        //reset the state of cell by checking the flipped stutas of the card and then
        //showing the front or back image accordingly
        if card.isMatched == true
        {
            backImage.alpha = 0
            frontImage.alpha = 0
            return
        }
        else
        {
            backImage.alpha = 1
            frontImage.alpha = 1
        }
        
        if card.isFlipped == true
        {
            //shows the frontImage
            flipUP(speed: 0)
        }
        else
        {
            //shows the backImage
            flipDown(speed: 0, delay: 0)
        }
    }
    
    func flipUP(speed: TimeInterval = 0.3)
    {
        //fliUp animation
        UIView.transition(from: backImage, to: frontImage, duration:speed , options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        //set the stutas of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay:TimeInterval = 0.5)
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            //fliDown animation
            UIView.transition(from: self.frontImage, to: self.backImage, duration:speed , options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        //set the stutas of the card
        card?.isFlipped = false
    }
    
    func reMove()
    {
        //make the images are invisible
        backImage.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImage.alpha = 0
        }, completion: nil)
    }
    
    
    
}
