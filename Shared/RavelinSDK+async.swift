import RavelinCore

extension RavelinSDK {
    @available(iOS 13.0.0, *)
    static func configure(apiKey: String, customerId: String?, appVersion: String?, completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                try await RavelinSDK.shared.configure(apiKey: apiKey, customerId: customerId, appVersion: appVersion)
                completion?(true)
            } catch (let error) {
                logError("configure: \(error)")
                completion?(false)
            }
        }
    }
    
    @available(iOS 13.0.0, *)
    static func trackLogin(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                try await RavelinSDK.shared.trackLoginEvent("loginPage")
                completion?(true)
            } catch (let error) {
                logError("trackLogin: \(error)")
                completion?(false)
            }
        }
    }
    
    @available(iOS 13.0.0, *)
    static func trackLogout(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                try await RavelinSDK.shared.trackLogoutEvent("logoutPage")
                completion?(true)
            } catch (let error) {
                logError("trackLogout: \(error)")
                completion?(false)
            }
        }
    }

    
    @available(iOS 13.0.0, *)
    static func trackCheckout(orderId: String, completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                try await RavelinSDK.shared.trackPageLoadedEvent("Checkout page")
                completion?(true)
            } catch (let error) {
                logger.error("trackCheckout: \(error)")
                completion?(false)
            }
        }
    }
    
    @available(iOS 13.0.0, *)
    static func trackPageLoaded(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                try await RavelinSDK.shared.trackPageLoadedEvent("Page Loaded")
                completion?(true)
            } catch (let error) {
                logger.error("trackPageLoaded: \(error)")
                completion?(false)
            }
        }
    }
}
