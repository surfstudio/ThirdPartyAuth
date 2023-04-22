//
//  ThirdPartyAuthButtonContainerModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import Foundation

public struct ThirdPartyAuthButtonContainerModel {

    // MARK: - Public Properties

    public let authTypes: [ThirdPartyAuthType]
    public let buttonsCornerRadius: CGFloat
    public let buttonWidth: CGFloat

    // MARK: - Initialization

    public init(authTypes: [ThirdPartyAuthType],
                buttonsCornerRadius: CGFloat = 12,
                buttonWidth: CGFloat = 56) {
        self.authTypes = authTypes
        self.buttonsCornerRadius = buttonsCornerRadius
        self.buttonWidth = buttonWidth
    }

}
