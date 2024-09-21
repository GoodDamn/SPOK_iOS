//
//  URLRequest.swift
//  SPOK
//
//  Created by GoodDamn on 20/09/2024.
//

import Foundation
extension URLRequest {
    
    func downloadData(
        completion: @escaping ((inout Data) -> Void)
    ) {
        URLSession.shared.dataTask(
            with: self
        ) { data, response, error in
            
            guard var data = data, error == nil else {
                return
            }
            
            completion(
                &data
            )
            
        }.resume()
    }
    
}
