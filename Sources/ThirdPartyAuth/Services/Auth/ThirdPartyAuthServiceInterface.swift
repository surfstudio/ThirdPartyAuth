//
//  ThirdPartyAuthServiceInterface.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 09.05.2023.
//

import Foundation

/// Protocol for third party authorization service
public protocol ThirdPartyAuthServiceInterface: AnyObject {
    /// Closure, called on finish authorization process
    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)? { get set }
    /// List of supported auth types
    var supportedAuthTypes: [ThirdPartyAuthType] { get }
    /// Start authorization service with given configuration (called only one time)
    func start(with configuration: ThirdPartyAuthServiceConfiguration)
    /// Check is any of supported third party auth providers can handle given url
    func canHandle(_ url: URL) -> Bool
    /// Handle universal links for seamless auth (used only for VK ID Auth)
    func canContinue(userActivity: NSUserActivity) -> Bool
    /// Check is user with given id authorized (used only for Sign In with Apple)
    func checkCredentialsState(for userID: String, _ onCheckCredentialsValid: @escaping (Bool) -> Void)
    /// Try to restore user's previous sign in (used only for Google Sign-In)
    func restorePreviousSignIn()
    /// Sign in with third party auth provider
    func signIn(with authType: ThirdPartyAuthType)
    /// Sign out with third party auth provider (not used for Sign In with Apple)
    func signOut(with authType: ThirdPartyAuthType)
}
