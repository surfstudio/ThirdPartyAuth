//
//  VKAuthUserModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 14.05.2023.
//

import Foundation
import VK

/// User data model, returned by VK ID authorization provider
public struct VKAuthUserModel: UserDataModel {

    // MARK: - Public Properties

    public let accessToken: VKID.AccessToken

    // MARK: - Initialization

    public init(accessToken: VKID.AccessToken) {
        self.accessToken = accessToken
    }

}
