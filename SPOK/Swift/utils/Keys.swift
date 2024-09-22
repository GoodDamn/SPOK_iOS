//
//  KeyUtils.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

final class Keys {
    
    public static var AUTH = ""
    
    public static let DEEP_LINK_SUB =
        "s://a"
    
    public static let URL_PAYMENTS = URL(
        string: "https://api.yookassa.ru/v3/payments"
    )!
        
    public static let ERROR_PATH = "Errors/iOS"
    
    public static let GIVEN_NAME = "name"
    public static let USER_REF = "userID"
    
    public static let COMPLETE_INTRO = "intro"
    
    public static let ID_NEWS = "idNews"
    public static let OLD_BUILD_NUMBER = "oldbn"
    public static let USER_DEF_COMP = "comp"
    public static let USER_DEF_APPLE_CHECK = "pirate"
    public static let USER_DEF_APPLE_PREV_TIME = "pirateTime"
    
    static let ID_PAYMENT = "pid"
    
    public static let API_YOO = "yoo"
}
