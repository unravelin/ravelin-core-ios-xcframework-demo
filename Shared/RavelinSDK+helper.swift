import RavelinCore

extension RavelinSDK {
    func configure(apiKey: String, customerId: String?, appVersion: String?, completion: ((Bool) -> Void)? = nil) {
        configure(apiKey: apiKey, customerId: customerId, appVersion: appVersion) {result in
            completion?(self.isSetup && self.isValidResult(result))
        }
    }

    func trackLogin(_ pageTitle: String? = "login", eventProperties: [String: Any]? = nil, completion: ((Bool) -> Void)? = nil) {
        guard isSetup else {
            completion?(false)
            return
        }
        trackLogin(pageTitle, eventProperties: eventProperties) {_, response, error in
            completion?(self.isValidResponse(response, error: error, label: pageTitle ?? #function))
        }
    }
    
    func trackCheckout(orderId:  String, completion: ((Bool) -> Void)? = nil) {
        guard isSetup else {
            completion?(false)
            return
        }
        self.orderId = orderId
        trackPage("checkout", eventProperties: nil) {_, response, error in
            completion?(self.isValidResponse(response, error: error, label: #function))
        }
    }
    
    func trackLogout(_ pageTitle: String? = "logout", eventProperties: [String: Any]? = nil, completion: ((Bool) -> Void)? = nil) {
        guard isSetup else {
            completion?(false)
            return
        }
        trackLogout(pageTitle, eventProperties: eventProperties) {_, response, error in
            completion?(self.isValidResponse(response, error: error, label: pageTitle ?? #function))
        }
    }
}
