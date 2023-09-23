//
//  PDFViewController.swift
//  SPOK
//
//  Created by GoodDamn on 23/09/2023.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    var urlPdf: URL? = nil;
    
    private let mPdfView = PDFView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        guard let url = urlPdf else {
            return;
        }
        
        guard let doc = PDFDocument(url: url) else {
            return;
        }
        
        view.addSubview(mPdfView);
        mPdfView.document = doc;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        mPdfView.frame = view.bounds;
    }
}
