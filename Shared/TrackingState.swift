import Foundation

enum TrackingState {
    case setup, login, checkout, logout, complete
    
    var description: String {
        switch self {
        case .setup:
            "Setup"
        case .login:
            "Login"
        case .checkout:
            "Checkout"
        case .logout:
            "Logout"
        case .complete:
            "Completed"
        }
    }
    
    var next: TrackingState {
        switch self {
        case .setup:
            .login
        case .login:
            .checkout
        case .checkout:
            .logout
        case .logout:
            .complete
        case .complete:
            .complete
        }
    }
    
    var enabled: Bool {
        switch self {
        case .setup, .login, .checkout, .logout:
            true
        case .complete:
            false
        }
    }
    
    func track(sdkHelper: SDKHelper, completion: ((Bool) -> Void)? = nil) {
        switch self {
        case .setup:
            completion?(true)
        case .login:
            sdkHelper.trackLogin(completion: completion)
        case .checkout:
            sdkHelper.trackCheckout(orderId: "order-01234", completion: completion)
        case .logout:
            sdkHelper.trackLogout { success in
                completion?(success)
                sdkHelper.logEventsData()
            }
        case .complete:
            logInfo("complete")
            completion?(true)
        }
    }
}
