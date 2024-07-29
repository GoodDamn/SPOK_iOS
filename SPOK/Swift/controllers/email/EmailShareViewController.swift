//
//  EmailShareViewController.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import UIKit

final class EmailShareViewController
    : StackViewController {
    
    var layout: UILinearLayout!
    
    override func loadView() {
        layout = UILinearLayout(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )
        
        view = layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.d(
            EmailShareViewController.self,
            "viewDidLoad():",
            view.frame
        )
        
        let labelTitle = UILabel()
        labelTitle.text = "Привет!"
        labelTitle.textColor = .white
        labelTitle.font = .extrabold(
            withSize: width * 32.nw()
        )
        
        view.addSubview(
            labelTitle
        )
        
        
        let labelDesc = UILabel()
        labelDesc.text = "asdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\nasdsadsadasdsad\n"
        labelDesc.textColor = .white
        labelDesc.font = .semibold(
            withSize: width * 17.nw()
        )
        labelDesc.numberOfLines = 0
        
        view.addSubview(
            labelDesc
        )
        
    }
}
