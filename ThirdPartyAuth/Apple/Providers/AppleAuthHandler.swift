//
//  AppleAuthHandler.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 26.04.2023.
//

import AuthenticationServices

final class AppleAuthHandler: NSObject {

    // MARK: - Properties

    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

//    // MARK: - Methods
//
//    func startAuthProcess() {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.performRequests()
//    }

}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthHandler: ASAuthorizationControllerDelegate {

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
