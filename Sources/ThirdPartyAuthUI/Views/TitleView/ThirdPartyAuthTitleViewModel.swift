//
//  ThirdPartyAuthTitleViewModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 26.04.2023.
//

import UIKit

public struct ThirdPartyAuthTitleViewModel {

    // MARK: - Public Properties

    public let separatorColor: UIColor
    public let text: String
    public let textColor: UIColor

    // MARK: - Initialization

    public init(separatorColor: UIColor? = nil, text: String? = nil, textColor: UIColor? = nil) {
        self.separatorColor = separatorColor ?? Colors.Main.separator
        self.text = text ?? L10n.Login.title
        self.textColor = textColor ?? Colors.Text.plain
    }

}
