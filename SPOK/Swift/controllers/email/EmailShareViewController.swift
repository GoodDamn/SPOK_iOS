//
//  EmailShareViewController.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import UIKit
import FirebaseDatabase

final class EmailShareViewController
: KeyboardViewController {
    
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
        
        let btnClose = ViewUtils.buttonClose(
            in: view,
            sizeSquare: 50.nw(),
            iconProp: 0.5
        )
        
        btnClose.onClick = { [weak self] v in
            
            v.isUserInteractionEnabled = false
            
            self?.getStatRef(
                "CANCEL"
            ).increment()
            
            self?.pusht(
                MainContentViewController(),
                animDuration: 0.3,
                options: [
                    .transitionCrossDissolve
                ]
            ) { [weak self] _ in
                self?.pop(at: 0)
            }
        }
        
        btnClose.frame.origin.y = 0
        
        btnClose.alpha = 0.1
        
        layout.addSubview(
            btnClose,
            centerHorizontally: false
        )
        
        let labelTitle = UILabel()
        labelTitle.text = "Привет!"
        labelTitle.textColor = .white
        labelTitle.font = .extrabold(
            withSize: width * 32.nw()
        )
        
        labelTitle.frame.origin.y = -btnClose.frame.height * 0.9
        
        layout.addSubview(
            labelTitle
        )
        
        let imageView = UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width * 353.nw(),
                height: width * 257.nw()
            )
        )
        imageView.image = UIImage(
            named: "mm"
        )
        layout.addSubview(
            imageView
        )
        
        let labelParag = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width * 325.nw(),
                height: 0
            )
        )

        labelParag.text = .locale(
            "emailShare"
        )
        labelParag.textAlignment = .center
        labelParag.font = .bold(
            withSize: width * 20.nw()
        )
        labelParag.textColor = .white
        labelParag.numberOfLines = 0
        layout.addSubview(
            labelParag
        )
        
        let labelDesc = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width * 325.nw(),
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
                
        labelDesc.frame.origin.y = 30.nw() * width
        
        layout.addSubview(
            labelDesc
        )
        
        mTextEmail = UITextFieldDone(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width * 251.nw(),
                height: width * 60.nw()
            )
        )
        
        if let it = mTextEmail {
            it.placeholder = .locale(
                "hintInput"
            )
            
            it.textColor = .white
            it.textAlignment = .center
            it.borderStyle = .roundedRect
            it.layer.borderColor = UIColor.white.cgColor
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
        
        let s = ScrollView()
        s.paddingBottom = btnReady.height()
        s.configure(
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
            .text?.trim(), !contact.isEmpty  else {
            Toast.show(
                text: .locale("noContact")
            )
            return
        }
        
        guard contact.count < 50 else {
            Toast.show(
                text: .locale("contact50")
            )
            return
        }
        
        v.isUserInteractionEnabled = false
        
        Database.sendContact(
            user: mTime,
            contact: contact
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
