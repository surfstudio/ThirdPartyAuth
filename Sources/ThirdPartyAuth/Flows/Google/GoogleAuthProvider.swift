//
//  GoogleAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 01.05.2023.
//

import Foundation
import GoogleSignIn

/// Google sign in authorization process provider
final class GoogleAuthProvider: BaseAuthProvider {

    // MARK: - Nested Types

    enum GoogleAuthError: Error {
        case emptyGoogleUserData
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
            self?.handleSignInResult(user: user, error: error)
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

            self?.refreshUserToken(with: signInResult)
        }
    }

    func signOut(_ onSignOutComplete: ((Bool) -> Void)?) {
        GIDSignIn.sharedInstance.signOut()

        let isSignedOut = GIDSignIn.sharedInstance.currentUser == nil
        onSignOutComplete?(isSignedOut)
    }

}

// MARK: - Private Methods

private extension GoogleAuthProvider {

    func configureGoogleAuthInstance(with clientID: String) {
        GIDSignIn.sharedInstance.configuration = .init(clientID: clientID)
    }

    func refreshUserToken(with signInResult: GIDSignInResult) {
        signInResult.user.refreshTokensIfNeeded { [weak self] user, error in
            self?.handleSignInResult(user: user, error: error)
        }
    }

    func handleSignInResult(user: GIDGoogleUser?, error: Error?) {
        if let error = error {
            onAuthFinished?(.failure(error))
            return
        }

        guard let user = user else {
            onAuthFinished?(.failure(GoogleAuthError.emptyGoogleUserData))
            return
        }

        let userModel = ThirdPartyAuthUserModel(from: user)
        onAuthFinished?(.success(userModel))
    }

}
