import RavelinCore

extension RavelinSDK {
        
    static func configure(apiKey: String, customerId: String?, appVersion: String?, completion: ((Bool) -> Void)? = nil) {
        let ravelinSDK = RavelinSDK.shared
        ravelinSDK.configure(apiKey: apiKey, customerId: customerId, appVersion: appVersion) {result in
            completion?(ravelinSDK.isSetup && ravelinSDK.isValidResult(result))
        }
    }
        
    static func trackLogin(_ pageTitle: String? = nil, eventProperties: [String: Any]? = nil, completion: ((Bool) -> Void)? = nil) {
        let ravelinSDK = RavelinSDK.shared
        let label = pageTitle ?? #function
        guard ravelinSDK.isSetup else {
            completion?(false)
            return
        }
        ravelinSDK.trackLogin(pageTitle, eventProperties: eventProperties) {_, response, error in
            completion?(ravelinSDK.isValidResponse(response, error: error, label: label))
        }
    }
    
    static func trackLogout(_ pageTitle: String? = nil, eventProperties: [String: Any]? = nil, completion: ((Bool) -> Void)? = nil) {
        let ravelinSDK = RavelinSDK.shared
        let label = pageTitle ?? #function
        guard ravelinSDK.isSetup else {
            completion?(false)
            return
        }
        ravelinSDK.trackLogout(pageTitle, eventProperties: eventProperties) {_, response, error in
            completion?(ravelinSDK.isValidResponse(response, error: error, label: label))
        }
    }
}

extension RavelinSDK {
    

    static func deleteEventsData() {
        RavelinSDK.shared.deleteEventsData()
    }
    
    static func logDeviceId(label: String = "deviceId") {
        if let deviceId = RavelinSDK.shared.deviceId {
            logInfo("\(label):\n\(deviceId)")
        }
    }
    
    static func logEventsData(label: String = "eventsJson") {
        if let eventsData = RavelinSDK.shared.eventsData,
           let jsonString = String(data: eventsData, encoding: .utf8) {
            logInfo("\(label):\n\(jsonString)")
        }
    }
}
