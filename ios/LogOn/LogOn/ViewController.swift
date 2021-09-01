//
//  ViewController.swift
//  LogOn
//
//  Created by 村上幸雄 on 2021/08/27.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController, ASAuthorizationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(pushApplebutton), for: .touchUpInside)
        view.addSubview(button)
        
        let topConstraint = NSLayoutConstraint.init(item: button,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .top,
                                                    multiplier: 1.0,
                                                    constant: 50.0)
        let leftConstraint = NSLayoutConstraint.init(item: button,
                                                     attribute: .left,
                                                     relatedBy: .equal,
                                                     toItem: view,
                                                     attribute: .left,
                                                     multiplier: 1.0,
                                                     constant: 50.0)
        NSLayoutConstraint.activate([topConstraint, leftConstraint])
    }

    @objc func pushApplebutton() {
        print(#function)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            if let name = appleIDCredential.fullName?.givenName,
               let emailAddr = appleIDCredential.email {
                print("userID: \(userID), name: \(name), emailAddr: \(emailAddr)")
            } else {
                print("userID: \(userID)")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

