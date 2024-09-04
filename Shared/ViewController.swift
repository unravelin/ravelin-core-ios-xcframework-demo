//
//  ViewController.swift
//  RavelinCoreDemo

import UIKit

//let apiKey = "local_http_192.168.0.63_8080_1234"
let apiKey = "local"

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
