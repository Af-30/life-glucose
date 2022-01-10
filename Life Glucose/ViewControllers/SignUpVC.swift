//
//  RegisterViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class SignUpVC: UIViewController {
    var message = ""
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
//    local
    @IBOutlet weak var countinueButton: UIButton!{
        didSet{
            countinueButton.setTitle("countinue".localized, for: .normal)
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet {
            emailLabel.text = "Email".localized
        }
    }
    @IBOutlet weak var phoneLabel: UILabel!{
        didSet {
            phoneLabel.text = "Phone Number".localized
        }
    }
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet {
            passwordLabel.text = "Password".localized
        }
    }
    @IBOutlet weak var comifirmPasswordLabel: UILabel!{
        didSet {
            comifirmPasswordLabel.text = "Comfirm Password".localized
        }
    }
    
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.borderColor = UIColor.systemGray.cgColor
            userImageView.layer.borderWidth = 3.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    
    @IBOutlet weak var userTypePicker: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comfirmpasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func handleDone(_ sender: Any) {
        if //let image = userImageView.image,
            //let imageData = image.jpegData(compressionQuality: 0.75),
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
                            self.message = "MissingEmail"
                        case .weakPassword:
                            self.message = "WeakPassword"
                        case .userNotFound:
                            self.message = "userNotFound"
                        case .wrongPassword:
                            self.message = "Wrong Password"
                        case .invalidEmail:
                            self.message = "invalid email"
                        case .emailAlreadyInUse:
                            self.message = "in use"
                        default:
                            self.message = "Create User Error: \(errCode.rawValue)"
                        }
                        self.emptyTexts()
                    }
                    return
                }
                if let authResult = authResult {
                    let db = Firestore.firestore()
                    user = UserModel(uid: authResult.user.uid, email: authResult.user.email!,
                                     isDoctor: self.userTypePicker.selectedSegmentIndex == 1)
                    //        let user = UserModel(phoneNumber: authResult.user.phoneNumber!, uid: authResult.user.uid, email: authResult.user.email!,
                    //   isDoctor: self.userTypePicker.selectedSegmentIndex == 1)
                    do {
                        _ = try db.collection("users").addDocument(from: user) { error in
                            if let error = error {
                                print("Registration error",error.localizedDescription)
                                return
                            }
                            if user.isDoctor {
                                let profile = DoctorModel(uid: user.uid,
                                                          firstName: "",
                                                          lastName: "",
                                                          imageUrl: "https://firebasestorage.googleapis.com/v0/b/lifeglucose.appspot.com/o/users%2Fimages-1%2010.43.53%20AM.jpeg?alt=media&token=87e276ea-d2c0-4c7a-a78a-b32631a4e0ba",
                                                          phoneNumber: "",
                                                          city: "",
                                                          gender: "",
                                                          description: "")
                                
                                do {
                                    _ = try db.collection("doctors").addDocument(from: profile) { error in
                                        if let error = error {
                                            print("Registration error",error.localizedDescription)
                                            return
                                        }
                                        doctor = profile
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeNavigationController") as? UITabBarController {
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                            
                                        }
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            } else {
                                let profile = PatientModel(uid: user.uid,
                                                           firstName: "",
                                                           lastName: "",
                                                           imageUrl: "https://firebasestorage.googleapis.com/v0/b/lifeglucose.appspot.com/o/users%2Fimages-1%2010.43.53%20AM.jpeg?alt=media&token=87e276ea-d2c0-4c7a-a78a-b32631a4e0ba",
                                                           phoneNumber: "",
                                                           city: "",
                                                           gender: "",
                                                           company: PatientCompany(firstName: "", lastName: "", phoneNumber: "", city: ""), description: "")
                                
                                do {
                                    var ref: DocumentReference!
                                    ref = try db.collection("patients").addDocument(from: profile) { error in
                                        if let error = error {
                                            print("Registration error",error.localizedDescription)
                                            return
                                        }
                                        patient = profile
                                        patient.docID = ref.documentID
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                        }
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    func emptyTexts() {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
            .self; present(alert, animated: true)
    }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
