//
//  ThirdPartyAuthTitleView.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 22.04.2023.
//

import UIKit

public final class ThirdPartyAuthTitleView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let horizontalSpacing: CGFloat = 16
        static let separatorHeight: CGFloat = 1
    }

    // MARK: - Private Properties

    private let leftSeparatorView = UIView()
    private let rightSeparatorView = UIView()
    private let titleLabel = UILabel()

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

    public func configure(with model: ThirdPartyAuthTitleViewModel) {
        configureSeparators(with: model.separatorColor)
        configureTitleLabel(text: model.text, textColor: model.textColor)
    }

}

// MARK: - Appearance

private extension ThirdPartyAuthTitleView {

    func configureAppearance() {
        backgroundColor = .clear

        addSubviews()
        configureConstraints()
        configureSeparators()
        configureTitleLabel()
    }

    func addSubviews() {
        addSubview(leftSeparatorView)
        addSubview(titleLabel)
        addSubview(rightSeparatorView)
    }

    func configureConstraints() {
        leftSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightSeparatorView.translatesAutoresizingMaskIntoConstraints = false

        let leftSeparatorConstraints: [NSLayoutConstraint] = [
            leftSeparatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            leftSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftSeparatorView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                                        constant: -Constants.horizontalSpacing)
        ]

        let titleLabelConstraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        let rightSeparatorConstraints: [NSLayoutConstraint] = [
            rightSeparatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            rightSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightSeparatorView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                                        constant: Constants.horizontalSpacing),
            rightSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        NSLayoutConstraint.activate(leftSeparatorConstraints + titleLabelConstraints + rightSeparatorConstraints)
    }

    func configureSeparators(with color: UIColor = Colors.Main.separator) {
        leftSeparatorView.backgroundColor = color
        rightSeparatorView.backgroundColor = color
    }

    func configureTitleLabel(text: String? = L10n.Login.title, textColor: UIColor = Colors.Text.plain) {
        titleLabel.text = text

        titleLabel.numberOfLines = 1
        titleLabel.backgroundColor = .clear
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = textColor
        titleLabel.textAlignment = .center
    }

}
