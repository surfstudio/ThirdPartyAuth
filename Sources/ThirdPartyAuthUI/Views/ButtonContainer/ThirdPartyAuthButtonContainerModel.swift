//
//  ThirdPartyAuthButtonContainerModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import Foundation
import ThirdPartyAuth

public struct ThirdPartyAuthButtonContainerModel {

    // MARK: - Public Properties

    public let authTypes: [ThirdPartyAuthType]
    public let buttonConfiguration: ThirdPartyAuthButtonConfiguration

    // MARK: - Initialization

    public init(authTypes: [ThirdPartyAuthType],
                buttonConfiguration: ThirdPartyAuthButtonConfiguration) {
        self.authTypes = authTypes
        self.buttonConfiguration = buttonConfiguration
    }

}

/// Configuration for auth buttons. It's same for all buttons inside container
public struct ThirdPartyAuthButtonConfiguration {

    // MARK: - Public Properties

    public let cornerRadius: CGFloat
    public let width: CGFloat

    // MARK: - Initialization

    public init(cornerRadius: CGFloat = 12, width: CGFloat = 56) {
        self.cornerRadius = cornerRadius
        self.width = width
    }

}
