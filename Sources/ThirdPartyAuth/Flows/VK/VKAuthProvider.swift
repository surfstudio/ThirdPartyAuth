//
//  VKAuthProvider.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 14.05.2023.
//

import VKSDK
import UIKit

/// VK ID authorization process provider
final class VKAuthProvider: NSObject, BaseAuthProvider {

    // MARK: - Nested Types

    enum VKAuthError: Error {
        case authControllerPresentationProblem
        case noVKIDAccessTokenProvided
        case unsupportedAuthSessionState
        case userIsAlreadyAuthenticated
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
            let topViewController = UIApplication.topViewController()
        else {
            onAuthFinished?(.failure(VKAuthError.authControllerPresentationProblem))
            return
        }

        do {
            let authController = getAuthControllerForOauthCodeFlow()
            //let controller = try vk.vkid.ui(for: authController).uiViewController()
            let controller = try vk.vkid.ui(for: authController).uiViewController(configuration: .default)
            controller.modalPresentationStyle = .overFullScreen

            topViewController.present(controller, animated: true)
        } catch {
            debugPrint("Couldn't create VK AuthController, error: \(error)")
            onAuthFinished?(.failure(VKAuthError.authControllerPresentationProblem))
        }
    }

    func signOut() {
        let vkid = sharedVK?.vkid
        vkid?.userSessions.first?.authorized?.logout { result in
            debugPrint("User session logged out with result: \(result)")
        }
    }

}

// MARK: - VKIDFlowDelegate

extension VKAuthProvider: VKIDFlowDelegate {

    func vkid(_ vkid: VKSDK.VKID.Module, didCompleteAuthWith result: Result<VKSDK.VKID.UserSession, Error>) {
        do {
            let session = try result.get()

            switch session.state {
            case .authenticated:
                onAuthFinished?(.failure(VKAuthError.userIsAlreadyAuthenticated))
            case .authorized(let authorized):
                guard let accessToken = authorized.accessToken else {
                    onAuthFinished?(.failure(VKAuthError.noVKIDAccessTokenProvided))
                    return
                }

                let userModel = ThirdPartyAuthUserModel(from: accessToken)
                onAuthFinished?(.success(userModel))
            @unknown default:
                onAuthFinished?(.failure(VKAuthError.unsupportedAuthSessionState))
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
                App(credentials: .init(clientId: configuration.clientId, clientSecret: configuration.clientSecret))
                VKID()
            }
        } catch {
            debugPrint("Couldn't initialize VKSDK, error: \(error)")
        }
    }

    func getAuthControllerForOauthCodeFlow() -> VKID.AuthController {
        VKID.AuthController(
            flow: .externalCodeFlow(),
            delegate: self
        )
    }

}
