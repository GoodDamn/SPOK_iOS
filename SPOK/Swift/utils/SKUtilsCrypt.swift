//
//  SKUtilsCrypt.swift
//  SPOK
//
//  Created by GoodDamn on 19/09/2024.
//

import Foundation
import CryptoKit

final class SKUtilsCrypt {
    
    private static let mCharset =
        "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"
    
    static func sha256(
        _ input:String
    ) -> String {
        SHA256.hash(
            data: Data(
                input.utf8
            )
        ).compactMap {
            String(
                format: "%02x",
                $0
            )
        }.joined()
    }
    
    public static func randomNonce(
        length: Int = 32
    ) -> String{
        let charset: [Character] = Array(
            SKUtilsCrypt.mCharset
        )
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (
                0 ..< 16
            ).map { _ in
                var random: UInt8 = 0;
                let errorCode = SecRandomCopyBytes(
                    kSecRandomDefault,
                    1,
                    &random
                )
                
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce");
                }
                
                return random;
            }
            
            randoms.forEach { random in
                
                if remainingLength == 0 {
                    return;
                }
                
                if random < charset.count {
                    result.append(
                        charset[
                            Int(
                                random
                            )
                        ]
                    )
                    remainingLength -= 1
                }
            }
        }
        
        return result;
    }
}
