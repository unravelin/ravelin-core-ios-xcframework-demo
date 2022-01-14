# Ravelin iOS SDK

The Ravelin Mobile SDKs are critical to our ability to provide informed decisions to our clients. 

Like the JavaScript library, the SDK enables:

* The generation of a unique and persistent device ID
* The collection of additional device details
* Session tracking 
* If relevant to your integration, the encryption of card details 

You can chose what functionality of the SDK you would like to use. However, at a mimimum we advise that you use the SDK to generate a reliable device ID and to send the additional device details for your app traffic. Device IDs are critical throughout our fraud prevention tool, especially for use in our graph database.  

## Getting Started

Before you can integrate with the Ravelin mobile SDK for iOS, you will need valid API keys which are available in the Ravelin Dashboard in the account menu under the Developer option.

If you have any questions on getting started, please ask us in your Ravelin support channel on Slack.

## How to use the SDK

We have two frameworks within the SDK:
* RavelinCore - which is used for deviceId, fingerprinting and tracking activity
    * available as either:
        * an XCFramework:
            - supports both M1 and Intel architectures when developing via Simulator.
            - [How to use RavelinCore.xcframework](https://github.com/unravelin/ravelin-core-ios-xcframework-demo/blob/main/README.md)
        * a legacy/"fat" framework: 
            - [How to use RavelinCore.framework](https://github.com/unravelin/ravelin-ios/blob/master/RavelinCore.md)

* RavelinEncrypt - for card details encryption
     * available as either:
        * an XCFramework:
            - supports both M1 and Intel architectures when developing via Simulator.
            - [How to use RavelinEncrypt.xcframework](https://github.com/unravelin/ravelin-encrypt-ios-xcframework-demo/blob/main/README.md)
        * a legacy/"fat" framework: 
            - [How to use RavelinEncrypt.framework](https://github.com/unravelin/ravelin-ios/blob/master/RavelinEncrypt.md)

