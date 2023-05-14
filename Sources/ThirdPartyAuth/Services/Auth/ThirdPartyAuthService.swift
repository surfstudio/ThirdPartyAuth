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
    public var supportedAuthTypes: [ThirdPartyAuthType] {
        configuration?.authTypes ?? []
    }

    public static let sharedInstance = ThirdPartyAuthService()

    // MARK: - Private Properties

    private var configuration: ThirdPartyAuthServiceConfiguration?

    private lazy var appleAuthProvider = AppleAuthProvider()
    private lazy var googleAuthProvider = GoogleAuthProvider()
    private lazy var vkAuthProvider = VKAuthProvider()

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
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: .google) || isAuthTypeSupported(type: .vk)
        else {
            return false
        }

        return googleAuthProvider.canHandle(url) || vkAuthProvider.canHandle(url)
    }

    public func canContinue(userActivity: NSUserActivity) -> Bool {
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: .vk),
            let webpageURL = userActivity.webpageURL
        else {
            return false
        }

        return vkAuthProvider.canHandle(webpageURL)
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
            isAuthTypeSupported(type: authType)
        else {
            return
        }

        let provider = getProvider(for: authType)
        provider.signIn()
    }

    public func signOut(with authType: ThirdPartyAuthType) {
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: authType)
        else {
            return
        }

        let provider = getProvider(for: authType)
        provider.signOut()
    }

}

// MARK: - Private Methods

private extension ThirdPartyAuthService {

    func configureProviders() {
        configureAppleAuthProvider()
        configureGoogleAuthProvider()
        configureVKAuthProvider()
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

    func configureVKAuthProvider() {
        guard isAuthTypeSupported(type: .vk) else {
            return
        }

        vkAuthProvider.onAuthFinished = { [weak self] payload in
            self?.onAuthFinished?(payload)
        }
        vkAuthProvider.start(with: configuration?.vkAuthConfiguration)
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

    func getProvider(for type: ThirdPartyAuthType) -> BaseAuthProvider {
        switch type {
        case .apple:
            return appleAuthProvider
        case .google:
            return googleAuthProvider
        case .vk:
            return vkAuthProvider
        }
    }

}
