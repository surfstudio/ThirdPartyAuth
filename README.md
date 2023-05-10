# ThirdPartyAuth

## About

Library for quick register or login into your application using third party accounts. It has two main modules - **ThirdPartyAuth** and **ThirdPartyAuthUI**.
- **ThirdPartyAuth** module include components for auth / register user's in your app with their third party accounts. After getting response from this module you'll need to sent all necessary data to your backend-side and process them there.
- **ThirdPartyAuthUI** is a set of components that you can integrate into your app, if you don't need custom UI. 

## Features

- [x] Sign In with Apple
- [x] Google Sign-In
- [ ] VK Sign In

## Prepare your app project

Before using this library you'll need to check, is your project matches all needed auth types requirements.

### Sign In with Apple

1. Enable Sign In with Apple at your Developer Account and update provisioning files
2. Add Sign In with Apple Capability to your project from Capability Library in Xcode

More info with examples you can see [here](https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6).

### Google Sign-In

1. Get an OAuth client ID, used to identify your app to Google's authentication backend. You can generate it throught Google Identity page
2. Add your OAuth client ID and custom URL scheme to Xcode project

Detailed info and instructions you can at [official Google guide](https://developers.google.com/identity/sign-in/ios/start-integrating).

## Installation

#### Swift Package Manager

- Open your Xcode project and select `File > Add Packages...`
- Enter repository URL `https://github.com/AdmiralBizon/ThirdPartyAuth`
- Select branch `add-google-auth` (at the moment last version there)

## Usage

### ThirdPartyAuth

The module has a single public interface - `ThirdPartyAuthService`, included all main operations.

#### Configure authorization service

First of all, you'll need to configure shared instance of this service at the start of your application. For example, at your `AppDelegate` file:

```swift
import ThirdPartyAuth
...
func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     ...
    configureThirdPartyAuthService()
    return true
}

func configureThirdPartyAuthService() {
    guard let clientID = getGoogleAuthClientID() else {
        return
    }

    let authTypes: [ThirdPartyAuthType] = [.vk, .apple, .google]
    ThirdPartyAuthService.sharedInstance.start(with: .init(authTypes: authTypes, googleClientID: clientID))
}

func getGoogleAuthClientID() -> String? {
    guard
        let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
        let resourceFileDictionary = NSDictionary(contentsOfFile: path),
        let clientID = resourceFileDictionary.object(forKey: "CLIENT_ID") as? String
    else {
        return nil
    }

    return clientID
}
```

At this example we used parameter `googleClientID`, because our app supports Google Sign-In. If your app don't - you can skip additional checks and configure shared instance like this:
```swift
let authTypes: [ThirdPartyAuthType] = [.vk, .apple]
ThirdPartyAuthService.sharedInstance.start(with: .init(authTypes: authTypes))
```

#### Implement custom Url handling

**This step can be skipped, if you're using just only Sign In with Apple.**

For handle redirect into third party authentication services pages, you'll need to implement `openUrl` function at `AppDelegate` file:

```swift
func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return ThirdPartyAuthService.sharedInstance.canHandle(url)
}
```

#### Auth process

Before start auth process you'll need to configure auth service `onAuthFinished` property, will be called on auth process finish. At this closure you'll receive `Result<ThirdPartyAuthUserModel, Error>` type. `ThirdPartyAuthUserModel` include auth type and all received from authorization server user's data. You can send it to your backend for process and continue auth / registration process.

For example, this closure will looks like this:

```swift
ThirdPartyAuthService.sharedInstance.onAuthFinished = { [weak self] result in
    self?.view?.stopLoading(type: type)
    switch result {
    case .success(let userModel):
        self?.handleThirdPartyAuthResult(userModel)
    case .failure(let error):
        debugPrint("Error at third party auth process: \(error)")
    }
}
```

To start the authorization process, you need to write the following command:

```swift
ThirdPartyAuthService.sharedInstance.signIn(with: type)
```

Here `type` is one of `ThirdPartyAuthService` current configuration supported types. For example, .`apple`.

### ThirdPartyAuthUI

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
let model = ThirdPartyAuthButtonContainerModel(authTypes: ThirdPartyAuthService.sharedInstance.supportedAuthTypes)
thirdPartyAuthButtonContainer.configure(with: model)
```

This array will have all auth types, which you set there at application start.

Also don't forget about set `onAuthFinished` closure of `ThirdPartyAuthButtonContainer`:

```swift
thirdPartyAuthButtonContainer.onAuthFinished = { [weak self] payload in
    self?.output?.thirdPartyAuthFinished(with: payload)
}
```

You can pass user data to your presenter or other app services by this closure to continue auth process or update UI.
