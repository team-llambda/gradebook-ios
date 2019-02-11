//
//  OnboardingViewController.swift
//  BSD Gradebook iOS
//
//  Created by Alan Chu on 2/6/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import UIKit
import EDUPointServices

import os.log

class OnboardingViewController: UIViewController {
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBAction func textFieldDidPressReturn(_ sender: UITextField) {
        switch sender {
        case usernameInput:
            self.passwordInput.becomeFirstResponder()
        case passwordInput:
            self.didPressSubmitButton(sender)
        default:
            return
        }
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIControl) {
        sender.resignFirstResponder()
        signIn()
    }
    
    func signIn() {
        guard let username = usernameInput.text, !username.isEmpty,
            let password = passwordInput.text, !password.isEmpty else { return }
        
        services = PXPWebServices(userID: username, password: password, edupointBaseURL: URL(string: "https://wa-bsd405-psv.edupoint.com/")!)
        
        services.processWebRequest(methodToRun: .childList, type: Child.self).then { child in
            os_log("ChildList method success: %@", child)
            
            DispatchQueue.main.async {
                self.present(self.storyboard!.instantiateViewController(withIdentifier: "gradebook_nav"), animated: true, completion: nil)
            }
        }.catch { error in
            os_log("ChildList method failed: %@", log: .default, type: .error, error as NSError)
        }.always {
            
        }
    }
}
