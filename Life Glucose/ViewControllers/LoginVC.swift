//
//  LoginViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//


import UIKit
import Firebase
class LoginVC: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var massige = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            self.massige =  "userNotFound"
                            self.emptyTexts()
                        case .wrongPassword:
                            self.massige = "Wrong Password"
                            self.emptyTexts()
                        case .invalidEmail:
                            self.massige = "invalid email"
                            self.emptyTexts()
                        case .emailAlreadyInUse:
                            self.massige = "in use"
                            self.emptyTexts()
                        default:
                            self.massige = "Create User Error: \(errCode.rawValue)"
                            self.emptyTexts()
                        }
                    }
                    return
                }
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func emptyTexts() {
        let alert = UIAlertController(title: "Error", message: massige, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
            .self; present(alert, animated: true)
    }
   
}
