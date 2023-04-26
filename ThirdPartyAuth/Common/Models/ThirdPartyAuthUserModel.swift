//
//  ThirdPartyAuthUserModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import AuthenticationServices

public struct ThirdPartyAuthUserModel {

    // MARK: - Public Properties

    public let authType: ThirdPartyAuthType
    public let userData: UserDataModel

    // MARK: - Initialization

    init(from appleIDCredential: ASAuthorizationAppleIDCredential) {
        self.authType = .apple
        self.userData = AppleAuthUserModel(userIdentifier: appleIDCredential.user,
                                           identityToken: appleIDCredential.identityToken,
                                           authorizationCode: appleIDCredential.authorizationCode)
    }

}

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

public protocol UserDataModel {}
