import RavelinCore

extension RavelinSDK {
    
    var isSetup: Bool {
        guard apiKey != nil else {
            logError("apiKey has not been set")
            return false
        }
        return true
    }
    
    func isValidResponse(_ response: URLResponse?, error: Error?, label: String = "response") -> Bool {
        if let error {
            logError("\(label): didFailWithError \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    func isValidResult(_ result: TrackResult, label: String = "result") -> Bool {
        switch result {
        case .success():
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
