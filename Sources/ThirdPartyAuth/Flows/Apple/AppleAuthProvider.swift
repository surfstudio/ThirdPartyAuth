//
//  AppleAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import AuthenticationServices

/// Sign in with Apple authorization process provider
final class AppleAuthProvider: NSObject, BaseAuthProvider {

    // MARK: - Nested Types

    enum AppleAuthError: Error {
        case invalidCredential
    }

    // MARK: - Properties

    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Methods

    func checkCredentialsState(for userID: String, _ onCheckCredentialsValid: @escaping (Bool) -> Void) {
        guard !userID.isEmpty else {
            onCheckCredentialsValid(false)
            return
        }

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, _) in
            let isValid = credentialState == .authorized
            onCheckCredentialsValid(isValid)
        }
    }

    func signIn() {
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
