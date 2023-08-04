//
//  SubscriptionViewController.swift
//  SPOK
//
//  Created by Cell on 01.03.2022.
//

import UIKit;
import RevenueCat;
import FirebaseDatabase;

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var b_close: UIButton!;
    @IBOutlet weak var tv_privacy: UITextView!;
    @IBOutlet weak var b_buy: UIButton!;
    @IBOutlet weak var iv: UIImageView!;
    @IBOutlet weak var l_price:UILabel!;
    @IBOutlet weak var tv_pay: UITextView!;
    
    private let TAG = "SubscriptionViewController:";
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func buySub(_ sender: UIButton) {
        
        /*
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            Toast.init(text: "APP STORE RECEIPT ERROR:\nThis shit doesn't exist", duration: 1.2).show();
            return;
        }
        
        do {
            
            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped);
            
            print("RECEIPT:",receiptData);
            
            Toast.init(text: "GETTING RECEIPT:", duration: 1.2).show();
            
            let receiptString = receiptData.base64EncodedString(options: []);
            
            Toast.init(text: "RECEIPT:\n" + receiptString, duration: 1.2).show();
            
            
            let HTTPS_URL_POST = "https://sandbox.itunes.apple.com/verifyReceipt";
            
            let requestData : [String : Any] = ["receipt-data" : receiptString,
                                                "password" : "5d74311253c044c3b554cd3a24a74bae",
                                                "exclude-old_transactions" : false];
            
            let httpBody = try? JSONSerialization.data(withJSONObject: requestData,
                                                        options: []);
            var request = URLRequest(url: URL(string: HTTPS_URL_POST)!);
            request.httpMethod = "POST";
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type");
            request.httpBody = httpBody;
            
            Toast.init(text: "SENDING REQUET TO THE SERVER:", duration: 1.2).show();
            
            print("SEND REQUEST TO SERVER:", HTTPS_URL_POST);
            URLSession.shared.dataTask(with: request) {
                (data, response, Error) in
                
                print("RESPONSE:",data?.count,response, Error);
                
                DispatchQueue.main.async {
                    Toast.init(text: "I GOT THIS SHIT", duration: 1.2).show();
                    
                    print("DATA JSON:", data);
                    
                    guard let data = data else {
                        Toast.init(text: "THIS SHIT IS NIL\nIN THIS RESPONSE", duration: 1.2).show();
                        return;
                    }
                    
                    
                    let label = UILabel(frame: self.view.bounds);
                    label.text = String(data: data, encoding: .utf8);
                    label.numberOfLines = 90;
                    label.textColor = UIColor.black;
                    label.font = UIFont.systemFont(ofSize: 18);
                    label.backgroundColor = UIColor.white;
                    label.textAlignment = .center;
                    
                    self.view.addSubview(label);
                    
                    if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        
                        print(jsonData);
                    }
                }
                
            }.resume();
            
            print("RECEIPT STRING:", receiptData);
            
        } catch {
            print("COULDN'T READ RECEIPT DATA WITH ERROR: ", error.localizedDescription);
        }
            
        
        if (payment == nil) {
            Toast.init(text: Constants.getLocalizedString("error"), duration: 1.2).show();
            return;
        }
        paymentQ.add(payment!);*/
    }
    
    enum Subs: String, CaseIterable {
        case sub1month = "spoklab.spok.subbs"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        

        Purchases.shared.getOfferings {
            offering, error in
            
            guard let offers = offering?.current else {
                print(self.TAG, "ERROR WHILE GETTING OFFERING FROM RC:", error?.localizedDescription);
                return;
            }

            let packages = offers.availablePackages;
            
            for pack in packages {
                print(self.TAG, "PACKAGE:", pack.id, pack.localizedPriceString);
                let product = pack.storeProduct;
                
                print(self.TAG, "PRODUCT:", product.productIdentifier,
                      product.localizedTitle,
                      product.localizedDescription,
                      product.localizedPriceString);
            }
            
        };
        navigationController?.setNavigationBarHidden(true, animated: false);
        b_close.imageEdgeInsets = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14);
        
        b_buy.layer.cornerRadius = b_buy.bounds.height / 3;
        
        tv_privacy.text = Utils.getLocalizedString("terms");

        Utils.setPrivacyAndTerms(tv_terms: tv_privacy, textColour: tv_privacy.textColor!);
        
        tv_pay.text = Utils.getLocalizedString("payRule");
        
        b_buy.addTarget(self, action: #selector(buySub(_:)), for: .touchUpInside);
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
}
