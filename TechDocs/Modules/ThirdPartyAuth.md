# ThirdPartyAuth module

This module has a single public interface - `ThirdPartyAuthService`, included all main operations.

## Configure authorization service

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
    let clientId = KeyDataProvider.ThirdPartyAuthSettings.VK.clientId
    let clientSecret = KeyDataProvider.ThirdPartyAuthSettings.VK.clientSecret

    guard
        !clientId.isEmpty,
        !clientSecret.isEmpty
    else {
        return nil
    }

    return .init(clientId: clientId, clientSecret: clientSecret)
}

func getGoogleAuthClientId() -> String? {
    let clientId = KeyDataProvider.ThirdPartyAuthSettings.Google.clientId
    return !clientId.isEmpty ? clientId : nil
}

func getSupportedAuthTypes(isVKEnabled: Bool = false, isGoogleEnabled: Bool = false) -> [ThirdPartyAuthType] {
    var supportedAuthTypes: [ThirdPartyAuthType] = [.apple]

    if isVKEnabled {
        supportedAuthTypes.insert(.vk, at: 0)
    }

    if isGoogleEnabled {
        supportedAuthTypes.append(.google)
    }

    return supportedAuthTypes
}
```

In this example we made a lof of checks, cause our app supports Google Sign-In and VK ID. If your app don't - you can skip it and configure shared instance like this:
```swift
let authTypes: [ThirdPartyAuthType] = [.apple]
ThirdPartyAuthService.sharedInstance.start(with: .init(authTypes: authTypes))
```

## Implement custom Url handling

**This step can be skipped, if you're using just only Sign In with Apple.**

### Google Sign-In

For handle redirects by third party authentication providers, you'll need to add some logic to your delegates files.

#### AppDelegate

If you're using `AppDelegate` implement `openUrl` function this way:

```swift
func application(_: UIApplication,
                open url: URL,
                options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return ThirdPartyAuthService.sharedInstance.canHandle(url)
}
```

#### SceneDelegate

If you're using `SceneDelegate` implement `openURLContexts` function this way:

```swift
func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else {
        return
    }

    _ = ThirdPartyAuthService.sharedInstance.canHandle(url)
}
```

### VK ID

For this auth type you'll need to implement `openUrl` or `openURLContexts` same way as for Google Sign-In.

Also only for sign in with VK ID you'll need to implement `continueUserActivity` function.

#### AppDelegate

If you're using `AppDelegate` implement `continueUserActivity` function this way:

```swift
func application(_ application: UIApplication,
                 continue userActivity: NSUserActivity,
                 restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    return ThirdPartyAuthService.sharedInstance.canContinue(userActivity: userActivity)
}
```

#### SceneDelegate

If you're using `SceneDelegate` implement `continueUserActivity` function this way:

```swift
func scene(_: UIScene, continue userActivity: NSUserActivity) {
    _ = ThirdPartyAuthService.sharedInstance.canContinue(userActivity: userActivity)
}
```

**Auth process won't be finished without it!**

## Auth process

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
