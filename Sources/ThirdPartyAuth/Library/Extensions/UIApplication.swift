//
//  UIApplication.swift
//  ThirdPartyAuth
//
//  Created by Ilya Klimenyuk on 01.05.2023.
//

import UIKit

extension UIApplication {

    // MARK: - Static Properties

    static var firstKeyWindow: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }

    static var rootView: UIViewController? {
        return firstKeyWindow?.rootViewController
    }

    // MARK: - Static Methods

    static func topViewController(_ controller: UIViewController? = UIApplication.rootView) -> UIViewController? {
        if
            let navigationController = controller as? UINavigationController,
            let visibleController = navigationController.visibleViewController
        {
            return topViewController(visibleController)
        }
        if
            let tabController = controller as? UITabBarController,
            let selected = tabController.selectedViewController
        {
            return topViewController(selected)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }

        return controller
    }

}
