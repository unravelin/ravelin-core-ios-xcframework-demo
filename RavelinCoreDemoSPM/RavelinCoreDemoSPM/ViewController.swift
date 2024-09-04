//
//  ViewController.swift
//  RavelinCoreDemoSPM

import UIKit

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
        sdkHelper = SDKHelper(apiKey: localApiKey, customerId: "cust-01234", appVersion: Bundle.main.version) {success in
            if !success {
                logError("sdk setup failed")
            }
            self.sdkHelper?.logEventsData(label: "Fingerprint")
            self.removeActivityIndicator()
        }
    }
    
    func trackLogin() {
        guard let sdkHelper else {
            logInfo("sdkHelper not initialised")
            return
        }
        addActivityIndicator()
        sdkHelper.deleteEventsData()
        sdkHelper.trackLogin { success in
            if !success {
                logError("sdk trackLogin failed")
            }
            sdkHelper.logEventsData(label: "Login")
            self.removeActivityIndicator()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        trackLogin()
    }
    
    func addActivityIndicator() {
        let viewController = ActivityIndicatorViewController()
        addChildiVewController(viewController)
        activityIndicatorViewController = viewController
    }
    
    func removeActivityIndicator(after: Double = 0.5) {
        removeChildViewController(self.activityIndicatorViewController, after: after) {
            self.activityIndicatorViewController = nil
        }
    }
}
