# ThirdPartyAuth

## About

Library for quick register or login into your application using third party accounts.

## Features

- [x] Apple Sign In
- [ ] Google Sign In
- [ ] VK Sign In
- [x] UI-components for Third Party Auth

## Installation

#### Swift Package Manager

- Open your Xcode project and select `File > Add Packages...`
- Enter repository URL `https://github.com/AdmiralBizon/ThirdPartyAuth`
- Select branch `add-apple-auth` (at the moment last version there)

## Usage

Library has two main UI-components:

- **ThirdPartyAuthTitleContainer** - can be used for separate your main login methods from additional once
- **ThirdPartyAuthButtonContaner** - here your can pass all the necessary authorization methods 

If you want to use default title, you can simply add `ThirdPartyAuthTitleContainer` view into swift-file or XIB and configure it constraints.

Adding `ThirdPartyAuthButtonContaner` looks like this:
```swift
import ThirdPartyAuth
...

// MARK: - IBOutlets

@IBOutlet private weak var thirdPartyAuthButtonContainer: ThirdPartyAuthButtonContainer!
...

func configureThirdPartyAuthButtonContainer() {
    let model = ThirdPartyAuthButtonContainerModel(authTypes: [.vk, .apple, .google])
    thirdPartyAuthButtonContainer.configure(with: model)
    
    thirdPartyAuthButtonContainer.onAuthFinished = { [weak self] authResult in
        self?.output?.thirdPartyAuthFinished(with: authResult)
    }
}
```

Button container provides square buttons with default corner radius value. You can set your own buttons size and corner radius values by `ThirdPartyAuthButtonContainerModel`.

After finish third party authorization process you will receive result model at `onAuthFinished` closure. The model of result is `Result<ThirdPartyAuthUserModel, Error>`, which contains user data (include identifier, name etc.) or error.
