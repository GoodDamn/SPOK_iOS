//
//  SPOKTopic.swift
//  SPOK
//
//  Created by Cell on 30.09.2022.
//

import UIKit;
class SPOKTopic{
    
    var name,desc:String;
    var color:UIColor;
    var idCategory:UInt8;
    
    init(color:UIColor, name:String, desc:String, idCategory:UInt8) {
        self.color = color;
        self.name = name;
        self.desc = desc;
        self.idCategory = idCategory;
    }
}
