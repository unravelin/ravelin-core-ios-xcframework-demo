import RavelinCore

struct UseRavelin {
    var core : Ravelin

    init(apiKey: String) {
        core = Ravelin.createInstance(apiKey, enableRetry: false)
     }
    
    func useCore() {
        // Setup customer info and track their login
        core.customerId = "customer0123"
        core.orderId = "web-001"
       
        core.trackLogin("loginPage")

        // Track customer moving to a new page
        core.trackPage("checkout")

        // Send a device fingerprint with a completion block (if required)
        core.trackFingerprint { (data, response, error) -> Void in
            if let error = error {
                // Handle error
                print("Ravelin error \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print("trackFingerprint: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("success")
                    print("deviceId: ", self.core.deviceId)
                }
            }
        }

        // Track a customer logout
        core.trackLogout("logoutPage")
    }
}
