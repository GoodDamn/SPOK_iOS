//
//  ChecklistViewController.swift
//  SPOK
//
//  Created by GoodDamn on 12/09/2023.
//

import UIKit;
import FirebaseDatabase;
import FirebaseStorage;
//import MailCore;

class ChecklistViewController: UIViewController {
    
    private let mTag = "ChecklistViewContoller:";
    
    var completionChecklist: (()->Void)? = nil;
    
    @IBOutlet weak var mTVPrivacy: UITextView!;
    @IBOutlet weak var mTFEmail: UITextField!;
    
    private let manager = Utils.getManager();
    
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
                } catch {
                    print(self.mTag, error);
                }
                
            }
        
    }
}
