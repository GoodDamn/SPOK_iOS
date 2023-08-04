//
//  SPOKNtify.swift
//  SPOK
//
//  Created by Cell on 02.10.2022.
//
import UIKit;

class SPOKNotify{
    var title, largeText:String;
    var largeImage: Data?;
    var audio: Data?;
    
    init(title:String, largeText:String, largeImage: Data?, audio:Data?) {
        self.title = title;
        self.largeText = largeText;
        self.largeImage = largeImage;
        self.audio = audio;
    }
}
