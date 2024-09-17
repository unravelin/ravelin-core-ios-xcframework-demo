//
//  ContentView.swift
//  RavelinCoreDemoSUI

import SwiftUI
import RavelinCore

// to assist with early stage development/debug
// execute 'python3 simple_server.py' in a terminal session
// and use "local" as the apiKey
let apiKey = "local"
// replace with your Ravelin Publishable API Key
//let apiKey = "publishable_key_live_----"

struct ContentView: View {
    @State private var trackingSet = TrackingSet.none
    let ravelinSDK = RavelinSDK.shared
    
    var body: some View {
        VStack {
            HStack {
                Button("Setup") {
                    ravelinSDK.configure(apiKey: apiKey, customerId: "cust-0123", appVersion: Bundle.main.version) { success in
                        if success {
                            ravelinSDK.logDeviceId()
                            ravelinSDK.logEventsData(label: "Fingerprint")
                            self.trackingSet.insert(.setup)
                        }
                    }
                }.disabled(trackingSet.contains(.setup))
                Image(systemName: trackingSet.contains(.setup) ? "checkmark.seal" : "seal")
                    .imageScale(.large)
            }
            HStack {
                Button("Login") {
                    ravelinSDK.deleteEventsData()
                    ravelinSDK.trackLogin { success in
                        if success {
                            ravelinSDK.logEventsData(label: "Login")
                            self.trackingSet.insert(.login)
                        }
                    }
                }.disabled(trackingSet.contains(.login))
                Image(systemName: trackingSet.contains(.login) ? "checkmark.seal" : "seal")
                    .imageScale(.large)
            }
            HStack {
                Button("Checkout") {
                    ravelinSDK.deleteEventsData()
                    ravelinSDK.trackCheckout(orderId: "order-01234") {success in
                        if success {
                            ravelinSDK.logEventsData(label: "Checkout")
                            self.trackingSet.insert(.checkout)
                        }
                    }
                }.disabled(trackingSet.contains(.checkout))
                Image(systemName: trackingSet.contains(.checkout) ? "checkmark.seal" : "seal")
                    .imageScale(.large)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
