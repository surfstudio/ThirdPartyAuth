//
//  ThirdPartyAuthButton.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import UIKit
import Utils

final class ThirdPartyAuthButton: CommonButton {

    // MARK: - Private Properties

    private weak var indicator: UIActivityIndicatorView?
    private var isLoading: Bool = false
    private let authType: ThirdPartyAuthType

    // MARK: - Initialization

    required init(authType: ThirdPartyAuthType) {
        self.authType = authType
        super.init(frame: .zero)
        setupInitialState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func startLoading() {
        isLoading = true
        indicator?.isHidden = false
        indicator?.startAnimating()
        setImage(nil, for: .normal)
    }

    func stopLoading() {
        isLoading = false
        indicator?.stopAnimating()
        indicator?.isHidden = true
        setImage(imageView?.image, for: .normal)
    }

}

// MARK: - Private Methods

private extension ThirdPartyAuthButton {

    func setupInitialState() {
        configureContentView()
        configureBorder()
        configureActivityIndicator()
    }

    func configureContentView() {
        contentMode = .center
        imageView?.contentMode = .scaleAspectFit

        set(backgroundColor: Colors.Buttons.normalBackground, for: [.normal])
        set(backgroundColor: Colors.Buttons.highlightedBackground, for: [.highlighted, .selected])

        setTitleForAllState(nil)
        setImage()
    }

    func setImage() {
        switch authType {
        case .apple:
            setImageForAllState(Styles.Images.Icons.apple.image)
        case .google:
            setImageForAllState(Styles.Images.Icons.google.image)
        case .vk:
            setImageForAllState(Styles.Images.Icons.vk.image)
        }
    }

    func configureBorder() {
        layer.borderWidth = 1
        layer.borderColor = Colors.Buttons.border.cgColor
    }

    func configureActivityIndicator() {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = Colors.Loader.tint
        indicator.center = .init(x: self.bounds.midX, y: self.bounds.midY)
        indicator.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleRightMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin
        ]

        self.addSubview(indicator)
        self.indicator = indicator

        indicator.isHidden = true
    }

}
