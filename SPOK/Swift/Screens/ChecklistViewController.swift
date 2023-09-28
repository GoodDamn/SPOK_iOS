//
//  ChecklistViewController.swift
//  SPOK
//
//  Created by GoodDamn on 12/09/2023.
//

import UIKit;
import FirebaseDatabase;
import FirebaseStorage;
import MailCore;

class ChecklistViewController: UIViewController {
    
    private let mTag = "ChecklistViewContoller:";
    
    var completionChecklist: (()->Void)? = nil;
    
    @IBOutlet weak var mTVPrivacy: UITextView!;
    @IBOutlet weak var mTFEmail: UITextField!;
    
    private let manager = Utils.getManager();
    
    private let mSenderEmail = "spok.app.community@gmail.com";
    
    override func viewDidLoad() {
        
        mTVPrivacy.text = Utils.getLocalizedString("terms");
        
        Utils.setPrivacyAndTerms(tv_terms: mTVPrivacy,
                                 textColour: UIColor(named: "privacy_color")!)
    }
    
    @IBAction func closeScreen(_ sender: UIButton) {
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction func sendChecklist(_ sender: UIButton) {
        
        let emt = mTFEmail.text ?? "";
        
        if emt.isEmpty {
            Toast.init(text: Utils.getLocalizedString("tfempty"), duration: 1.0)
                .show();
            return;
        }
        
        if emt.range(of: #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#,
                     options: .regularExpression) == nil {
            Toast.init(text: Utils.getLocalizedString("nomat"), duration: 1.0)
                .show();
            return;
        }
        
        if !(manager?.isConnected ?? true){
            Toast.init(text: Utils.getLocalizedString("nointernet"), duration: 1.0)
                .show();
        }
        
        Database.database()
            .reference(withPath: "checklistEmails/iOS")
            .childByAutoId()
            .setValue(emt);
        
        sender.isEnabled = false;
        
        self.sendToBrevo(to: emt);
        
        return;
        
        Storage.storage()
            .reference(withPath: "advance/checklist.pdf")
            .getData(maxSize: 3*1024*1024) { data, error in
                if error != nil {
                    print(self.mTag, error);
                    return;
                }
                
                guard let data = data else {
                    print(self.mTag, "DATA IS NIL");
                    return;
                }
                
                let url = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask)[0]
                    .appendingPathComponent("checklist.pdf");
                do {
                    try data.write(to: url);
                    
                    let pdfViewer = PDFViewController();
                    pdfViewer.urlPdf = url;
                    self.completionChecklist?();
                    
                    self.present(pdfViewer,
                                 animated: true) {
                        StorageApp.mUserDef
                            .setValue(true,forKey: Utils.mKEY_GOT_CHECKLIST);
                    };
                    //self.sendToSMTP(to: emt, attach: data);
                } catch {
                    print(self.mTag, error);
                }
                
            }
        
    }
    
    private func sendToBrevo(to emp:String) {
        
        let data: Data = {
            let jsonn: [String:Any] = [
                "templateId" : 2,
                "subject": "⚡️" + Utils.getLocalizedString("check3"),
                "messageVersions" :[
                    [
                        "to": [
                            ["email": emp]
                        ]
                    ]
                ]
            ];
            return try! JSONSerialization.data(withJSONObject: jsonn, options: []);
        }()
        
        let request: URLRequest? = {
            let apiKey = "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";
            guard let url = URL(string: "https://api.brevo.com/v3/smtp/email") else {
                return nil;
            };
            var request = URLRequest(url: url);
            request.httpMethod = "POST";
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue(apiKey, forHTTPHeaderField: "api-key");
            request.addValue("application/json", forHTTPHeaderField: "content-type");
            request.httpBody = data;
            return request;
        }()
        
        URLSession.shared.dataTask(with: request!) { data, resp, error in
            print(self.mTag, String(data: data!, encoding: .utf8), error);
        }.resume();
    }
    
    private func sendToSMTP(to emp:String,
                            attach data: Data) {
        let session = MCOSMTPSession();
        
        session.hostname = "smtp.gmail.com";
        session.port = 465;
        session.username = mSenderEmail;
        session.password = "jqngjoawfosetuqm";
        session.connectionType = .TLS;
        session.authType = .saslPlain;
        session.timeout = 60;
        session.isCheckCertificateEnabled = false;
        
        let builder = MCOMessageBuilder();
        builder.header.from = MCOAddress(displayName: "SPOK", mailbox: mSenderEmail);
        builder.header.to = [MCOAddress(mailbox: emp)];
        builder.header.subject = "SPOK Checklist";
        builder.htmlBody = "Your checklist";
        
        let checklist = MCOAttachment(data: data, filename: "checklist.pdf");
        
        builder.addAttachment(checklist);
        
        session.sendOperation(with: builder.data())
            .start { error in
                if let error = error {
                    print("ERROR WHILE SENDING EMAIL:",error);
                    return;
                }
                print("EMAIL SENT!");
            }
    }
}
