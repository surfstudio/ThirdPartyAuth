//
//  AppleAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import AuthenticationServices

final class AppleAuthProvider: NSObject, BaseAuthProvider {

    // MARK: - Properties

    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Methods

    func performAuth() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthProvider: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userModel = ThirdPartyAuthUserModel(from: appleIDCredential)
            onAuthFinished?(.success(userModel))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onAuthFinished?(.failure(error))
    }

}
