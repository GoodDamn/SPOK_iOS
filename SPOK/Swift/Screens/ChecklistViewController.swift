//
//  ChecklistViewController.swift
//  SPOK
//
//  Created by GoodDamn on 12/09/2023.
//

import UIKit;
import MailCore;

class ChecklistViewController: UIViewController {
    
    @IBOutlet weak var mTVPrivacy: UITextView!;
    @IBOutlet weak var mTFEmail: UITextField!;
    
    override func viewDidLoad() {
        
        Utils.setPrivacyAndTerms(tv_terms: mTVPrivacy,
                                 textColour: UIColor(named: "privacy_color")!)
    }
    
    @IBAction func sendChecklist(_ sender: UIButton) {
        
        if mTFEmail.text?.isEmpty ?? true {
            return;
        }
        
        let session = MCOSMTPSession();
        let email = "spok.app.community@gmail.com";
        session.hostname = "smtp.gmail.com";
        session.port = 465;
        session.username = email;
        session.password = "jqngjoawfosetuqm";
        session.connectionType = .TLS;
        session.authType = .saslPlain;
        session.timeout = 60;
        session.isCheckCertificateEnabled = false;
        
        
        let builder = MCOMessageBuilder();
        builder.header.from = MCOAddress(displayName: "SPOK", mailbox: email);
        builder.header.to = [MCOAddress(mailbox: mTFEmail.text)];
        builder.header.subject = "Subject";
        builder.htmlBody = "Subject html body";
        
        let pdf = MCOAttachment(data: (Data)([1,1,2,3]), filename: "checklist.pdf");
        
        builder.addAttachment(pdf);
        
        session.sendOperation(with: builder.data())
            .start { error in
                if let error = error {
                    print("ERROR WHILE SENDING EMAIL:",error);
                    return;
                }
                
                Toast.init(text: "Email sent", duration: 1.5).show();
                print("EMAIL SENT!");
                self.navigationController?.popViewController(animated: true);
            }
    }
}
