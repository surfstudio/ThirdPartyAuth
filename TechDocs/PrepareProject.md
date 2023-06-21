# Prepare your app project

Before using ThirdPartyAuth library you'll need to check, is your project matches all needed auth types requirements.

## Sign In with Apple

1. Enable Sign In with Apple at your Developer Account and update provisioning files
2. Add Sign In with Apple Capability to your project from Capability Library in Xcode

More info with examples you can find [here](https://medium.com/@priya_talreja/sign-in-with-apple-using-swift-5cd8695a46b6).

## Google Sign-In

1. Get an OAuth client ID, used to identify your app to Google's authentication backend. You can generate it throught Google Identity page
2. Add your OAuth client ID and custom URL scheme to Xcode project

Detailed info and instructions you can find at [official Google guide](https://developers.google.com/identity/sign-in/ios/start-integrating).

## VK ID

1. Create new or select existing application on VK developers platform
2. Get App ID and Secure Key, used to identify your app to VK backend. You can get it from your application settings on VK developers platform
3. Add your App ID and Secure Key to Xcode project or add logic to load it safety from your backend 
4. Add custom URL scheme to Xcode project

Detailed info and instructions you can find at [official VK documentation](https://platform.vk.com/docs/vkid/1.35.0/about).
