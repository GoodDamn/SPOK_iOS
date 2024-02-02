//
//  KeyUtils.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

class Keys {
    
    public static let AUTH = "".data(
        using: .utf8
    )!.base64EncodedString()
    
    public static let DEEP_LINK_SUB =
        "s://a"
    
    public static let URL_PAYMENTS = URL(
        string: "https://api.yookassa.ru/v3/payments"
    )!
        
    public static let ERROR_PATH = "Errors/iOS";
    
    public static let GIVEN_NAME = "name"
    public static let USER_REF = "userID";
    
    public static let NONCES = [
        "8305976241",
        "1870429536",
        "7523194086",
        "1726540389",
    ];
    
}
