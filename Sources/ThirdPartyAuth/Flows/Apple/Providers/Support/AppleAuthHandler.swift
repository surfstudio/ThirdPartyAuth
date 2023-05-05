//
//  AppleAuthHandler.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 26.04.2023.
//

import AuthenticationServices

final class AppleAuthHandler: NSObject {

    // MARK: - Nested Types

    enum AppleAuthError: Error {
        case invalidCredential
    }

    // MARK: - Properties

    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthHandler: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            onAuthFinished?(.failure(AppleAuthError.invalidCredential))
            return
        }

        let userModel = ThirdPartyAuthUserModel(from: appleIDCredential)
        onAuthFinished?(.success(userModel))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onAuthFinished?(.failure(error))
    }

}
