//
//  LoginViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//


import UIKit
import Firebase
import FirebaseAuth
class LoginVC: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var massige = ""
    //var user: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func patient(_ sender: Any) {
        emailTextField.text = "patient@patient.com"
        passwordTextField.text = "123456"
    }
    
    @IBAction func doctor(_ sender: Any) {
        emailTextField.text = "doctor@doctor.com"
        passwordTextField.text = "123456"
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
                if let result = authResult {
                    let db = Firestore.firestore()
                    db.collection("users").whereField("uid", isEqualTo: result.user.uid).getDocuments { snapshot, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        if let doc = snapshot?.documents.first {
                            do {
                                try currentUser = doc.data(as: UserModel.self)
                                if currentUser.isDoctor {
                                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeNavigationController") as? UINavigationController {
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                        
                                    }
                                } else {
                                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                    }
                                }
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                            
                        }
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
