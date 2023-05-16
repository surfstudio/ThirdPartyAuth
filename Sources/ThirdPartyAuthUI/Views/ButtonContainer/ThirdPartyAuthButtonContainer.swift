//
//  ThirdPartyAuthButtonContainer.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import UIKit
import AuthenticationServices
import ThirdPartyAuth

public final class ThirdPartyAuthButtonContainer: UIView {

    // MARK: - Public Properties

    public var onAuthFinished: ((ThirdPartyAuthResult) -> Void)?

    // MARK: - Private Properties

    private let stackView = UIStackView()

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
        configureAuthButtons(with: model)
    }

    public func stopLoading(authType: ThirdPartyAuthType) {
        guard
            let button = stackView.arrangedSubviews
                .first(where: { $0.tag == authType.rawValue }) as? ThirdPartyAuthButton
        else {
            return
        }

        button.stopLoading()
    }

}

// MARK: - Appearance

private extension ThirdPartyAuthButtonContainer {

    func configureAppearance() {
        backgroundColor = .clear

        configureStackView()
        configureConstraints()
        configureAuthService()
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

    func configureAuthService() {
        ThirdPartyAuthService.sharedInstance.onAuthFinished = { [weak self] payload in
            self?.onAuthFinished?(payload)
        }
    }

}

// MARK: - Actions

private extension ThirdPartyAuthButtonContainer {

    @objc
    func tapOnButton(_ sender: ThirdPartyAuthButton) {
        guard
            let authType = ThirdPartyAuthType(rawValue: sender.tag) else {
            return
        }

        sender.startLoading()
        ThirdPartyAuthService.sharedInstance.signIn(with: authType)
    }

}

// MARK: - Private Methods

private extension ThirdPartyAuthButtonContainer {

    func configureAuthButtons(with model: ThirdPartyAuthButtonContainerModel) {
        stackView.clear()

        model.authTypes.forEach { authType in
            let authButton = generateAuthButton(for: authType,
                                                width: model.buttonConfiguration.width,
                                                cornerRadius: model.buttonConfiguration.cornerRadius)
            stackView.addArrangedSubview(authButton)
        }
    }

    func generateAuthButton(for authType: ThirdPartyAuthType,
                            width: CGFloat,
                            cornerRadius: CGFloat) -> ThirdPartyAuthButton {
        let button = ThirdPartyAuthButton(authType: authType)
        button.tag = authType.rawValue
        button.cornerRadius = cornerRadius
        button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: width),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1)
        ])

        button.setContentHuggingPriority(.init(1000), for: .horizontal)

        return button
    }

}
