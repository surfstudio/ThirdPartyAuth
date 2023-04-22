//
//  StylesExtension.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 22.04.2023.
//

import UIKit
import Utils

extension UILabel {
    func apply(style: UIStyle<UILabel>) {
        style.apply(for: self)
    }
}
