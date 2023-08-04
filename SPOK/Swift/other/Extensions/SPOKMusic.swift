//
//  SPOKMusic.swift
//  SPOK
//
//  Created by Cell on 02.10.2022.
//

import UIKit;

class SPOKMusic{
    var trackName:String;
    var musicData:Data?;
    
    init(trackName:String, musicData:Data?) {
        self.trackName = trackName;
        self.musicData = musicData;
    }
}
