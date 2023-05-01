//
//  GoogleAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 01.05.2023.
//

import Foundation
import GoogleSignIn

/// Google sign in authorization process provider
public final class GoogleAuthProvider: NSObject, BaseAuthProvider {

    // MARK: - Public Properties

    public var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Initialization

    public init(with clientID: String) {
        super.init()
        configureGoogleAuthInstance(with: clientID)
    }

    // MARK: - Public Methods

    public func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard error == nil else {
                self?.onAuthFinished?(.failure(.googleAuthFailed))
                return
            }

            guard let user = user else {
                self?.onAuthFinished?(.failure(.emptyGoogleUserData))
                return
            }

            let userModel = ThirdPartyAuthUserModel(from: user)
            self?.onAuthFinished?(.success(userModel))
        }
    }

    public func performAuth() {
        guard let topViewController = UIApplication.topViewController() else {
            onAuthFinished?(.failure(.topViewControllerNotExist))
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: topViewController) { [weak self] signInResult, error in
            guard error == nil else {
                self?.onAuthFinished?(.failure(.googleAuthFailed))
                return
            }

            guard let signInResult = signInResult else {
                self?.onAuthFinished?(.failure(.emptyGoogleUserData))
                return
            }

            // Get user's ID token
            signInResult.user.refreshTokensIfNeeded { [weak self] user, error in
                guard error == nil else {
                    self?.onAuthFinished?(.failure(.getGoogleUserIdTokenFailed))
                    return
                }

                guard let user = user else {
                    self?.onAuthFinished?(.failure(.emptyGoogleUserData))
                    return
                }

                let userModel = ThirdPartyAuthUserModel(from: user)
                self?.onAuthFinished?(.success(userModel))
            }
        }
    }

    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }

}

// MARK: - Private Methods

private extension GoogleAuthProvider {

    func configureGoogleAuthInstance(with clientID: String) {
        GIDSignIn.sharedInstance.configuration = .init(clientID: clientID)
    }

}
