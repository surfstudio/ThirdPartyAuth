//
//  ThirdPartyAuthButton.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import UIKit
import ThirdPartyAuth

final class ThirdPartyAuthButton: UIButton {

    // MARK: - Constants

    private enum Constants {
        static let imageAlpha: CGFloat = 0.5
    }

    // MARK: - Properties

    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

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

// MARK: - Appearance

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

    func set(backgroundColor: UIColor, for state: UIControl.State) {
        setBackgroundImage(UIImage(color: backgroundColor), for: state)
    }

    func set(backgroundColor: UIColor, for states: [UIControl.State]) {
        states.forEach { setBackgroundImage(UIImage(color: backgroundColor), for: $0) }
    }

    func setTitleForAllState(_ title: String?) {
        setTitle(title, for: .normal)
        setTitle(title, for: .disabled)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .selected)
    }

    func setImage() {
        switch authType {
        case .apple:
            setImageForAllState(Styles.Images.Icons.apple.image, alpha: Constants.imageAlpha)
        case .google:
            setImageForAllState(Styles.Images.Icons.google.image, alpha: Constants.imageAlpha)
        case .vk:
            setImageForAllState(Styles.Images.Icons.vk.image, alpha: Constants.imageAlpha)
        }
    }

    func setImageForAllState(_ image: UIImage?, alpha: CGFloat? = nil) {
        let highlightedImage = alpha != nil
            ? image?.mask(with: alpha ?? 0)
            : image
        setImage(image, for: .normal)
        setImage(highlightedImage, for: .disabled)
        setImage(highlightedImage, for: .highlighted)
        setImage(highlightedImage, for: .selected)
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
