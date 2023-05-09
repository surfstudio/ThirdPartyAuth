//
//  ThirdPartyAuthServiceInterface.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 09.05.2023.
//

import Foundation

public protocol ThirdPartyAuthServiceInterface: AnyObject {
    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)? { get set }
    func start(with configuration: ThirdPartyAuthServiceConfiguration)
    func canHandle(_ url: URL) -> Bool
    func checkCredentialsState(for userID: String, _ onCheckCredentialsValid: @escaping (Bool) -> Void)
    func restorePreviousSignIn()
    func signIn(with authType: ThirdPartyAuthType)
    func signOut(with authType: ThirdPartyAuthType)
}
