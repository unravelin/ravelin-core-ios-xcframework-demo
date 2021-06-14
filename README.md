# How to use RavelinCore

## Contents

* [Building and Installation](#building-and-installation)
* [Usage](#usage)
* [Examples](#end-to-end-example)
* [Class Reference](#ravelin-class-reference)
* [License](#license)

## Building and Installation

### Installing the Ravelin Mobile SDK via Cocoapods

Add RavelinCore to your PodFile: 
```ruby
pod 'RavelinCore', '1.1.0', :source => 'https://github.com/unravelin/Specs.git'
```
then, from the command line: `pod install`

### Installing the Ravelin Mobile SDK via Swift Package Manager(SPM)

Add RavelinCore via Xcode, Add Package Dependency:
a package manifest is available at:
'git@github.com:unravelin/ravelin-core-ios-xcframework-distribution.git'

available from version 1.1.0

<img width="487" alt="RavelinCore-SPM" src="https://user-images.githubusercontent.com/729131/121674900-8cc67700-caaa-11eb-8b07-00a3876ec133.png">

## Usage

To use the framework within your project, import RavelinCore where required:

This repo provides three simple projects, showing the integration and usage of RavelinCore:
* Swift using SPM
* Swift using Cocoapods
* Objective-C using Cocoapods

#### Objective-C
```objc
#import <RavelinCore/Ravelin.h>
```

#### Swift
```swift
import RavelinCore
```

The singleton Ravelin class should be accessed via the sharedInstance method. You will first need to initialise the SDK with the `createInstance` method call with your Ravelin public API key.

#### Objective-C
```objc

// Instantiation for tracking
self.ravelin = [Ravelin createInstance:@"publishable_key_live_----"];
```

#### Swift
```swift

// Instantiation for tracking
let ravelin = Ravelin.createInstance("publishable_key_live_----")
```

Once initialised, you can use the sharedInstance directly to access methods and properties

#### Objective-C
```objc

// Directly
[[Ravelin sharedInstance] methodName];

// Variable
Ravelin *ravelin = [Ravelin sharedInstance];

```

#### Swift
```swift

// Directly
Ravelin.sharedInstance().methodName()

// Variable
let ravelin = Ravelin.sharedInstance()
```

### Tracking Activity

Using the Ravelin Mobile SDK, you can capture various built in events along with your own custom ones that can later be viewed in the Ravelin Dashboard. This can be very useful for analysts to gain additional context during an investigation. For example, if you can see that a user is going through unexpected parts of your customer journey at a set speed on a new device that could indicate suspicious activity. 

> `Ravelin.trackPage:(NSString *)pageTitle` - to indicate when the user hits a new page. 

> `Ravelin.trackLogin:(NSString *)pageTitle eventProperties:(NSDictionary *)eventProperties` - to indicate that the user has just authenticated themselves. Use eventProperties to add additional key/pair information to the payload

> `Ravelin.trackLogout:(NSString *)pageTitle eventProperties:(NSDictionary *)eventProperties` - to indicate when the user has signed out of their session.

> `Ravelin.trackFingerprint:(NSDictionary *)eventProperties` – To be used at checkout to profile the users device.

> `Ravelin.trackSearch:(NSString* _Nullable)pageTitle searchValue:(NSString* _Nullable)searchValue;` - track a _search_ event, with the search term.

> `Ravelin.trackSelectOption:(NSString* _Nullable)pageTitle
                      option:(NSString* _Nullable)option
                 optionValue:(NSString* _Nullable)optionValue;` - track an _option selected_ event, with the option value.

> `Ravelin.trackAddToCart:(NSString* _Nullable)pageTitle
                 itemName:(NSString* _Nullable)itemName
                 quantity:(NSNumber* _Nullable)quantity;` - track an _add to cart_ event, with the item name and quantity.

> `Ravelin.trackRemoveFromCart:(NSString* _Nullable)pageTitle
                      itemName:(NSString* _Nullable)itemName
                      quantity:(NSNumber* _Nullable)quantity;` - track a _remove from cart_ event, with the item name and quantity.

> `Ravelin.trackAddToWishlist:(NSString* _Nullable)pageTitle
                     itemName:(NSString* _Nullable)itemName;` - track an _add to wishlist_ event, with the item name.

> `Ravelin.trackRemoveFromWishlist:(NSString* _Nullable)pageTitle
                          itemName:(NSString* _Nullable)itemName;` - track a _remove from wishlist_ event, with the item name.

> `Ravelin.trackViewContent:(NSString* _Nullable)pageTitle
                contentType:(NSString* _Nullable)contentType;` - track a _view content_ event, with the content type.

### Custom Events and Metadata

The track method can be used to log notable client-side events:

#### Objective-C
```objc
NSString *pagetitle = @"products";
NSString *eventName = @"PRODUCT_SEARCH";
NSDictionary *meta = @{@"productId" : @"213", @"sizeId" : @"M"};
[[Ravelin sharedInstance]track:pageTitle eventName:eventName eventProperties:meta];
```

#### Swift
```swift
let pageTitle = "products"
let eventName = "PRODUCT_SEARCH"
let meta = ["productId" : "213", "SIZE" : "M"]
Ravelin.sharedInstance().track(pageTitle, eventName: eventName, eventProperties: meta)
```

### Detecting paste events

We can detect paste events using the UITextFieldDelegate method `shouldChangeCharactersInRange` in conjunction with the Ravelin `track` method to send a custom event.

#### Objective-C
```objc
- (BOOL)textField:(UITextField *)iTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Only detect specific textfields in our app
    if(iTextField.tag == 1002 || iTextField.tag == 1003) { return NO; }
    
    // Check if the textfield contains pasted text
    if([string containsString:[UIPasteboard generalPasteboard].string]) {
    
        // Send paste event to Ravelin
        NSString *pageTitle = @"home";
        NSString *pasteLength = [NSString stringWithFormat:@"%ld", (long)[UIPasteboard generalPasteboard].string.length];
        NSDictionary *meta = @{@"pasteLength": pasteLength};
        [self.ravelin track:pageTitle eventName:@"paste" eventProperties:meta];
    }
    
    return YES;
}
```

#### Swift

```swift
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if(string.contains(UIPasteboard.general.string ?? "")){
        let pageTitle = "home"
        let eventName = "paste"
        let pasteLength : String = "\(UIPasteboard.general.string?.count ?? 0)"
        let meta = ["pasteLength" : pasteLength]
        self.ravelin.track(pageTitle, eventName: eventName, eventProperties: meta)
    }
    return true
}
```

> __NOTE:__ Track events have overload methods with completion handlers and will accept nil values for `eventProperties`

### Fingerprint location tracking

For location tracking to be successful from within the Ravelin Mobile SDK, your application should ask for user permissions for location sharing. Please refer to the Apple documentation [here](https://developer.apple.com/documentation/corelocation) for more information on the subject.


## End to end example

What follows is a simple end-to-end example of using the Ravelin Framework within a View.

__NOTE:__ All Ravelin network methods are asynchronous. Completion blocks are provided so you can handle each request accordingly. The example code will not necessarily call each method sequentially and is for demonstration purposes only.


#### Objective-C
```objc
#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <RavelinCore/Ravelin.h>
@interface ViewController ()
@property (strong, nonatomic) Ravelin *ravelin;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Make Ravelin instance with api keys
    self.ravelin = [Ravelin createInstance:@"publishable_key_live_----"];
    
    // Setup customer info and track their login
    self.ravelin.customerId = @"customer1234";
    self.ravelin.orderId = @"web-001";
    [self.ravelin trackLogin:@"loginPage"];
    
    // Track customer moving to a new page
    [self.ravelin trackPage:@"checkout"];
    
    // Send a device fingerprint
    [self.ravelin trackFingerprint];
    
    // Send a device fingerprint with a completion block (if required)
    [self.ravelin trackFingerprint:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error) {
            NSDictionary *responseData;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
                // Do something with responseData
                
            } else {
                // Status was not 200. Handle failure
            }
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    
    // Track a customer logout
    [self.ravelin trackLogout:@"logoutPage"];
}
@end
```

#### Swift

```swift
import UIKit
import RavelinCore

class ViewController: UIViewController {

    // Declare Ravelin Shared Instance with API keys
    private var ravelin : Ravelin = Ravelin.createInstance("publishable_key_live_----")
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup customer info and track their login
        ravelin.customerId = "customer1234"
        ravelin.orderId = "web-001"
        ravelin.trackLogin("loginPage")
        
        // Track customer moving to a new page
        ravelin.trackPage("checkout")
        
        // Send a device fingerprint
        ravelin.trackFingerprint()
        
        // Send a device fingerprint with a completion block (if required)
        ravelin.trackFingerprint { (data, response, error) -> Void in
            if let error = error {
                // Handle error
                print("Ravelin error \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // Handle success
                }
            }
        }
        
        // Track a customer logout
        ravelin.trackLogout("logoutPage")

    }
}
```

## Ravelin Class Reference

### Ravelin Class Methods

---

#### createInstance (apiKey)

Create a singleton instance of the Ravelin SDK with your public API key (use this method to create an SDK instance for tracking purposes only)

**Parameters**

| Parameter     | Type               | Description  |
| ------------- |---------------------|-------|
| apiKey     | String     | The public api key from your Ravelin dashboard |

**Return value**

 The singleton instance of the class

---

#### sharedInstance

Get the instantiated Ravelin singleton


**Return value**

 The singleton instance of the class

---

#### trackFingerprint

Fingerprints the device and sends results to Ravelin

---

#### trackFingerprint (completionHandler)

Fingerprints the device and sends results to Ravelin

**Parameters**

| Parameter     | Type               | Description  |
| ------------- |---------------------|-------|
| completionHandler     | Object     | Completion block to handle response |

---

#### trackFingerprint(customerId, completionHandler)

Sets a customerId if one has not already been set and sends a fingerprint to Ravelin

**Parameters**

| Parameter     | Type               | Description  |
| ------------- |---------------------|-------|
| customerId     | String     | The customerId to set for this device fingerprint. |
| completionHandler     | Object     | Completion block to handle response |

---

**Return value**

Dictionary containing the complete payload to send

---

#### track (pageTitle, eventName, eventProperties)

Sends a track event to Ravelin. Use this method to send custom events and data to analyse in your dashboard.

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| eventName           | String          | The name of the event |
| eventProperties     | Dictionary      | A dictionary of meta data to send with the event |

Also available with a completion handler: track (pageTitle, eventName, eventProperties, completionHandler)

---

#### trackPage (pageTitle, eventProperties)

Sends a track page event to Ravelin.

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| eventProperties     | Dictionary      | A dictionary of meta data to send with the event |

Also available with a completion handler: trackPage (pageTitle, eventProperties, completionHandler)

---

#### trackLogin (pageTitle, eventProperties)

Sends a track login event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| eventProperties     | Dictionary      | A dictionary of meta data to send with the event |

Also available with a completion handler: trackLogin (pageTitle, eventProperties, completionHandler)

---

#### trackLogout (pageTitle, eventProperties)

Ends current Ravelin session and sends logout event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| eventProperties     | Dictionary      | A dictionary of meta data to send with the event |

Also available with a completion handler: trackLogout (pageTitle, eventProperties, completionHandler)

---

#### trackSearch (pageTitle, searchValue)

Sends a track search event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| searchValue         | String          | The searched term |

Also available with a completion handler: trackSearch (pageTitle, searchValue, completionHandler)

---

#### trackSelectOption (pageTitle, option, optionValue)

Sends a track selected option event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| option              | String          | The name of the option |
| optionValue         | String          | The value of the option |

Also available with a completion handler: trackSelectOption (pageTitle, option, optionValue, completionHandler)

---

#### trackAddToCart (pageTitle, itemName, quantity)

Sends a track add to cart event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| itemName            | String          | The name of the item |
| quantity            | NSNumber        | The quantity of the item |

Also available with a completion handler: trackAddToCart (pageTitle, itemName, quantity, completionHandler)

---

#### trackRemoveFromCart (pageTitle, itemName, quantity)

Sends a track remove from cart event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| itemName            | String          | The name of the item |
| quantity            | NSNumber        | The quantity of the item |

Also available with a completion handler: trackRemoveFromCart (pageTitle, itemName, quantity, completionHandler)

---

#### trackAddToWishlist (pageTitle, itemName)

Sends a track add to wishlist event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| itemName            | String          | The name of the item |

Also available with a completion handler: trackAddToWishlist (pageTitle, itemName, completionHandler)

---

#### trackRemoveFromWishlist (pageTitle, itemName)

Sends a track remove from wishlist event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| itemName            | String          | The name of the item |

Also available with a completion handler: trackRemoveFromWishlist (pageTitle, itemName, completionHandler)

---

#### trackViewContent (pageTitle, contentType)

Sends a track content type event to Ravelin

**Parameters**

| Parameter           | Type            | Description  |
| --------------------|-----------------|----------------------------|
| pageTitle           | String          | The title of the current page |
| contentType         | String          | The type of the content |

Also available with a completion handler: trackViewContent (pageTitle, contentType, completionHandler)

---

### Ravelin Class Properties

---

#### apiKey

The public api key from your dashboard 


#### customerId

Your chosen customer id 


#### tempCustomerId

Temp customer id  


#### sessionId (read only)

The Ravelin generated sessionId


#### deviceId (read only)

The Ravelin generated device id 


#### orderId

 Your chosen order id

--- 

# License

License information can be found [here](https://github.com/unravelin/ravelin-ios/blob/1.0.0-docs/LICENSE)
