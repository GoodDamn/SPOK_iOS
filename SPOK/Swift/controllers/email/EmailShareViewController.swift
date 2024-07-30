//
//  EmailShareViewController.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import UIKit

final class EmailShareViewController
    : StackViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.d(
            EmailShareViewController.self,
            "viewDidLoad():",
            view.frame
        )
        
        let layout = UILinearLayout(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: 0
            )
        )
        
        
        let labelTitle = UILabel()
        labelTitle.text = "Привет!"
        labelTitle.textColor = .white
        labelTitle.font = .extrabold(
            withSize: width * 32.nw()
        )
        
        labelTitle.frame.origin.y =
            87.nh() * height
        
        layout.addSubview(
            labelTitle
        )
        
        
        let labelDesc = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width * 316.nw(),
                height: 0
            )
        )
        labelDesc.text = .locale(
            "emailShare2"
        )
        labelDesc.textColor = .white
        labelDesc.font = .semibold(
            withSize: width * 16.nw()
        )
        labelDesc.numberOfLines = 0
        labelDesc.textAlignment = .center
                
        labelDesc.frame.origin.y = 63.nw() * width
        
        layout.addSubview(
            labelDesc
        )
        
        let textFieldEmail = UITextField(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width * 316.nw(),
                height: width * 72.nw()
            )
        )
        
        textFieldEmail.placeholder = .locale(
            "hintInput"
        )
        
        textFieldEmail.textColor = .white
        textFieldEmail.textAlignment = .center
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.layer.borderColor = UIColor
            .white.cgColor
        textFieldEmail.layer.borderWidth =
            0.01388 * textFieldEmail.height()
        
        textFieldEmail.font = .semibold(
            withSize: 0.20833 *
                textFieldEmail.height()
        )
        
        textFieldEmail.backgroundColor = .clear
        
        textFieldEmail.frame.origin.y =
            37.nw() * width
        
        layout.addSubview(
            textFieldEmail
        )
        
        let btnReady = UITextButton(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 316.nw() * width,
                height: 50.nw() * width
            )
        )
        
        btnReady.backgroundColor = .accent()
        btnReady.isWrappedByText = false
        
        btnReady.frame.origin.y = 46.nw() * width
        
        btnReady.text = .locale(
            "ready"
        )
        btnReady.textColor = .white
        
        btnReady.font = .bold(
            withSize: btnReady.height() * 0.2834
        )
        
        btnReady.textAlignment = .center
        
        btnReady.corner(
            normHeight: 0.2
        )
        
        btnReady.layout()
        
        layout.addSubview(
            btnReady
        )
        
        ScrollView().configure(
            parent: view,
            contentView: layout
        )
    }
}
