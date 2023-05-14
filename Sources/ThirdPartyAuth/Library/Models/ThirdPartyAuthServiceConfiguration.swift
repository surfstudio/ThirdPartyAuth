//
//  ThirdPartyAuthServiceConfiguration.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 09.05.2023.
//

import Foundation

public struct ThirdPartyAuthServiceConfiguration {

    // MARK: - Properties

    let authTypes: [ThirdPartyAuthType]
    let googleClientID: String?
    let vkAuthConfiguration: VKAuthConfiguration?

    // MARK: - Initialization

    public init(authTypes: [ThirdPartyAuthType],
                googleClientID: String? = nil,
                vkAuthConfiguration: VKAuthConfiguration? = nil) {
        self.authTypes = authTypes
        self.googleClientID = googleClientID
        self.vkAuthConfiguration = vkAuthConfiguration
    }

}
