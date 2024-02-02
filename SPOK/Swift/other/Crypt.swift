//
//  Crypt.swift
//  SPOK
//
//  Created by Cell on 25.11.2022.
//

import FirebaseDatabase;
import CryptoKit

public class Crypt {
    
    public static func generateSub(
        days: Int,
        premState:String = "1",
        freeTrialState: String = "2"
    ) {
        let dataBase = Database
            .database()
        
        let ref = dataBase
            .reference(
                withPath: "ctime"
            )
        
        ref.setValue(
            ServerValue.timestamp()
        )
        
        ref.observeSingleEvent(
            of: .value
        ) { snap,_  in
            
            guard let t = snap.value as? TimeInterval else {
                return
            }
            
            let indexNonce = Int.random(
                in: 0..<Keys.NONCES.count
            )
            
            // Concatenating
            let input  = "\(t/1000)\(premState)\(freeTrialState)"
            
            let nonce = Keys.NONCES[
                indexNonce
            ]
            
            var encrypted = Data()
            let arr = Array(input)
            
            for i in arr {
                
                let j = nonce.distance(
                    from: nonce.startIndex,
                    to: nonce.firstIndex(
                        of: i
                    )!
                )
                
                encrypted.append(
                    UInt8(j)
                )
            }
            
            let round = Int(days/32)
            
            
            encrypted.append(
                UInt8(round)
            )
            encrypted.append(
                UInt8(days-round)
            )
            encrypted.append(
                UInt8(indexNonce)
            )
            
            let id = UserDefaults
                .standard
                .string(
                    Keys.USER_REF
                )
            
            let path = "Users/\(id)/p"
            
            dataBase.reference(
                withPath: path
            ).setValue(
                String(
                    data: encrypted,
                    encoding: .ascii
                )
            )
        }
        
    }
    
    
    public static func encryptString(
        _ input:[UInt16]
    ) -> String {
        print("encryptString input",input)
        var data = Data(
            count: input.count * 2
        )
        
        for i in input {
            
            data.append(
                UInt8(i/127)
            )
            data.append(
                UInt8(i%127)
            )
        }
        
        print("encryptString", data);
        
        return String(
            data: data,
            encoding: .ascii
        ) ?? ""
    }
    
    public static func decryptString(
        _ input:String
    ) -> [UInt16] {
        
        print("decryptString:",input, input.count)
        
        let data = input.data(using: .ascii)!
        
        var decrypted:[UInt16] = []
        
        if data.count == 1 {
            return [UInt16(data[0])]
        }
        
        let size = data.count/2
        
        for ii in 0..<size {
            let i = ii*2
            decrypted.append(
                UInt16(data[i])*127 + UInt16(data[i+1]))
        }
        
        print("decryptString decrypted",decrypted);
        
        return decrypted;
        
    }
    
    public static func sha256(
        _ input:String
    ) -> String {
        return SHA256.hash(
            data: Data(input.utf8)
        ).compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
    
    public static func randomNonce(
        length: Int = 32
    ) -> String{
        
        precondition(length > 0)
        
        let charset : [Character] = Array(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"
        )
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                
                var random: UInt8 = 0;
                let errorCode = SecRandomCopyBytes(
                    kSecRandomDefault,
                    1,
                    &random
                )
                
                if errorCode != errSecSuccess{
                    fatalError("Unable to generate nonce");
                }
                
                return random;
            }
            
            randoms.forEach{ random in
                
                if remainingLength == 0{
                    return;
                }
                
                if random < charset.count{
                    result.append(charset[Int(random)]);
                    remainingLength -= 1;
                }
            }
        }
        
        return result;
    }
    
}
