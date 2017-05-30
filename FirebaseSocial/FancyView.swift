//
//  FancyView.swift
//  FirebaseSocial
//
//  Created by 123 on 30.05.17.
//  Copyright © 2017 taras team. All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }

}
