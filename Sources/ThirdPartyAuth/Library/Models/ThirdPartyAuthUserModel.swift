//
//  ThirdPartyAuthUserModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import AuthenticationServices

/// Common user data model, returned by third party authorization providers
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
