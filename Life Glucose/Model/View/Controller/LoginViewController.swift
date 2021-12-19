//
//  LoginViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//


import UIKit
import Firebase
class LoginViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
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
                            self.errorLabel.text =  "userNotFound"
                        case .wrongPassword:
                            self.errorLabel.text = "Wrong Password"
                        case .invalidEmail:
                            self.errorLabel.text = "invalid email"
                        case .emailAlreadyInUse:
                            self.errorLabel.text = "in use"
                        default:
                            self.errorLabel.text = "Create User Error: \(errCode.rawValue)"
                            
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
    
    
}
