import RavelinCore

struct UseRavelin {
    var core: Ravelin

    init(apiKey: String) {
        core = Ravelin.createInstance(apiKey, enableRetry: false)
     }
    
    func useCore() {
        // setup customer info
        core.customerId = "customer0123"
        // Send a device fingerprint with a completion block (if required)
        core.trackFingerprint { (data, response, error) -> Void in
            if let error = error {
                // handle error
                print("Ravelin error \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("success - deviceId: ", self.core.deviceId)
                    // track a customer login
                    core.trackLogin("loginPage")
                    core.orderId = "web-001"
                    // track customer moving to a new page
                    core.trackPage("checkout")
                    // track a customer logout
                    core.trackLogout("logoutPage")
                } else {
                    print("trackFingerprint: \(httpResponse.statusCode)")
                }
            }
        }
    }
}
