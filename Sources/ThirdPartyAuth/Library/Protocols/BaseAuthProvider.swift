//
//  BaseAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

public typealias ThirdPartyAuthResult = Result<ThirdPartyAuthUserModel, ThirdPartyAuthError>

/// Protocol for third party authorization providers
public protocol BaseAuthProvider {
    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)? { get set }
    func performAuth()
}
