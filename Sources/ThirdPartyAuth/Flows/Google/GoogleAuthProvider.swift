//
//  GoogleAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 01.05.2023.
//

import Foundation
import GoogleSignIn

/// Google sign in authorization process provider
final class GoogleAuthProvider: NSObject, BaseAuthProvider {

    // MARK: - Nested Types

    enum GoogleAuthError: Error {
        case emptyGoogleUserData
        case getGoogleUserIdTokenFailed
        case topViewControllerNotExist
    }

    // MARK: - Properties

    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Methods

    func start(clientID: String?) {
        guard let clientID = clientID else {
            return
        }

        configureGoogleAuthInstance(with: clientID)
    }

    func canHandle(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let error = error {
                self?.onAuthFinished?(.failure(error))
                return
            }

            guard let user = user else {
                self?.onAuthFinished?(.failure(GoogleAuthError.emptyGoogleUserData))
                return
            }

            let userModel = ThirdPartyAuthUserModel(from: user)
            self?.onAuthFinished?(.success(userModel))
        }
    }

    func signIn() {
        guard let topViewController = UIApplication.topViewController() else {
            onAuthFinished?(.failure(GoogleAuthError.topViewControllerNotExist))
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: topViewController) { [weak self] signInResult, error in
            if let error = error {
                self?.onAuthFinished?(.failure(error))
                return
            }

            guard let signInResult = signInResult else {
                self?.onAuthFinished?(.failure(GoogleAuthError.emptyGoogleUserData))
                return
            }

            // Get user's ID token
            self?.refreshUserToken(with: signInResult)
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }

}

// MARK: - Private Methods

private extension GoogleAuthProvider {

    func configureGoogleAuthInstance(with clientID: String) {
        GIDSignIn.sharedInstance.configuration = .init(clientID: clientID)
    }

    func refreshUserToken(with signInResult: GIDSignInResult) {
        signInResult.user.refreshTokensIfNeeded { [weak self] user, error in
            guard error == nil else {
                self?.onAuthFinished?(.failure(GoogleAuthError.getGoogleUserIdTokenFailed))
                return
            }

            guard let user = user else {
                self?.onAuthFinished?(.failure(GoogleAuthError.emptyGoogleUserData))
                return
            }

            let userModel = ThirdPartyAuthUserModel(from: user)
            self?.onAuthFinished?(.success(userModel))
        }
    }

}
