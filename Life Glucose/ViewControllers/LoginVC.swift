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
//    local
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "Email".localized
        }
    }
    
    @IBOutlet weak var iconButton: UIButton!
    
    @IBAction func iconAction(_ sender: AnyObject){
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "key.fill") {
                sender.setImage(image, for: .normal)
            }
        }else{
            if let image = UIImage(systemName: "key.fill"){
                sender.setImage(image, for: .normal)
            }
        
            }
        }
        
    
    
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet{
            passwordLabel.text = "Password".localized
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.layer.shadowOpacity = 0.7
            loginButton.layer.shadowRadius = 30

            loginButton.setTitle("Login".localized, for: .normal)
        }
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var massige = ""
    //var user: UserModel!
    
    override func viewDidLoad() {
        passwordTextField.rightView = iconButton
               passwordTextField.rightViewMode = .whileEditing
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func patientLogin(_ sender: Any) {
        emailTextField.text = "patient@patient.com"
        passwordTextField.text = "123456"
    }
    @IBAction func patient1Login(_ sender: Any) {
        emailTextField.text = "patient1@patient.com"
        passwordTextField.text = "123456"
    }
    @IBAction func patient2Login(_ sender: Any) {
        emailTextField.text = "patient2@patient.com"
        passwordTextField.text = "123456"
    }
    
    @IBAction func doctorLogin(_ sender: Any) {
        emailTextField.text = "doctor@doctor.com"
        passwordTextField.text = "123456"
    }
    @IBAction func doctor1Login(_ sender: Any) {
        emailTextField.text = "doctor1@doctor.com"
        passwordTextField.text = "123456"
    }
    @IBAction func doctor2Login(_ sender: Any) {
        emailTextField.text = "doctor2@doctor.com"
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
                                try user = doc.data(as: UserModel.self)
                                
                                if user.isDoctor {
                                    db.collection("doctors").whereField("uid", isEqualTo: user.uid).getDocuments { snapshot, error in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            return
                                        }
                                        if let doc = snapshot?.documents.first {
                                            do {
                                                try doctor = doc.data(as: DoctorModel.self)
                                                
                                                if let url = URL(string: doctor.imageUrl) {
                                                    DispatchQueue.global().async {
                                                        if let data = try? Data(contentsOf: url) {
                                                            DispatchQueue.main.async {
                                                                if let downloadedImage = UIImage(data: data) {
                                                                    profileImage = downloadedImage
                                                                    
                                                                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeNavigationController") as? UITabBarController {
                                                                        vc.modalPresentationStyle = .fullScreen
                                                                        self.present(vc, animated: true, completion: nil)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                } else {
                                    print("NOTT DCOOTOOR")
                                    db.collection("patients").whereField("uid", isEqualTo: user.uid).getDocuments { snapshot, error in
                                        if let error = error {
                                            fatalError(error.localizedDescription)
                                            
                                        }
                                        
                                        if let doc = snapshot?.documents.first {
                                            do {
                                                try patient = doc.data(as: PatientModel.self)
                                                
                                                if let url = URL(string: patient.imageUrl) {
                                                    DispatchQueue.global().async {
                                                        if let data = try? Data(contentsOf: url) {
                                                            DispatchQueue.main.async {
                                                                if let downloadedImage = UIImage(data: data) {
                                                                    profileImage = downloadedImage
                                                                    
                                                                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                                                                        vc.modalPresentationStyle = .fullScreen
                                                                        self.present(vc, animated: true, completion: nil)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
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
