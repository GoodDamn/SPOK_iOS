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
        
        layout.addSubview(
            labelTitle
        )
        
        
        let labelDesc = UILabel()
        labelDesc.text = "asdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nfggggggggggghgggggg"
        labelDesc.textColor = .white
        labelDesc.font = .semibold(
            withSize: width * 17.nw()
        )
        labelDesc.numberOfLines = 0
        
        labelDesc.backgroundColor = .systemPink
        
        layout.addSubview(
            labelDesc
        )
        
        ScrollView().configure(
            parent: view,
            contentView: layout
        )
    }
}
