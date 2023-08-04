//
//  Crypt.swift
//  SPOK
//
//  Created by Cell on 25.11.2022.
//

import FirebaseDatabase;

class Crypt{
    
    static func generateSub(days: Int, premState:String = "1", freeTrialState: String = "2"){
        let dataBase = Database.database();
        let ref = dataBase.reference(withPath: "ctime");
        ref.setValue(ServerValue.timestamp());
        ref.observeSingleEvent(of: .value, with: {
            snap in
            if let t = snap.value as? TimeInterval{
                print(self, "buying sub...", snap.value, t, Date(timeIntervalSince1970: t/1000));
                let indexNonce = Int.random(in: 0..<Utils.nonces.count);
                // Concatenating
                let input:String = Int(t/1000).description + premState + freeTrialState;
                
                let nonce:String = Utils.nonces[indexNonce];
                var encrypted:[UInt8] = [];
                let arr = Array(input);
                print("sub", arr, nonce, input)
                
                for i in arr {
                    encrypted.append(UInt8(nonce.distance(from: nonce.startIndex, to: nonce.firstIndex(of: i)!)));
                }
                let round = Int(days/32);
                print("Crypt: ", days/32, round);
                encrypted.append(UInt8(round));
                encrypted.append(UInt8(days-round));
                encrypted.append(UInt8(indexNonce));
                
                dataBase.reference(withPath: "Users/"+(UserDefaults().string(forKey: Utils.userRef) ?? "a")+"/p").setValue(String(data: Data(encrypted), encoding: .ascii));
                
                print("sub",encrypted);
            }
        });
    }
    
    
    static func encryptString(_ input:[UInt16])->String{
        print("encryptString input",input)
        var data:[UInt8] = [];
        for i in input {
            data.append(UInt8(i/127))
            data.append(UInt8(i%127))
        }
        
        print("encryptString", data);
        
        return String(data: Data(data), encoding: .ascii)!;
    }
    
    static func decryptString(_ input:String)->[UInt16]{
        print("decryptString:",input, input.count);
        let data = ([UInt8])(input.data(using: .ascii)!);
        var decrypted:[UInt16] = [];
        
        if data.count == 1 {
            return [UInt16(data[0])];
        }
        
        let size = data.count/2;
        
        for ii in 0..<size {
            let i = ii*2
            decrypted.append(UInt16(data[i])*127+UInt16(data[i+1]))
        }
        
        print("decryptString decrypted",decrypted);
        
        return decrypted;
        
    }
}
