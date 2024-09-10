# How to use RavelinCore

The RavelinCore SDK enables:

* The generation of a unique and persistent device ID
* The collection of additional device details
* Session tracking

You can choose what functionality of the SDK you would like to use. However, at a mimimum we advise that you use the SDK to generate a reliable device ID and to send the additional device details for your app traffic. Device IDs are critical throughout our fraud prevention tool, especially for use in our graph database.

## Getting Started

This repo provides some simple projects, showing the integration and usage of RavelinCore:
* Swift using SPM
* Swift using Cocoapods
* Objective-C using Cocoapods

### Authentication

Before you can integrate with the Ravelin mobile SDKs for iOS, you will need to:

* Obtain valid API keys which are available in the Ravelin dashboard in the account menu under the Developer option
* For RavelinCore, version 2 and above, note that authentication credentials are required for [Installation](#installing-the-ravelin-ios-sdk)

If you have any questions on getting started, please ask us in your Ravelin support channel on Slack.

## Contents

* [Minimum Requirements](#minimum-requirements)
* [User Privacy](#user-privacy)
* [Install](#installing-the-sdk)
* [Update](#updating-the-sdk)
* [Usage](#usage)
    * [Fingerprint location tracking](#fingerprint-location-tracking)
    * [Importing and configuring](#importing-and-configuring)
    * [Tracking Activity](#tracking-activity)
    * [Examples](#end-to-end-example)
    * [WebView Cookie Handling](#webview-cookie-handling)
* [Privacy Manifest](#privacy-manifest)
* [Release Notes](#release-notes)
* [Core Class Reference](#ravelin-class-reference)

### Minimum Requirements

The `RavelinCore` framework, version 2.x.x and above, supports a minimum of iOS 12. Versions 1.x.x suport a minimum of iOS 9.

### User Privacy
Although the Ravelin Core SDK collects device data, because the purpose is fraud prevention, it falls under an exemption from having to ask your client for permission to track data through the AppTrackingTransparency framework. Please refer to:

- [Apple - User privacy and data use](https://developer.apple.com/app-store/user-privacy-and-data-use)

"The following use cases are not considered tracking, and do not require user permission through the AppTrackingTransparency framework... When the data broker with whom you share data uses the data solely for fraud detection, fraud prevention, or security purposes. For example, using a data broker solely to prevent credit card fraud."

[Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files) describe privacy practices in relation to:
* Data that their app or SDK collects and its purpose.
* Required Reason APIs that their app or SDK uses and the reason for using them.

Starting with version 1.1.2, RavelinCore includes a privacy manifest file and are also [digitally signed](https://developer.apple.com/documentation/xcode/verifying-the-origin-of-your-xcframeworks).

In this respect, the SDK gathers the following data types to help prevent fraud:

* Precise location
* User ID
* Device ID
* Product Interaction
* Other Data Types

A detailed breakdown of the [privacy manifest](#privacy-manifest) as provided by the Ravelin Core SDK.

## Installing the SDK

The SDK is available via Cocoapods or Swift Package Manager(SPM).

Please note that, from version 2.0.0, access to the RavelinCore binary, referenced by either SPM or CocoaPods, requires authentication credentials that will be supplied to you by a Ravelin integrations engineer; to build via Xcode you can manage the authentication credentials either via a password entry in Keychain or a .netrc entry.

### Using .netrc:
The .netrc file generally resides in the user’s home directory (~/.netrc).

See:
https://www.gnu.org/software/inetutils/manual/html_node/The-_002enetrc-file.html

Add an entry to .netrc:
```
machine ravelin.mycloudrepo.io
  login <access key as the username>   
  password <secret value as the password> 
```
For example:
```
machine ravelin.mycloudrepo.io
  login 123e4567-e89b-12d3-a456-42665544   
  password 4264454-f88d-17d3-c996-123e4567 
```

Xcode will automatically detect the .netrc file and apply the required Authentication header.


### Using Keychain:
As an alternative to a .netrc file entry, you can also use Apple's Keychain to create a password item using the same credentials.

### Installing via Cocoapods

Add RavelinCore to your PodFile:
```ruby
pod 'RavelinCore',  '~> 2.0.0', :source => 'https://github.com/unravelin/Specs.git'
```
Then, from the command line: `pod install`

### Installing via Swift Package Manager(SPM)

Add RavelinCore via Xcode, Add Package Dependency: a package manifest is available at: `git@github.com:unravelin/ravelin-core-ios-xcframework-distribution.git`

## Updating the SDK

### Updating via Cocoapods

In your PodFile change the version to the latest SDK version number.

Use the Cocoapod command line and run  `pod update RavelinCore` (for deviceId, fingerprinting and tracking activity) to update the SDK with the new version.

To verify the latest Ravelin SDK version check our [Release Notes section](#release-notes).

### Updating via Swift Package Manager(SPM)

You can update to the latest version of any packages you depend on by selecting File ▸ Swift Packages ▸ Update to Latest Package Versions.


### Updating from "fat" framework to XCFrameworks:
Before v1.1.0 the SDK was only available as a "fat" framework, since v1.1.0 and above we have updated to use the XCFrameworks.

To update to the XCFrameworks in your project's Podfile, change from using:
```ruby
'pod 'RavelinCore', '1.0.2' or: pod 'RavelinCore'
```
to:
```ruby
pod 'RavelinCore', '~> 2.0.0', :source => 'https://github.com/unravelin/Specs.git'
```

To verify the latest Ravelin SDK version check our [Release Notes section](#release-notes).

## Usage

### Fingerprint location tracking

__NOTE:__ For location tracking to be included in the data collected by the Ravelin Core SDK, your application should establish user permissions for location sharing *before* initialising the SDK. Please refer to the Apple documentation [here](https://developer.apple.com/documentation/corelocation) for more information on the subject.

---

### Importing and configuring
To use the framework within your project, import RavelinCore where required:

**Swift**
```swift
import RavelinCore
```

**Objective-C**
```objc
@import RavelinCore;
```

The singleton Ravelin class should be accessed via the `sharedInstance` method. For RavelinCore version 2 and above, a `shared` property is also available. You will first need to initialise the SDK with the `createInstance` method passing your Ravelin Publishable API Key. See the [Authentication](/api/authentication) for where to find this key. For RavelinCore version 2 and above, there is an alternative, `configure` method.

**Please ensure you use your Publishable API Key. Your Secret API Key should never be embedded in your app -- it should only be used to send requests from your backend to api.ravelin.com.**

**Swift**
```swift
// Instantiation for tracking only
let ravelin = Ravelin.createInstance("publishable_key_live_----")
```
For RavelinCore version 2 and above, there is a preferred/alternative way to create and configure the shared instance:
```swift
   /// Configure the singleton instance of the Ravelin sdk with your public key
    /// - Parameters:
    ///   - apiKey: The public API key from your Ravelin dashboard
    /// - Optional Parameters:
    ///   - customerId: Set a customerId
    ///   - tempCustomerId: Set a tempCustomerId
    ///   - orderId: Set an orderId
    ///   - customDeviceId: Set a customDeviceId
    ///   - appVersion: Set an appVersion
    ///   - logLevel: Set the logLevel (for debug/development)
    ///   - sendFingerprint: Defaults to true to send a fingerprint
    ///   - reset: reset the persisted ID
    ///   - completion: Completion handler for the response
    /// - Remark: Use this method when using RavelinSDK in your app for the first time
    public func configure(apiKey: String, customerId: String?, tempCustomerId: String? = nil, orderId: String? = nil, customDeviceId: String? = nil, appVersion: String? = nil, logLevel: RavelinCore.LogLevel = .error, sendFingerprint: Bool = true, reset: Bool = false, completion: @escaping RavelinCore.TrackResultResponse)
```
For example:
```swift
Ravelin.shared.configure(apiKey: "publishable_key_live_----", customerId: "customer012345", appVersion: "1.2.3") { result in
    switch result {
    case .success:
        if let deviceId = Ravelin.shared.deviceId {
            print("deviceId: \(deviceId)")
        }
    case .failure(let error):
            print("\(error)")
            return false
    }
}
```
**__NOTE:__  by default, calling `configure` will also send device fingerprint data, avoiding the need to make a subsequent `trackFingerprint` call. However, if required, this behaviour can be disabled:**

```swift
Ravelin.shared.configure(apiKey: "publishable_key_live_----", customerId: "customer012345", sendFingerprint: false)
```

**Objective-C**
```objc
// Instantiation for tracking only
self.ravelin = [Ravelin createInstance:@"publishable_key_live_----"];
```

Once initialised, you can use the `sharedInstance` directly to access methods and properties.

For RavelinCore version 2 and above, a `shared` property is also available and the tyepealias 'RavelinSDK' can be used in place of 'Ravelin'.

**Swift**
```swift
// Directly
Ravelin.sharedInstance().methodName()
// For RavelinCore version 2
RavelinSDK.shared.methodName()
```

**Objective-C**
```objc
// Directly
[[Ravelin sharedInstance] methodName];
```

Alternatively, keep a reference to the shared instance:

**Swift**
```swift
// Variable
let ravelin = Ravelin.sharedInstance()
// For RavelinCore version 2
let ravelinSDK = RavelinSDK.shared
```

**Objective-C**
```objc
// Variable
Ravelin *ravelin = [Ravelin sharedInstance];
```
---
### Tracking Activity

Using the Ravelin Mobile SDK, you can capture various built in events along with your own custom ones that can later be viewed in the Ravelin dashboard. This can be very useful for analysts to gain additional context during an investigation. For example, if you can see that a user is going through unexpected parts of your customer journey at a set speed on a new device that could indicate suspicious activity. It can also be powerfull information to use for our Machine Learning Models to identify new parterns and behaviours.

These are the available predefined events:

* [trackFingerprint](#trackfingerprint)
* [trackPage](#trackpage)
* [trackSearch](#tracksearch)
* [trackSelectOption](#trackselectoption)
* [trackAddToCart](#trackaddtocart-and-removefromcart)
* [trackRemoveFromCart](#trackaddtocart-and-removefromcart)
* [trackAddToWishlist](#trackaddtowishlist-and-removefromwishlist)
* [trackRemoveFromWishlist](#trackaddtowishlist-and-removefromwishlist)
* [trackViewContent](#trackviewcontent)
* [trackLogin](#tracklogin)
* [trackLogout](#tracklogout)

Available from version 2:
* [trackCurrencyChange](#trackcurrencychange)
* [trackLanguageChange](#tracklanguagechange)
* [trackPaste](#trackpaste)

Special cases:
* [Paste events](#detecting-paste-events)
* [Custom events](#custom-events-and-metadata)

#### trackFingerprint

Sends the device Fingerprint to Ravelin. Call this function before any important moment in the customer journey that matches a [checkpoint]({{% ref "/merchant/guides/other-guides/checkpoints" %}}).
The fingerprint is used to profile a user's device.
The following is a list of possible checkpoints (subject to the Ravlein products you are using):
* Right after initialisation and before trackLogin.
* Before any call to the checkout API.
* Before sending a refund request.
* Before sending an account registration request.

Ensure that the `customerId` is set before `trackFingerprint()` is called.

**Swift**
```swift
let ravelinSDK = Ravelin.createInstance("publishable_key_live_----")

ravelinSDK.customerId = "customer012345"
ravelinSDK.trackFingerprint()

// optionally providing customerId as a parameter and/or a completion handler:
ravelinSDK.trackFingerprint("customer012345") { _,_,_ in
    if let deviceId = self.ravelinSDK.deviceId {
        print("trackFingerprint for deviceId: \(deviceId)")
    }
}

// from version 2, there is an equivalent async/await function
try await ravelinSDK.trackFingerprint()
```

**__NOTE:__  For version 2 and above, using `configure`, in place of 'createInstance', defaults to sending `trackFingerprint`.**

```swift
ravelinSDK.configure(apiKey: "publishable_key_live_----", customerId: "customer012345")
```

**Objective-C**
```objc
self.ravelin = [Ravelin createInstance:@"publishable_key_live_----"];
self.ravelin.customerId = @"customer012345";
[self.ravelin trackFingerprint];
```

#### trackPage

To indicate when the user hits a new page. We would like this to be used for every new page or screen the user goes to.

**Swift**
```swift
let ravelinSDK = RavelinSDK.shared

// after ravelinSDK has been configured
ravelinSDK.trackPage("checkout page")
// optionally providing additional parameters and/or a completion handler:
ravelinSDK.trackPage("checkout page", eventProperties: ["p1" : "v1", "p2": "v2"]) {_, response, error in
    if let error {
        print("\(error)")
    }
}
// from v2, there is an equivalent async/await function
try await ravelinSDK.trackPageLoadedEvent("checkout page")
```
**Objective-C**
```objc
NSDictionary *eventProperties = @{
    @"p1" : @"v1",
    @"p2" : @"v2",
    @"p3" : @"v3"
    };

[self.ravelin trackPage: @"checkout page" eventProperties: eventProperties];
```

#### trackSearch

To be used when a user performs a search. There is an optional `searchValue` property that can be added to let us know about the search term.

**Swift**
```swift
ravelinSDK.trackSearch("search page", searchValue: "searchValue")
```
**Objective-C**
```objc
[[Ravelin sharedInstance] trackPage:@"search page" searchValue: @"searchValue"];
```

#### trackSelectOption

To be used when a user selects or changes a product option like colour, size or delivery option.

There is an optional `option` property that can be added to let us know about the what option was selected, we suggest using one of the following values `colour`, `size`, `date`, `time`, `seat`, `ticketType`, `delivery option`, but other values are accepted.

There is also an optional `optionValue` porperty that can be sent to let us know what value was selected.

**Swift**
```swift
ravelinSDK.trackSelectOption("selection page", option: "option selected", optionValue: "option value")
```
**Objective-C**
```objc
[[Ravelin sharedInstance] trackSelectOption:@"selection page" option: @"option selected"];
```

#### trackAddToCart and removeFromCart

To be used when an item is added or removed from the cart. There are two optional properteis `itemName` and `quantity` that can be added to let us know the product name and the quantity.

**Swift**
```swift
ravelinSDK.trackAddToCart("basket", itemName: "item name", quantity: 1)
ravelinSDK.trackRemoveFromCart("basket", itemName: "item name", quantity: 1)
```
**Objective-C**
```objc
[[Ravelin sharedInstance] trackAddToCart:@"basket" itemName: @"item name"];
[[Ravelin sharedInstance] trackRemoveFromCart:@"basket" itemName: @"item name"];
```

#### trackAddToWishlist and removeFromWishlist

To be used when an item is added  or removed from the wishlist. There is an optional `itemName` property that can be added to let us know the product name.

**Swift**
```swift
ravelinSDK.trackAddToWishlist("wish list", itemName: "item name")
ravelinSDK.trackRemoveFromWishlist("wish list", itemName: "item name")
```
**Objective-C**
```objc
[[Ravelin sharedInstance] trackAddToWishlist:@"wish list" itemName: @"item name"];
[[Ravelin sharedInstance] trackRemoveFromWishlist:@"wish list" itemName: @"item name"];
```

#### trackViewContent

To be used when the user interacts with product content like plays a video, expands a photo, expands product details.

There is an optional `contentType_ property` to let us know what content the user intercated with, we suggest using one of the following values `video`, `photo`, `productDescription`, `deliveryOptions`, but other values are accepted.

**Swift**
```swift
ravelinSDK.trackViewContent("content page", contentType: "video")
```
**Objective-C**
```objc
[[Ravelin sharedInstance] trackViewContent:@"content page" contentType: @"deliveryOptions"];
```

#### trackLogin

To indicate that the user has just authenticated themselves. Use eventProperties to add additional key/pair information to the payload

**Swift**
```swift
ravelinSDK.trackLogin("login page")
// optionally providing additional parameters:
ravelinSDK.trackLogin("login page", eventProperties: ["p1" : "v1", "p2": "v2"])
```
**Objective-C**
```objc
NSDictionary *eventProperties = @{
    @"p1" : @"v1",
    @"p2" : @"v2",
    @"p3" : @"v3"
    };

[self.ravelin trackLogin: @"login page" eventProperties: eventProperties];
```

#### trackLogout

To indicate when the user has signed out of their session.

**Swift**
```swift
ravelinSDK.trackLogout("logout page")
```
**Objective-C**
```objc
[self.ravelin trackLogout: @"logout page"];
```

#### trackCurrencyChange

To indicate when the user has changed the currency. The `currency` itself is an optional parameter and it should be compatible with ISO-4217.

**Swift**
```swift
ravelinSDK.trackCurrencyChange("currency update", currency: "EUR")
```
**Objective-C**
```objc
[self.ravelin trackCurrencyChange: @"currency update"];
```

#### trackLanguageChange

To indicate when the user has changed the language.
The `language` is an optional parameter and it should be compatible with ISO-639.

**Swift**
```swift
ravelinSDK.trackLanguageChange("currency update", language: "en-us")
```
**Objective-C**
```objc
[self.ravelin trackLanguageChange: @"currency update"];
```

#### trackPaste

To indicate when the user has pasted a value.
The `pastedValue` is an optional parameter.

**Swift**
```swift
ravelinSDK.trackPaste("user details form", pastedValue: "pasted value")
```
**Objective-C**
```objc
[self.ravelin trackPaste: @"user details for"];
```

---

### Detecting paste events

We can detect paste events using the UITextFieldDelegate method `shouldChangeCharactersInRange` in conjunction with the Ravelin `track` to send a custom event.
For version 2 of the SDK, a predefined `trackPaste` is available.


**Swift**

```swift
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             // avoid checking the pasteboard when a user is typing and only adding a single character at a time
            guard string.count > 1 else {
                return true
            }
            guard string.contains(UIPasteboard.general.string ?? "") else {
                return true
            }
            let pageTitle = "home"
            // Send paste event to Ravelin SDK v1
            RavelinSDK.shared.track(pageTitle, eventName: "PASTE", eventProperties: ["pastedValue": string])
            // Send paste event to Ravelin SDK v2
            RavelinSDK.shared.trackPaste(pageTitle, pastedValue: string)
            return true
        }
```

**Objective-C**
```objc
- (BOOL)textField:(UITextField *)iTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // avoid checking the pasteboard when a user is typing and only adding a single character at a time
    if(string.length <= 1) { return YES; }
    // Check if the textfield contains pasted text
    if([string containsString:[UIPasteboard generalPasteboard].string]) {
        NSString *pageTitle = @"home";
        // Send paste event to Ravelin SDK v1
        [self.ravelin track:pageTitle eventName:@"PASTE" eventProperties: @{@"pastedValue": string}];
        // Send paste event to Ravelin SDK v2
        [self.ravelin trackPaste:pageTitle pastedValue:string];
    }

    return YES;
}
```

---

### Custom Events and Metadata

The track method can be used to log notable client-side events:

**Swift**
```swift
let pageTitle = "product page"
let eventName = "SHARE_PRODUCT"
let meta = ["productId" : "213", "sharePlaftorm" : "facebook"]
ravelinSDK.track(pageTitle, eventName: eventName, eventProperties: meta)
```
**Objective-C**
```objc
NSString *pagetitle = @"product page";
NSString *eventName = @"SHARE_PRODUCT";
NSDictionary *meta = @{@"productId" : @"213", @"sharePlaftorm" : @"facebook"};
[[Ravelin sharedInstance]track:pageTitle eventName:eventName eventProperties:meta];
```

__NOTE:__ Track events have overload methods with completion handlers and will accept nil values for `eventProperties`

---
### End-to-end example

Here is a simple end-to-end example of using the RavelinCore within a View.

__NOTE:__ All Ravelin network methods are asynchronous. Completion blocks are provided so you can handle each request accordingly. The example code will not necessarily call each method sequentially and is for demonstration purposes only.

**Swift** - RavelinCore version 2:
```swift
import UIKit
import RavelinCore

class ViewController: UIViewController {
    
    let ravelinSDK = RavelinSDK.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRavelinSDK()
    }

    func setupRavelinSDK() {
        // by default, calling `configure` will also send device fingerprint data, avoiding the need to make a subsequent call to `trackFingerprint`
        ravelinSDK.configure(apiKey: "publishable_key_live_----", customerId: "customer012345", appVersion: "1.2.3") { result in
            switch result {
            case .success():
                print("setup success")
            case .failure(let error):
                print("setup error: \(error)")
            }
        }
    }
    
    @IBAction func trackButtonTouched(_ sender: Any) {
        trackLogin()
    }

    func trackLogin() {
        guard ravelinSDK.apiKey != nil else {
            print("trackLogin - apiKey has not been set")
            return
        }
        ravelinSDK.trackLogin("loginPage", eventProperties: nil) {_,_,error in
            if let error {
                print("trackLogin - didFailWithError \(error.localizedDescription)")
                return
            }
        }
    }
}
```

**Swift** - - RavelinCore version 1:

```swift
import UIKit
import RavelinCore

class ViewController: UIViewController {

    // Declare Ravelin Shared Instance with API keys
    private var ravelin = Ravelin.createInstance("publishable_key_live_----")

    override func viewDidLoad() {
        super.viewDidLoad()
        trackFingerprint()
    }

    func trackFingerprint() {
        ravelin.customerId = "customer012345"
        ravelin.trackFingerprint() { _, response, error in
            if let error = error { // handle error
                print("Ravelin error \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 { // handle success
                    ravelin.trackLogin("loginPage")
                    ravelin.orderId = "order-001"
                    ravelin.trackPage("checkout")
                }
            }
        }
    }
}
```

**Objective-C** - RavelinCore
```objc
@import RavelinCore;

@interface ViewController ()
@property (strong, nonatomic) Ravelin *ravelin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self useCore];
}

- (void)useCore {

    // Make Ravelin instance with API keys
    self.ravelin = [Ravelin createInstance:@"publishable_key_live_----"];

    self.ravelin.customerId = @"customer012345";

    // Send a device fingerprint with a completion block
    [self.ravelin trackFingerprint:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error) {
            NSDictionary *responseData;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
                NSLog(@"trackFingerprint - success");
                // track login
                [self.ravelin trackLogin:@"login"];
                self.ravelin.orderId = @"order-001";
                // track customer moving to a new page
                [self.ravelin trackPage:@"checkout"];
                // track logout
                [self.ravelin trackLogout:@"logout"];
            } else {
                // Status was not 200. Handle failure
                NSLog(@"trackFingerprint - failure");
            }
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}
@end
```
---

### WebView Cookie Handling

For apps that provide part of the user interface with WebViews, embedded within a native app, it is recommended making a deviceId cookie available to those WebViews that utilise [ravelinjs]({{% relref "../../ravelinjs" %}}). The current version of ravelinjs will adhere to any ravelinDeviceId cookie that it finds.

Here is a simple example of sharing the deviceId via a cookie.

**Swift**

```swift
import UIKit
import WebKit
import RavelinCore

extension WKWebView {
    func set(cookie: HTTPCookie, completion: SetCookieResponse? = nil) {
        configuration.websiteDataStore.httpCookieStore.setCookie(cookie, completionHandler: completion)
    }
}

class WebViewController: UIViewController {

    // get a reference to the deviceId from the shared instance which has been configured elsewhere
    private let deviceId = Ravelin.sharedInstance().deviceId
    private var webView: WKWebView!

    private func makeWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.webView)
        // ... complete WebView configuration and layout
        return webView
    }

    private func makeDeviceIdCookie(deviceId: String) -> HTTPCookie? {
        // example cookie
        var properties: [HTTPCookiePropertyKey: Any] = [
            .domain: "your.webite.com",
            .path: "/",
            .name: "ravelinDeviceId",
            .expires: NSDate(timeIntervalSinceNow: yearInterval),
            .value: deviceId]
        if #available(iOS 13.0, *) {
            properties[.sameSitePolicy] = HTTPCookieStringPolicy.sameSiteLax
        }
        return HTTPCookie(properties: properties)
    }

    private func shareDeviceIdWithWebView(deviceId: String, webView: WKWebView) {
        let cookie = makeDeviceIdCookie(deviceId)
        webView.set(cookie: cookie) {
            print("setting cookie: \(cookie)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = makeWebView()
        shareDeviceIdWithWebView(deviceId: deviceId, webView: webView)
    }
}
```

---

## Privacy Manifest
Privacy Manifest File for Ravelin Core SDK
Starting with v1.1.2, Ravelin Core SDK for iOS includes a privacy manifest file.
Apple requires that every privacy manifest file contains the following keys.

NSPrivacyTracking
Ravelin Core SDK does not use the collected data for tracking and hence this key is set to false.
```xml
<!-- Privacy manifest file for Ravelin Core SDK for iOS -->
<key>NSPrivacyTracking</key>
<false/>
```

NSPrivacyTrackingDomains
Ravelin Core SDK for iOS does not connect with any Internet domains that engage in tracking users. This key is set to an empty array of domains.
```xml
<!-- Privacy manifest file for Ravelin Core SDK for iOS -->
<key>NSPrivacyTrackingDomains</key>
<array/>
```

NSPrivacyCollectedDataTypes
Apple has identified a list of data types that when collected may help to identify/track the device. Device ID is the only data from that list that our iOS SDK collects from the device. As part of this dictionary item, Apple also requires the reason this data is collected to be declared in the privacy manifest file. This data is represented in the privacy manifest file:
```xml
<!-- Privacy manifest file for Ravelin Core SDK for iOS -->
<key>NSPrivacyCollectedDataTypes</key>
  <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeDeviceID</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <false/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypePreciseLocation</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <false/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeProductInteraction</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <false/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeOtherUsageData</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <false/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>
```

NSPrivacyAccessedAPITypes
Ravelin Core SDK does not use any of the APIs
```xml
<!-- Privacy manifest file for Ravelin Core SDK for iOS -->
<key>NSPrivacyAccessedAPITypes</key>
<array/>
```

---
---

## Release Notes

### v2.0.0 - Aug 21, 2024
* supports iOS 12 and above
* adds a convenience `configure` function
* adds predefined tracking events 
    * [trackCurrencyChange](#trackcurrencychange)
    * [trackLanguageChange](#tracklanguagechange)
    * [trackPaste](#trackpaste)
* adds the option to provide a `customDeviceId` and associate an`appVersion`
* supports [async/await](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
* provides acccess to fingerprint and tracked [event data](#eventsdata)
---

### v1.1.2 - March 15, 2024
* Provides a [privacy manifest](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files).
* And is [digitally signed](https://developer.apple.com/documentation/xcode/verifying-the-origin-of-your-xcframeworks).

### v1.1.1 - January 13, 2022

* SDK version captured during framework build (rather than at runtime)

### v1.1.0 - July 27, 2021

* Support for XCFrameworks, supporting both M1 and Intel architectures when developing via Simulator
* Added Swift Packager Manager (SPM) support.

---

### v1.0.2 - January 13, 2021

* Small improvements
* Last release providing a legacy "fat" framework on versions 1.0.2 and below. However, were possible, we recommend that you use the XCFramework distribution, since the legacy framework will no longer have new updates.

    * RavelinCore.framework - available via [RavelinCore](https://cocoapods.org/pods/RavelinCore)

---

### v1.0.1 - December 2, 2020

* Fixed crash associated with deviceId failing to persist to the keychain.
    * ```Fatal Exception: NSInvalidArgumentException```

---
### v1.0.0 - September 18, 2020

* Support for iOS 14.
* Security improvements.

---
### v0.3.4 - June 15, 2020

* Fixed crash when retrying events.
    * ```Fatal Exception:NSInvalidArgumentException```

---

### v0.3.3 - May 12, 2020

* Queueing and retrying events when there is no internet connection or server errors.
* Collecting new device properties (Emulator and Jailbroken).
* More events to track customer activity ( example: trackSearch, trackAddToWishList, ... ).
* We had to bump the version from 0.3.1 to 0.3.3 due to some issues during the release process.

---

### v0.3.1 - December 6, 2019

* Documentation improvements for CocoaPods.

---

### v0.3.0 - October 21, 2019

* Added altitude tracking.
* SDK is modularised into "Core" and "Encrypt" components.
    * RavelinCore.framework - which is used for deviceId, fingerprinting and tracking activity.

---

### v0.2.4 - May 7, 2019

* Updates to encryption.
* Minor refactoring.

---
---

## Ravelin Class Reference

```swift
    /// The singleton instance of the class
    public static let shared: RavelinCore.Ravelin

    /// for legacy compatibility
    public static func sharedInstance() -> RavelinCore.Ravelin

    /// get or set the orderId
    public var orderId: String?

    /// get or set customerId
    public var customerId: String?

    /// get or set tempCustomerId
    public var tempCustomerId: String?

    /// get or set customDeviceId
    public var customDeviceId: String?

    /// get or set appVersion
    public var appVersion: String?

    /// get or set logLevel
    public var logLevel: RavelinCore.LogLevel

    /// if set, return customDeviceId or return sdk generated deviceId
    public var deviceId: String? { get }

    /// return the sdk generated sessionId
    public var sessionId: String? { get }

    /// return the public API key from your Ravelin dashboard
    public var apiKey: String? { get }
```

#### Ravelin typealias:

```swift
public typealias RavelinSDK = RavelinCore.Ravelin
public typealias RVNCore = RavelinCore.Ravelin
```
#### Configuration:

```swift
    /// Configure the singleton instance of the Ravelin sdk with your public key
    /// - Parameters:
    ///   - apiKey: The public API key from your Ravelin dashboard
    ///   - customerId: Set a customerId
    ///   - tempCustomerId: Set a tempCustomerId
    ///   - orderId: Set an orderId
    ///   - customDeviceId: Set a customDeviceId
    ///   - appVersion: Set an appVersion
    ///   - logLevel: Set the logLevel
    ///   - sendFingerprint: Defaults to true to send a fingerprint
    ///   - reset: reset the persisted ID
    ///   - completion: Completion handler for the response
    /// - Remark: Use this method when using RavelinSDK in your app for the first time
    public func configure(apiKey: String, customerId: String?, tempCustomerId: String? = nil, orderId: String? = nil, customDeviceId: String? = nil, appVersion: String? = nil, logLevel: RavelinCore.LogLevel = .error, sendFingerprint: Bool = true, reset: Bool = false, completion: @escaping RavelinCore.TrackResultResponse)
```

#### Support for async/await:
```swift
    /// Configure the singleton instance of the Ravelin sdk with your public key
    /// - Parameters:
    ///   - apiKey: The public API key from your Ravelin dashboard
    ///   - customerId: Set a customerId
    ///   - tempCustomerId: Set a tempCustomerId
    ///   - orderId: Set an orderId
    ///   - customDeviceId: Set a customDeviceId
    ///   - appVersion: Set an appVersion
    ///   - logLevel: Set the logLevel
    ///   - sendFingerprint: Defaults to true to send a fingerprint
    ///   - reset: reset the persisted ID
    /// - Remark: Use this method when using RavelinSDK in your app for the first time
    @available(iOS 13.0.0, *)
    public func configure(apiKey: String, customerId: String?, tempCustomerId: String? = nil, orderId: String? = nil, customDeviceId: String? = nil, appVersion: String? = nil, logLevel: RavelinCore.LogLevel = .error, sendFingerprint: Bool = true, reset: Bool = false) async throws

```
#### Eventsdata:

```swift
    /// Return the events that have been sent
    /// - Returns: an array of events as json data
    public var eventsData: Data? { get }
    // example usage
       if let eventsData = ravelinSDK.eventsData,
           let jsonString = String(data: eventsData, encoding: .utf8) {
            print("\(jsonString)")
        }

    /// Removes any previously cached sent event data
    public func deleteEventsData()
```
_NOTE_ this only relates to what is stored in an events data log and will not impact what is sent to the Ravelin API

#### Legacy support:

```swift
    /// Configure a singleton instance of the Ravelin sdk with your public key
    /// - Parameters:
    ///   - apiKey: The public API key from your Ravelin dashboard
    /// - Returns: The singleton instance of the class
    /// - Remark: Use this method when using RavelinSDK in your app for the first time
    public class func createInstance(_ apiKey: String) -> RavelinCore.Ravelin
```
_NOTE_ the use of `configure` is preferred over `createInstance`

---

### Tracking Functions Reference:

* [trackFingerprint](#func-trackfingerprint)
* [trackPage](#func-trackpage)
* [trackSearch](#func-tracksearch)
* [trackSelectOption](#func-trackselectoption)
* [trackAddToCart](#func-trackaddtocart)
* [trackRemoveFromCart](#func-removefromcart)
* [trackAddToWishlist](#func-trackaddtowishlistt)
* [trackRemoveFromWishlist](#func-removefromwishlist)
* [trackViewContent](#func-trackviewcontent)
* [trackLogin](#func-tracklogin)
* [trackLogout](#func-tracklogout)
* [track](#func-track)

available from version 2:
* [trackCurrencyChange](#func-trackcurrencychange)
* [trackLanguageChange](#func-tracklanguagechange)
* [trackPaste](#func-trackpaste)

#### func trackFingerprint

````swift
    /// Fingerprints the device and sends results to Ravelin
    /// - Parameters:
    ///   - customerId: The customerId to set for this device fingerprint.
    ///   - completionHandler: Completion handler for the response
    public func trackFingerprint(_ customerId: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Fingerprints the device and sends results to Ravelin
    /// - Parameters:
    ///   - customerId: The customerId to set for this device fingerprint.
    @available(iOS 13.0.0, *)
    public func trackFingerprint(customerId: String?) async throws
````

#### func trackPage

````swift
    /// Sends a track page event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventProperties: A dictionary of meta data to send with the event
    ///   - completionHandler: Completion handler for the response
    public func trackPage(_ pageTitle: String?, eventProperties: [String : Any]?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track page loaded event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventProperties: A dictionary of meta data to send with the event
    @available(iOS 13.0.0, *)
    public func trackPageLoadedEvent(_ pageTitle: String?, eventProperties: [String : Any]? = nil) async throws
````

#### func trackSearch

````swift
    /// Sends a track search event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - searchValue: The searched term
    ///   - completionHandler: Completion handler for the response
    public func trackSearch(_ pageTitle: String?, searchValue: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track search event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - searchValue: The searched term
    @available(iOS 13.0.0, *)
    public func trackSearchEvent(_ pageTitle: String?, searchValue: String?) async throws
````

#### func trackSelectOption

````swift
    /// Sends a track select option event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - option: The name of the option
    ///   - optionValue: The value of the option
    ///   - completionHandler: Completion handler for the response
    public func trackSelectOption(_ pageTitle: String?, option: String?, optionValue: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track select option event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - option: The name of the option
    ///   - optionValue: The value of the option
    @available(iOS 13.0.0, *)
    public func trackSelectOptionEvent(_ pageTitle: String?, option: String?, optionValue: String?) async throws
````

#### func trackAddToCart

````swift
    /// Sends a track add to cart event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName:  Name of the item
    ///   - quantity: Quantity of the item
    ///   - completionHandler: Completion handler for the response
    public func trackAddToCart(_ pageTitle: String?, itemName: String?, quantity: NSNumber?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track add to cart event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName:  Name of the item
    ///   - quantity: Quantity of the item
    @available(iOS 13.0.0, *)
    public func trackAddToCartEvent(_ pageTitle: String?, itemName: String?, quantity: NSNumber?) async throws
````

#### func trackRemoveFromCart

````swift
    /// Sends a track remove from cart event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName: Name of the item
    ///   - quantity: Quantity of the item
    ///   - completionHandler: Completion handler for the response
    public func trackRemoveFromCart(_ pageTitle: String?, itemName: String?, quantity: NSNumber?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track remove from cart event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName: Name of the item
    ///   - quantity: Quantity of the item
    @available(iOS 13.0.0, *)
    public func trackRemoveFromCartEvent(_ pageTitle: String?, itemName: String?, quantity: NSNumber?) async throws
````

#### func trackAddToWishlist

````swift
    /// Sends a track add to wishlist event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName: Name of the item
    ///   - completionHandler: Completion handler for the response
    public func trackAddToWishlist(_ pageTitle: String?, itemName: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track add to wishlist event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName: Name of the item
    @available(iOS 13.0.0, *)
    public func trackAddToWishlistEvent(_ pageTitle: String?, itemName: String?) async throws
````

#### func trackRemoveFromWishlist

````swift
    /// Sends a track remove from wishlist event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName: Name of the item
    ///   - completionHandler: Completion handler for the response
    public func trackRemoveFromWishlist(_ pageTitle: String?, itemName: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track remove from wishlist event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - itemName: Name of the item
    @available(iOS 13.0.0, *)
    public func trackRemoveFromWishlistEvent(_ pageTitle: String?, itemName: String?) async throws
````

#### func trackViewContent

````swift
    /// Sends a track view content event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - contentType: The type of the content
    ///   - completionHandler: Completion handler for the response
    public func trackViewContent(_ pageTitle: String?, contentType: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track view content event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - contentType: The type of the content
    @available(iOS 13.0.0, *)
    public func trackViewContentEvent(_ pageTitle: String?, contentType: String?) async throws
````

#### func trackLogin

````swift
    /// Sends a track login event to Ravelin and sends customerId automatically if set
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventProperties: A dictionary of meta data to send with the event
    ///   - completionHandler: Completion handler for the response
    public func trackLogin(_ pageTitle: String?, eventProperties: [String : Any]?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track login event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventProperties: A dictionary of meta data to send with the event
    @available(iOS 13.0.0, *)
    public func trackLoginEvent(_ pageTitle: String?, eventProperties: [String : Any]? = nil) async throws

````

#### func trackLogout

````swift
    /// Ends current Ravelin session and sends logout event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventProperties: A dictionary of meta data to send with the event
    ///   - completionHandler: Completion handler for the response
    public func trackLogout(_ pageTitle: String?, eventProperties: [String : Any]?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track logout event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventProperties: A dictionary of meta data to send with the event
    @available(iOS 13.0.0, *)
    public func trackLogoutEvent(_ pageTitle: String?, eventProperties: [String : Any]? = nil) async throws
````

#### func track

````swift
    /// Sends a track event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventName: The name of the event
    ///   - eventProperties: A dictionary of meta data to send with the event
    ///   - completionHandler: Completion handler for the response
    public func track(_ pageTitle: String?, eventName: String?, eventProperties: [String : Any]?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - eventName: The name of the event
    ///   - eventProperties: A dictionary of meta data to send with the event
    @available(iOS 13.0.0, *)
    public func trackEvent(_ pageTitle: String?, eventName: String?, eventProperties: [String : Any]?) async throws
````

#### func trackCurrencyChange

````swift
    /// Sends a track currency change event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - currency: Name of the currency
    ///   - completionHandler: Completion handler for the response
    public func trackCurrencyChange(_ pageTitle: String?, currency: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track currency change event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - currency: Name of the currency
    @available(iOS 13.0.0, *)
    public func trackCurrencyChangeEvent(_ pageTitle: String?, currency: String?) async throws
````

#### func trackLanguageChange

````swift
    /// Sends a track language change event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - language: Name of the language
    ///   - completionHandler: Completion handler for the response
    public func trackLanguageChange(_ pageTitle: String?, language: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track language change event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - language: Name of the language
    @available(iOS 13.0.0, *)
    public func trackLanguageChangeEvent(_ pageTitle: String?, language: String?) async throws
````
#### func trackPaste

````swift
    /// Sends a track paste event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - pastedValue: The pasted vale
    ///   - completionHandler: Completion handler for the response
    public func trackPaste(_ pageTitle: String?, pastedValue: String?, completionHandler: RavelinCore.TrackResponse?)

    /// Sends a track paste event to Ravelin
    /// - Parameters:
    ///   - pageTitle: The title of the current page
    ///   - pastedValue: The pasted vale
    @available(iOS 13.0.0, *)
    public func trackPasteEvent(_ pageTitle: String?, pastedValue: String?) async throws
````
---
