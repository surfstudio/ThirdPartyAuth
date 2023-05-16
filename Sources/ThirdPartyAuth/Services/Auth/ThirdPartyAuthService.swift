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
        startProviders()
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

    public func signOut(with authType: ThirdPartyAuthType, _ onSignOutComplete: ((Bool) -> Void)?) {
        guard
            isConfigurationInitialized(),
            isAuthTypeSupported(type: authType)
        else {
            onSignOutComplete?(false)
            return
        }

        let provider = getProvider(for: authType)
        provider.signOut { isSignedOut in
            onSignOutComplete?(isSignedOut)
        }
    }

}

// MARK: - Private Methods

private extension ThirdPartyAuthService {

    func configureProviders() {
        configuration?.authTypes.forEach({ authType in
            configureProvider(for: authType)
        })
    }

    func startProviders() {
        if isAuthTypeSupported(type: .google) {
            googleAuthProvider.start(clientID: configuration?.googleClientID)
        }

        if isAuthTypeSupported(type: .vk) {
            vkAuthProvider.start(with: configuration?.vkAuthConfiguration)
        }
    }

    func configureProvider(for authType: ThirdPartyAuthType) {
        var provider = getProvider(for: authType)
        provider.onAuthFinished = { [weak self] payload in
            self?.onAuthFinished?(payload)
        }
    }

    func isConfigurationInitialized() -> Bool {
        guard configuration != nil else {
            debugPrint("ThirdParty auth service configuration hasn't been initialized")
            return false
        }

        return true
    }

    func isAuthTypeSupported(type: ThirdPartyAuthType) -> Bool {
        return configuration?.authTypes.contains(type) ?? false
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
