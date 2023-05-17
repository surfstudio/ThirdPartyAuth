//
//  VKAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 14.05.2023.
//

import VK
import UIKit

/// VK ID authorization process provider
final class VKAuthProvider: NSObject, BaseAuthProvider {

    // MARK: - Nested Types

    enum VKAuthError: Error {
        case authControllerPresentationProblem
        case noVKIDAccessTokenProvided
    }

    // MARK: - Properties

    var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Private Properties

    private(set) var sharedVK: VK.Type2<App, VKID>?

    // MARK: - Methods

    func start(with configuration: VKAuthConfiguration?) {
        guard
            let configuration = configuration,
            !configuration.clientId.isEmpty,
            !configuration.clientSecret.isEmpty
        else {
            return
        }

        configureVKAuthInstance(with: configuration)
    }

    func canHandle(_ url: URL) -> Bool {
        (try? sharedVK?.open(url: url)) ?? false
    }

    func signIn() {
        guard
            let vk = sharedVK,
            let topViewController = UIApplication.topViewController(),
            let authController = try? vk.vkid.ui(for: getControllerForOauth()).uiViewController()
        else {
            onAuthFinished?(.failure(VKAuthError.authControllerPresentationProblem))
            return
        }

        topViewController.present(authController, animated: true)
    }

    func signOut(_ onSignOutComplete: ((Bool) -> Void)?) {
        sharedVK?.vkid.userSessions.first?.authorized?.logout { payload in
            if case .success = payload {
                onSignOutComplete?(true)
            } else {
                onSignOutComplete?(false)
            }
        }
    }

}

// MARK: - VKIDFlowDelegate

extension VKAuthProvider: VKIDFlowDelegate {

    func vkid(_ vkid: VKSDK.VKID.Module, didCompleteAuthWith result: Result<VKSDK.VKID.UserSession, Error>) {
        do {
            let session = try result.get()

            guard
                case .authorized(let authorized) = session.state,
                let accessToken = authorized.accessToken
            else {
                onAuthFinished?(.failure(VKAuthError.noVKIDAccessTokenProvided))
                return
            }

            let userModel = ThirdPartyAuthUserModel(from: accessToken)

            /// Try to dismiss root VK ID auth controller
            guard let signInViewController = UIApplication.topViewController()?.presentingViewController else {
                onAuthFinished?(.success(userModel))
                return
            }

            signInViewController.dismiss(animated: true) { [weak self] in
                self?.onAuthFinished?(.success(userModel))
            }

        } catch {
            onAuthFinished?(.failure(error))
        }
    }

}

// MARK: - Private Methods

private extension VKAuthProvider {

    func configureVKAuthInstance(with configuration: VKAuthConfiguration) {
        do {
            sharedVK = try VK {
                App(credentials: .init(clientId: configuration.clientId,
                                       clientSecret: configuration.clientSecret))
                VKID()
            }
        } catch {
            debugPrint("Couldn't initialize VKSDK, error: \(error)")
        }
    }

    func getControllerForOauth() -> VKID.AuthController {
        VKID.AuthController(
            flow: .externalCodeFlow(),
            delegate: self
        )
    }

}
