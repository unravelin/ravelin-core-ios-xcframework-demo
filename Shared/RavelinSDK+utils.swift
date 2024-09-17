import RavelinCore

extension RavelinSDK {
    
    var isSetup: Bool {
        guard apiKey != nil else {
            logError("apiKey has not been set")
            return false
        }
        // could also confirm availability of other parameters, such as customerId, if appropriate
        return true
    }
    // convert TrackResponse's response and error parameters to Bool
    func isValidResponse(_ response: URLResponse?, error: Error?, label: String = "response") -> Bool {
        if let error {
            logError("\(label): didFailWithError \(error.localizedDescription)")
            return false
        }
        // could also handle response here e.g. check http status codes
        // although SDK will have already flagged inappropriate responses as errors
        return true
    }
    // convert TrackResult to Bool
    // n.b. TrackResult currently only returned by configure
    func isValidResult(_ result: TrackResult, label: String = "result") -> Bool {
        switch result {
        case .success:
            return true
        case .failure(let error):
            logError("\(label): \(error)")
            return false
        }
    }
    
    func logDeviceId(label: String = "deviceId") {
        if let deviceId {
            logInfo("\(label):\n\(deviceId)")
        }
    }
    
    func logEventsData(label: String = "eventsJson") {
        if let eventsData,
           let jsonString = String(data: eventsData, encoding: .utf8) {
            logInfo("\(label):\n\(jsonString)")
        }
    }
}
