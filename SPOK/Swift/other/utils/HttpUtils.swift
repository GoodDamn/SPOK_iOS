//
//  HttpUtils.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

class HttpUtils {
    
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
    
        guard let data = try? JSONSerialization
            .data(
                withJSONObject: body,
                options: .fragmentsAllowed
            ) else {
            
            print(
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
        
        request(
            req,
            completion: completion
        )
    }
    
    public static func request(
        _ request: URLRequest,
        completion: @escaping ([String : Any]) -> Void
    ) {
        
        URLSession.shared.dataTask(
            with: request
        ) { data, error, response in
            
            print(
                "HttpUtils:request_RESPONSE",
                data,
                error
            )
            
            
            guard let data = data else {
                print(
                    "HttpUtils:request_ERROR:",
                    error
                )
                return
            }
            
            do {
                let json = try JSONSerialization
                    .jsonObject(
                        with: data,
                        options: .mutableLeaves
                    ) as! [String : Any]
                
                completion(json)
            } catch {
                print(
                    "HttpUtils:request_JSON_PARSE_ERROR:",
                     error
                )
            }
        }.resume()
        
    }
    
}
