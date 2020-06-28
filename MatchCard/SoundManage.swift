//
//  SoundManage.swift
//  MatchCard
//
//  Created by Nikunj Prajapati on 28/06/20.
//  Copyright © 2020 Nikunj Prajapati. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager
{
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffet
    {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffet)
    {
        var soundFileName = ""
        
        switch effect
        {
            
        case .flip:
            soundFileName = "cardflip"
            
        case .match:
            soundFileName = "dingcorrect"
        
        case .nomatch:
            soundFileName = "dingwrong"
            
        case .shuffle:
            soundFileName = "shuffle"
        }
        
        //get the path to the resources
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        //check that it is not nil
        guard bundlePath != nil else
        {
            //could not find the resources exit
            return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
             //create the audio player
             audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            //play the sound
            audioPlayer?.play()
            
        }
        catch{
            print("could not play audio player")
            return
        }
       
        
    }
}
