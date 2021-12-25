//
//  RegisterViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    var massige = ""
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.borderColor = UIColor.systemGreen.cgColor
            userImageView.layer.borderWidth = 3.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var iphoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comfirmpasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func handleDone(_ sender: Any) {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
           let name = nameTextField.text,
           let username = usernameTextField.text,
           let iphoneNumber = iphoneNumberTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text,
           let comfirmPassword = comfirmpasswordTextField.text,
           password == comfirmPassword {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .missingEmail:
                            self.massige = "MissingEmail"
                            self.emptyTexts()
                        case .weakPassword:
                            self.massige = "WeakPassword"
                            self.emptyTexts()
                        case .userNotFound:
                            self.massige = "userNotFound"
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
                if let authResult = authResult {
                    let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                        if let error = error {
                            print("Registration Storage Error",error.localizedDescription)
                            return
                        }
                        storageRef.downloadURL { url, error in
                            if let error = error {
                                print("Registration Storage Download Url Error",error.localizedDescription)
                                return
                            }
                            if let url = url {
                                print("URL",url.absoluteString)
                                let db = Firestore.firestore()
                                let userData: [String:String] = [
                                    "id":authResult.user.uid,
                                    "name":name,
                                    "email":email,
                                    "imageUrl":url.absoluteString
                                ]
                                db.collection("users").document(authResult.user.uid).setData(userData) { error in
                                    if let error = error {
                                        print("Registration Database error",error.localizedDescription)
                                        return
                                    } else {
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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func selectImage() {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galaryAction = UIAlertAction(title: "Photo Library", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .destructive) { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getImage( from sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return}
        userImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
