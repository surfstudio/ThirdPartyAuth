//
//  VKAuthConfiguration.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 14.05.2023.
//

/// VK ID authorization provider's configuration
public struct VKAuthConfiguration {

    // MARK: - Public Properties

    let clientId: String
    let clientSecret: String

    // MARK: - Initialization

    public init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

}
