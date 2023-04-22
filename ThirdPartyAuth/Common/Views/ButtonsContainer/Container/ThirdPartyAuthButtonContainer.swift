//
//  ThirdPartyAuthButtonContainer.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import UIKit
import AuthenticationServices

public final class ThirdPartyAuthButtonContainer: UIView {

    // MARK: - Public Properties

    public var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Private Properties

    private let stackView = UIStackView()
    private lazy var appleAuthButton = ThirdPartyAuthButton(authType: .apple)
    private lazy var googleAuthButton = ThirdPartyAuthButton(authType: .google)
    private lazy var vkAuthButton = ThirdPartyAuthButton(authType: .vk)

    private var authTypes: [ThirdPartyAuthType] = []
    private var buttonsCornerRadius: CGFloat = 12
    private var buttonWidth: CGFloat = 56

    // MARK: - Providers

    private lazy var appleAuthProvider = AppleAuthProvider()

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
    }

    // MARK: - Public Methods

    public func configure(with model: ThirdPartyAuthButtonContainerModel) {
        self.authTypes = model.authTypes
        self.buttonsCornerRadius = model.buttonsCornerRadius
        self.buttonWidth = model.buttonWidth

        fill()
    }

}

// MARK: - Private Methods

private extension ThirdPartyAuthButtonContainer {

    func configureAppearance() {
        backgroundColor = .clear

        configureStackView()
        configureConstraints()
    }

    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12
    }

    func configureConstraints() {
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func fill() {
        stackView.clear()

        authTypes.forEach { authType in
            switch authType {
            case .apple:
                configureAuthButton(button: appleAuthButton, action: #selector(onAppleAuthButtonTap))
                configureAppleAuthProvider()
            case .google:
                configureAuthButton(button: googleAuthButton, action: #selector(onGoogleAuthButtonTap))
                configureGoogleAuthProvider()
            case .vk:
                configureAuthButton(button: vkAuthButton, action: #selector(onVKAuthButtonTap))
                configureVKAuthProvider()
            }
        }
    }

    func configureAuthButton(button: ThirdPartyAuthButton, action: Selector) {
        button.cornerRadius = buttonsCornerRadius
        button.addTarget(self, action: action, for: .touchUpInside)
        addButtonToContainer(button)
    }

    func addButtonToContainer(_ button: ThirdPartyAuthButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: buttonWidth),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1)
        ])

        button.setContentHuggingPriority(.init(1000), for: .horizontal)
        stackView.addArrangedSubview(button)
    }

    func configureAppleAuthProvider() {
        appleAuthProvider.onAuthFinished = { [weak self] authResult in
            self?.appleAuthButton.stopLoading()
            self?.onAuthFinished?(authResult)
        }
    }

    func configureGoogleAuthProvider() {}

    func configureVKAuthProvider() {}

}

// MARK: - Actions

private extension ThirdPartyAuthButtonContainer {

    @objc
    func onAppleAuthButtonTap() {
        appleAuthButton.startLoading()
        appleAuthProvider.performAuth()
    }

    @objc
    func onGoogleAuthButtonTap() {}

    @objc
    func onVKAuthButtonTap() {}

}
