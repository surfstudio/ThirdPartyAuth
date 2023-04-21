//
//  ThirdPartyAuthUserModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import AuthenticationServices

public struct ThirdPartyAuthUserModel {

    // MARK: - Public Properties

    public let id: String
    public let firstName: String?
    public let lastName: String?
    public let email: String?

    // MARK: - Initialization

    public init(from appleIDCredential: ASAuthorizationAppleIDCredential) {
        self.id = appleIDCredential.user
        self.firstName = appleIDCredential.fullName?.givenName
        self.lastName = appleIDCredential.fullName?.familyName
        self.email = appleIDCredential.email
    }

}
