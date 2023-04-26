//
//  UIStackView.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import UIKit

extension UIStackView {

    func clear() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

}
