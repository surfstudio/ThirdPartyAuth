//
//  UILabel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 22.04.2023.
//

import UIKit
import Utils

extension UIStyle {

    static var plainRegular: UIStyle<UILabel> {
        return LabelStyle(font: FontFamily.Inter.regular.font(size: 12),
                          fontColor: Colors.Text.plain,
                          lineHeight: 15.6,
                          kern: 0)
    }

}
