//
//  BaseAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

public typealias ThirdPartyAuthResult = Result<ThirdPartyAuthUserModel, Error>

/// Protocol for third party authorization providers
protocol BaseAuthProvider {
    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)? { get set }
    func signIn()
    func signOut()
}
