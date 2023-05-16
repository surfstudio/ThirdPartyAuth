//
//  BaseAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

public typealias ThirdPartyAuthResult = Result<ThirdPartyAuthUserModel, Error>

/// Protocol for third party authorization providers
protocol BaseAuthProvider {
    /// Closure, called on finish authorization process
    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)? { get set }
    /// Common method for signIn user by third party services
    func signIn()
    /// Common method for signOut user by third party services
    func signOut(_ onSignOutComplete: ((Bool) -> Void)?)
}

extension BaseAuthProvider {

    func signOut(_ onSignOutComplete: ((Bool) -> Void)?) {}

}
