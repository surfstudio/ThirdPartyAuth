//
//  AppleAuthUserModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 26.04.2023.
//

import Foundation

/// User data model, returned by Sing in with Apple authorization provider
public struct AppleAuthUserModel: UserDataModel {

    // MARK: - Public Properties

    public let userIdentifier: String
    public let identityToken: Data?
    public let authorizationCode: Data?

    // MARK: - Initialization

    init(userIdentifier: String, identityToken: Data?, authorizationCode: Data?) {
        self.userIdentifier = userIdentifier
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
    }

}
