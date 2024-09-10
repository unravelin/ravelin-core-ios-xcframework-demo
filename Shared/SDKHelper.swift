import RavelinCore

struct SDKHelper {
    let ravelinSDK: RavelinSDK
    
    var isSetup: Bool {
        ravelinSDK.isSetup
    }
    
    init(apiKey: String, customerId: String?, appVersion: String?, ravelinSDK: RavelinSDK = .shared, completion: ((Bool) -> Void)? = nil) {
        self.ravelinSDK = ravelinSDK
        ravelinSDK.configure(apiKey: apiKey, customerId: customerId, appVersion: appVersion) { success in
            if !success {
                logError("sdk setup failed")
            }
            ravelinSDK.logDeviceId()
            ravelinSDK.logEventsData(label: "Fingerprint")
            completion?(success)
        }
    }
}

// MARK: track events
extension SDKHelper {
    func trackLogin(_ pageTitle: String? = "login", eventProperties: [String: Any]? = nil, completion: ((Bool) -> Void)? = nil) {
        ravelinSDK.deleteEventsData()
        ravelinSDK.trackLogin(pageTitle, eventProperties: eventProperties) { success in
            if success {
                ravelinSDK.logEventsData(label: "Login")
            } else {
                logError("sdk trackLogin failed")
            }
            completion?(success)
        }
    }
    
    func trackCheckout(orderId:  String, completion: ((Bool) -> Void)? = nil) {
        ravelinSDK.deleteEventsData()
        ravelinSDK.trackCheckout(orderId: orderId) { success in
            if success {
                ravelinSDK.logEventsData(label: "Checkout")
            } else {
                logError("sdk trackCheckout failed")
            }
            completion?(success)
        }
    }
    
    func trackLogout(_ pageTitle: String? = "logout", eventProperties: [String: Any]? = nil, completion: ((Bool) -> Void)? = nil) {
        ravelinSDK.deleteEventsData()
        ravelinSDK.trackLogout(pageTitle, eventProperties: eventProperties) { success in
            if success {
                ravelinSDK.logEventsData(label: "Logout")
            } else {
                logError("sdk trackLogout failed")
            }
            completion?(success)
        }
    }
}
