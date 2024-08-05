//
//  EmailShareViewController.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import UIKit

final class EmailShareViewController
    : StackViewController {
    
    private var mTextEmail: UITextField? = nil
    
    private let mTime: String = .currentTimeSeconds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        mTextEmail = UITextField(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width * 316.nw(),
                height: width * 72.nw()
            )
        )
        
        if let it = mTextEmail {
            it.placeholder = .locale(
                "hintInput"
            )
            
            it.textColor = .white
            it.textAlignment = .center
            it.borderStyle = .roundedRect
            it.layer.borderColor = UIColor
                .white.cgColor
            it.layer.borderWidth =
                0.01388 * it.height()
            
            it.font = .semibold(
                withSize: 0.20833 *
                it.height()
            )
            
            it.backgroundColor = .clear
            
            it.frame.origin.y =
                37.nw() * width
            
            layout.addSubview(
                it
            )
        }
        
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
        
        btnReady.onClick = { [weak self] view in
            self?.onClickBtnReady(
                view
            )
        }
        
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

extension EmailShareViewController {
    
    private func onClickBtnReady(
        _ v: UIView
    ) {
        guard let contact = mTextEmail?
            .text?.trim(), !contact.isEmpty else {
            Toast.show(
                text: .locale("noContact")
            )
            return
        }
        
        DatabaseUtils.contact(
            user: mTime,
            contacts: contact
        )
        
        UserDefaults.contacts(
            data: contact
        )
        
        pusht(
            MainContentViewController(),
            animDuration: 0.3,
            options: [
                .transitionCrossDissolve
            ]
        ) { [weak self] _ in
            self?.pop(at: 0)
        }
        
    }
    
}
