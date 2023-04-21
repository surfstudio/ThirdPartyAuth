//
//  AppleCredentialsService.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import AuthenticationServices

public final class AppleCredentialsService: BaseCredentialsService {

    // MARK: - Public Methods

    public func checkCredentialsState(for userID: String, _ onCheckCredentialsValid: @escaping (Bool) -> Void) {
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

}
