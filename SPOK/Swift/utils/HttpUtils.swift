//
//  HttpUtils.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

final class HttpUtils {
    
    public static func header(
    ) -> [String : String] {
        let uuid = UUID()
            .uuidString
        
        Log.d("HttpUtils:","header",uuid, Keys.AUTH)
        
        return [
            "Authorization" : "Basic \(Keys.AUTH)",
            "Idempotence-Key" : uuid,
            "Content-Type": "application/json"
        ]
    }
    
    public static func requestJson(
        to url: URL,
        header: [String : String]? = nil,
        body: [String : Any]? = nil,
        method: String,
        completion: @escaping ([String : Any]) -> Void
    ) {
    
        guard let data = try? JSONSerialization.data(
            withJSONObject: body,
            options: .fragmentsAllowed
        ) else {
            Log.d(
                "HttpUtils: requestJson:ERROR_CONVERT"
            )
            return
        }
        
        request(
            to: url,
            header: header,
            body: data,
            method: method,
            completion: completion
        )
    }
    
    public static func request(
        to url: URL,
        header: [String : String]? = nil,
        body: Data? = nil,
        method: String,
        completion: @escaping ([String : Any]) -> Void
    ) {
        var req = URLRequest(
            url: url
        )
        
        req.httpMethod = method
        req.allHTTPHeaderFields = header
        req.httpBody = body
        
        req.downloadData { data in
            
            guard let json = data.json() else {
                return
            }
            
            completion(
                json
            )
            
        }
    }
    
}
