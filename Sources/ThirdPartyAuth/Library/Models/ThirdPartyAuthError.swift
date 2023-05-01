//
//  ThirdPartyAuthErrors.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 01.05.2023.
//

public enum ThirdPartyAuthError: Error {
    case appleIDAuthFailed
    case googleAuthFailed
    case emptyGoogleUserData
    case getGoogleUserIdTokenFailed
    case topViewControllerNotExist
}
