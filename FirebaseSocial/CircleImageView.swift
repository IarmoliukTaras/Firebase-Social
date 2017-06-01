//
//  CircleImageView.swift
//  FirebaseSocial
//
//  Created by 123 on 31.05.17.
//  Copyright © 2017 taras team. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
