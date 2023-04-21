//
//  ThirdPartyAuthButton.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 21.04.2023.
//

import UIKit

final class ThirdPartyAuthButton: UIButton {

    // MARK: - Properties

    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            configureCorners(cornerRadius: newValue)
        }
    }

    // MARK: - Private Properties

    private let authType: ThirdPartyAuthType
    private weak var indicator: UIActivityIndicatorView?
    private var isLoading: Bool = false

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
            setImageForAllState(Styles.Images.apple.image)
        case .google:
            setImageForAllState(Styles.Images.google.image)
        case .vk:
            setImageForAllState(Styles.Images.vk.image)
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

    func configureCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
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

    func setImageForAllState(_ image: UIImage?) {
        setImage(image, for: .normal)
        setImage(image, for: .disabled)
        setImage(image, for: .highlighted)
        setImage(image, for: .selected)
    }

}
