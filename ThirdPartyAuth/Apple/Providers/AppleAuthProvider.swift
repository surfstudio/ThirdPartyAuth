//
//  AppleAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import AuthenticationServices

public final class AppleAuthProvider: NSObject, BaseAuthProvider {

    // MARK: - Public Properties

    public var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Private Properties

    private let appleAuthHandler = AppleAuthHandler()

    // MARK: - Initialization

    override public init() {
        super.init()
        configureAppleAuthHandler()
    }

    // MARK: - Public Methods

    public func performAuth() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = appleAuthHandler
        authorizationController.performRequests()
    }

}

// MARK: - Private Methods

private extension AppleAuthProvider {

    func configureAppleAuthHandler() {
        appleAuthHandler.onAuthFinished = { [weak self] result in
            self?.onAuthFinished?(result)
        }
    }

}
