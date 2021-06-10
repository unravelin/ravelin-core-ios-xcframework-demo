//
//  ViewController.swift
//  RavelinCoreDemoPods

import UIKit

class ViewController: UIViewController {

    private var useRavelin = UseRavelin(apiKey: "publishable_key_xxxx")
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        useRavelin.useCore()
    }
}
