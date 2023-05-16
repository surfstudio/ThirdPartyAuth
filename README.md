# ThirdPartyAuth

## About

Library for quick register or login into your application using third party accounts. It has two main modules - **ThirdPartyAuth** and **ThirdPartyAuthUI**.
- **ThirdPartyAuth** module include components for auth / register user's in your app with their third party accounts. After getting response from this module you'll need to sent all necessary data to your backend-side and process them there.
- **ThirdPartyAuthUI** is a set of components that you can integrate into your app, if you don't need custom UI. 

## Features

- [x] Sign In with Apple
- [x] Google Sign-In
- [x] VK ID

## Prepare your app project

Before using this library you'll need to check, is your project matches all needed auth types requirements.

### Sign In with Apple

1. Enable Sign In with Apple at your Developer Account and update provisioning files
2. Add Sign In with Apple Capability to your project from Capability Library in Xcode

More info with examples you can find [here](https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6).

### Google Sign-In

1. Get an OAuth client ID, used to identify your app to Google's authentication backend. You can generate it throught Google Identity page
2. Add your OAuth client ID and custom URL scheme to Xcode project

Detailed info and instructions you can find at [official Google guide](https://developers.google.com/identity/sign-in/ios/start-integrating).

### VK ID

1. Create new or select existing application on VK developers platform
2. Get App ID and Secure Key, used to identify your app to VK backend. You can get it from your application settings on VK developers platform
3. Add your App ID and Secure Key to Xcode project or add logic to load it safety from your backend 
4. Add custom URL scheme to Xcode project

Detailed info and instructions you can find at [official VK documentation](https://platform.vk.com/docs/vkid/1.35.0/about).

## Installation

#### Swift Package Manager

- Open your Xcode project and select `File > Add Packages...`
- Enter repository URL `https://github.com/AdmiralBizon/ThirdPartyAuth`
- Select branch `add-vk-auth` (at the moment last version there)

## Usage

### ThirdPartyAuth

This module has a single public interface - `ThirdPartyAuthService`, included all main operations.

#### Configure authorization service

First of all, you'll need to configure shared instance of this service at the start of your application. For example, at your `AppDelegate` file:

```swift
import ThirdPartyAuth
...
func application(_: UIApplication,
                 didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     ...
    configureThirdPartyAuthService()
    return true
}

func configureThirdPartyAuthService() {
    let vkAuthConfiguration = getVKAuthConfiguration()
    let googleClientID = getGoogleAuthClientId()
    let authTypes = getSupportedAuthTypes(isVKEnabled: vkAuthConfiguration != nil,
                                          isGoogleEnabled: googleClientID != nil)

    let config = ThirdPartyAuthServiceConfiguration(authTypes: authTypes,
                                                    googleClientID: googleClientID,
                                                    vkAuthConfiguration: vkAuthConfiguration)

    ThirdPartyAuthService.sharedInstance.start(with: config)
}

func getVKAuthConfiguration() -> VKAuthConfiguration? {
    let vkClientSecret = KeyDataProvider.vkAuthClientSecret

    guard
        let propertiesList = getSignInPropertiesList(),
        let vkClientId = propertiesList.object(forKey: "VKAppId") as? String,
        !vkClientSecret.isEmpty
    else {
        return nil
    }

    return .init(clientId: vkClientId, clientSecret: vkClientSecret)
}

func getGoogleAuthClientId() -> String? {
    guard
        let propertiesList = getSignInPropertiesList(),
        let googleClientId = propertiesList.object(forKey: "GoogleClientId") as? String
    else {
        return nil
    }

    return googleClientId
}

func getSupportedAuthTypes(isVKEnabled: Bool = false,
                           isGoogleEnabled: Bool = false) -> [ThirdPartyAuthType] {
    var supportedAuthTypes: [ThirdPartyAuthType] = [.apple]

    if isVKEnabled {
        supportedAuthTypes.insert(.vk, at: 0)
    }

    if isGoogleEnabled {
        supportedAuthTypes.append(.google)
    }

    return supportedAuthTypes
}

func getSignInPropertiesList() -> NSDictionary? {
    guard
        let path = Bundle.main.path(forResource: "SignInProperties", ofType: "plist"),
        let propertiesList = NSDictionary(contentsOfFile: path)
    else {
        return nil
    }

    return propertiesList
}
```

In this example we made a lof of checks, cause our app supports Google Sign-In and VK ID. If your app don't - you can skip it and configure shared instance like this:
```swift
let authTypes: [ThirdPartyAuthType] = [.apple]
ThirdPartyAuthService.sharedInstance.start(with: .init(authTypes: authTypes))
```

#### Implement custom Url handling

**This step can be skipped, if you're using just only Sign In with Apple.**

##### Google Sign-In

For handle redirects by third party authentication providers, you'll need to add some logic to your delegates files.

###### AppDelegate

If you're using `AppDelegate` implement `openUrl` function this way:

```swift
func application(_: UIApplication,
                open url: URL,
                options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return ThirdPartyAuthService.sharedInstance.canHandle(url)
}
```

###### SceneDelegate

If you're using `SceneDelegate` implement `openURLContexts` function this way:

```swift
func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else {
        return
    }

    _ = ThirdPartyAuthService.sharedInstance.canHandle(url)
}
```

##### VK ID

For this auth type you'll need to implement `openUrl` or `openURLContexts` same way as for Google Sign-In.

Also only for sign in with VK ID you'll need to implement `continueUserActivity` functions.

###### AppDelegate

If you're using `AppDelegate` implement `continueUserActivity` function this way:

```swift
func application(_ application: UIApplication,
                 continue userActivity: NSUserActivity,
                 restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    return ThirdPartyAuthService.sharedInstance.canContinue(userActivity: userActivity)
}
```

###### SceneDelegate

If you're using `SceneDelegate` implement `continueUserActivity` function this way:

```swift
func scene(_: UIScene, continue userActivity: NSUserActivity) {
    _ = ThirdPartyAuthService.sharedInstance.canContinue(userActivity: userActivity)
}
```

**Without it auth process won't be finished!**

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

Here `type` parameter is one of `ThirdPartyAuthService` current configuration supported types. For example, `.apple`.

For sign out you can use next command:

```swift
thirdPartyAuthService.signOut(with: type) { [weak self] isSignedOut in
    guard isSignedOut else {
        return
    }

    self?.view?.updateUI()
}
```

Here `type` parameter is one of `ThirdPartyAuthService` current configuration supported types. For example, `.google`. 

**This command can't be used for Sign In with Apple**.

### ThirdPartyAuthUI

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

