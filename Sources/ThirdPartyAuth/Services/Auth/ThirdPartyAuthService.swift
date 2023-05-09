//
//  ThirdPartyAuthService.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 09.05.2023.
//

import Foundation

public final class ThirdPartyAuthService: ThirdPartyAuthServiceInterface {

    // MARK: - Public Properties

    public var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    public static let sharedInstance = ThirdPartyAuthService()

    public var supportedAuthTypes: [ThirdPartyAuthType]? {
        configuration?.authTypes
    }

    // MARK: - Private Properties

    private var configuration: ThirdPartyAuthServiceConfiguration?

    private lazy var appleAuthProvider = AppleAuthProvider()
    private lazy var googleAuthProvider = GoogleAuthProvider()

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    public func start(with configuration: ThirdPartyAuthServiceConfiguration) {
        guard self.configuration == nil else {
            return
        }

        self.configuration = configuration
        configureProviders()
    }

    public func canHandle(_ url: URL) -> Bool {
        guard isConfigurationInitialized() else {
            return false
        }

        return googleAuthProvider.canHandle(url)
    }

    public func checkCredentialsState(for userID: String, _ onCheckCredentialsValid: @escaping (Bool) -> Void) {
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: .apple)
        else {
            return
        }

        appleAuthProvider.checkCredentialsState(for: userID, onCheckCredentialsValid)
    }

    public func restorePreviousSignIn() {
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: .google)
        else {
            return
        }

        googleAuthProvider.restorePreviousSignIn()
    }

    public func signIn(with authType: ThirdPartyAuthType) {
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: authType),
            let provider = getProvider(for: authType)
        else {
            return
        }

        provider.signIn()
    }

    public func signOut(with authType: ThirdPartyAuthType) {
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: authType),
            let provider = getProvider(for: authType)
        else {
            return
        }

        provider.signOut()
    }

}

// MARK: - Private Methods

private extension ThirdPartyAuthService {

    func configureProviders() {
        configureAppleAuthProvider()
        configureGoogleAuthProvider()
    }

    func configureAppleAuthProvider() {
        guard isAuthTypeSupported(type: .apple) else {
            return
        }

        appleAuthProvider.onAuthFinished = { [weak self] payload in
            self?.onAuthFinished?(payload)
        }
    }

    func configureGoogleAuthProvider() {
        guard isAuthTypeSupported(type: .google) else {
            return
        }

        googleAuthProvider.onAuthFinished = { [weak self] payload in
            self?.onAuthFinished?(payload)
        }
        googleAuthProvider.start(clientID: configuration?.googleClientID)
    }

    func isConfigurationInitialized() -> Bool {
        guard configuration != nil else {
            debugPrint("Auth configuration doesn't initialized")
            return false
        }

        return true
    }

    func isAuthTypeSupported(type: ThirdPartyAuthType) -> Bool {
        guard
            let configuration = configuration,
            configuration.authTypes.contains(type)
        else {
            debugPrint("Selected auth type (\(type)) doesn't supported by this configuration")
            return false
        }

        return true
    }

    func getProvider(for type: ThirdPartyAuthType) -> BaseAuthProvider? {
        switch type {
        case .apple:
            return appleAuthProvider
        case .google:
            return googleAuthProvider
        case .vk:
            return nil
        }
    }

}
