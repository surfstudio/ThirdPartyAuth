# ThirdPartyAuthUI module

This module contains UI-components, that you can use in your app if you don't need custom UI.

**Before start with ThirdPartyAuthUI components you'll need to set up `ThirdPartyAuthService` configuration and prepare your project for support selected auth types (add custom URL schemes, generate clienId's, clientSecret etc.)**

Library has two main UI-components:

- **ThirdPartyAuthTitleView** - title view of third party auth section
- **ThirdPartyAuthButtonContaner** - main component of ThirdPartyAuthUI, included block with auth buttons of all needed auth types

#### ThirdPartyAuthTitleView

If you want to use default title, you can simply add `ThirdPartyAuthTitleView` view into swift-file or XIB and configure it constraints. Also you can add some customization to this component with `ThirdPartyAuthTitleViewModel`. It provides options to change title text, separator and text colors.
To configure `ThirdPartyAuthTitleView` call `configure(with model: yourModel)` function.

#### ThirdPartyAuthButtonContaner

You can `ThirdPartyAuthButtonContaner` view into swift-file or XIB and configure it constraints. To configure this component you'll need to initialize `ThirdPartyAuthButtonContainerModel` object. With this object you can select all needed auth types, and also set your own auth buttons configuration (cornerRadius and size).
Recommended way to set authTypes property is to use `supportedAuthTypes` property of `ThirdPartyAuthService`:

```swift
let authTypes = ThirdPartyAuthService.sharedInstance.supportedAuthTypes
let model = ThirdPartyAuthButtonContainerModel(authTypes: authTypes ?? [])
thirdPartyAuthButtonContainer.configure(with: model)
```

This array will have all auth types, which you set there at application start.

Also don't forget about set `onAuthFinished` closure of `ThirdPartyAuthButtonContainer`:

```swift
thirdPartyAuthButtonContainer.onAuthFinished = { [weak self] payload in
    self?.output?.thirdPartyAuthFinished(with: payload)
}
```

You can pass user data to your presenter or other app services through this closure to continue auth process or update UI.

There is no special sign out button in the library. So you can use your own UI components to call the `ThirdPartyAuthService.sharedInstance.signOut` function.
