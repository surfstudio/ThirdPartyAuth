//
//  GoogleAuthUserModel.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 01.05.2023.
//

import Foundation
import GoogleSignIn

/// User data model, returned by Google Sign-In authorization provider
public struct GoogleAuthUserModel: UserDataModel {

    // MARK: - Public Properties

    public let idToken: GIDToken?

    // MARK: - Initialization

    public init(idToken: GIDToken?) {
        self.idToken = idToken
    }

}
