//
//  RoundedButton.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-05.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.borderWidth = 1
    }
}


