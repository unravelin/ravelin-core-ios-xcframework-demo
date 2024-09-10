//
//  ViewController.swift
//  RavelinCoreDemo

import UIKit

// to assist with early stage development/debug
// execute 'python3 simple_server.py' in a terminal session
// and use "local" as the apiKey
let apiKey = "local"
// for further development and release, replace with your Ravelin Publishable API Key
// let apiKey = "publishable_key_live_----"

class ViewController: UIViewController {
    
    private var sdkHelper: SDKHelper?
    private var activityIndicatorViewController: ActivityIndicatorViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSDKHelper()
    }
    
    func setupSDKHelper() {
        guard sdkHelper == nil else {
            logInfo("sdkHelper already initialised")
            return
        }
        addActivityIndicator()
        sdkHelper = SDKHelper(apiKey: apiKey, customerId: "cust-01234", appVersion: Bundle.main.version) {_ in
            self.removeActivityIndicator()
        }
    }
    
    func trackLogin() {
        guard let sdkHelper else {
            logInfo("sdkHelper not initialised")
            return
        }
        addActivityIndicator()
        sdkHelper.trackLogin {_ in
            self.removeActivityIndicator()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        trackLogin()
    }
    
    func addActivityIndicator() {
        addChildViewController(ActivityIndicatorViewController()) { viewController in
            self.activityIndicatorViewController = viewController as? ActivityIndicatorViewController
        }
    }
    
    func removeActivityIndicator(after: Double = 0.5) {
        removeChildViewController(activityIndicatorViewController, after: after) {
            self.activityIndicatorViewController = nil
        }
    }
}
