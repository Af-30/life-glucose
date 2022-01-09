//
//  HomeViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//

import UIKit
import Firebase

struct ProfileTableItem {
    var title: String
    var imageName: String
    //    var color: UIColor
}

class ProfileUserVC: UIViewController {
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var phoneUser: UILabel!
    let imagePickerController = UIImagePickerController()
    
    let tableItems: [ProfileTableItem] = [
        ProfileTableItem(title: "Account", imageName: "person"),
        ProfileTableItem(title: "Acompany Patient", imageName: "person.fill.badge.plus"),
        ProfileTableItem(title: "Information App", imageName: "book"),
        ProfileTableItem(title: "Log Out", imageName: "rectangle.portrait.and.arrow.right")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet {
            profileImageView.layer.borderColor = UIColor.systemGreen.cgColor
            profileImageView.layer.borderWidth = 3.0
            profileImageView.layer.masksToBounds = true
            profileImageView.isUserInteractionEnabled = true
            profileImageView.backgroundColor = .black
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            profileImageView.addGestureRecognizer(tabGesture)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        profileImageView.image = profileImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameUser.text = patient.firstName + " " + patient.lastName
        phoneUser.text = patient.phoneNumber
    }
    
    func logout() {
        print("LOGOUT")
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingViewController") as? LandingVC {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } catch  {
            print("ERROR in signout",error.localizedDescription)
        }
        
    }

    
    func uploadImage() {
        if let image = profileImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75) {
            
            //Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            
            
            let storageRef = Storage.storage().reference(withPath: "users/\(user.uid)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: updloadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL { url, error in
                    if let url = url {
                        let db = Firestore.firestore()
                        
                        patient.imageUrl = url.absoluteString
                        profileImage = image
                        do {
                            try db.collection("patients").document(patient.docID!).setData(from: patient, merge: true) { error in
                                if let error = error {
                                    print("FireStore Error",error.localizedDescription)
                                } else {
                                    //                                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                }
                            }
                        } catch {
                            fatalError()
                        }
                        
                    }
                }
            }
        }
        
    }
    
    
    //    @IBAction func handleLogout(_ sender: Any) {
    //        print("LOGOUT")
    //        do {
    //            try Auth.auth().signOut()
    //            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingViewController") as? LandingVC {
    //                vc.modalPresentationStyle = .fullScreen
    //                self.present(vc, animated: true, completion: nil)
    //            }
    //        } catch  {
    //            print("ERROR in signout",error.localizedDescription)
    //        }
    //
    //    }
}
//extension UIImagePickerController
extension ProfileUserVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        profileImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
        // upload
        uploadImage()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
// extension tableview
extension ProfileUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableItems[indexPath.row].title == "Log Out" {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.text = tableItems[indexPath.row].title
        }else{
            cell.textLabel?.text = tableItems[indexPath.row].title
        }
        
        if tableItems[indexPath.row].imageName == "rectangle.portrait.and.arrow.right" {
            cell.imageView?.tintColor = .systemRed
            cell.imageView?.image = UIImage(systemName: tableItems[indexPath.row].imageName)
        }else{
            cell.imageView?.image = UIImage(systemName: tableItems[indexPath.row].imageName)
        }
        //        cell.textLabel?.text = tableItems[indexPath.row].title
        //        cell.imageView?.image = UIImage(systemName: tableItems[indexPath.row].imageName)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableItems[indexPath.row].title {
        case "Account":
            performSegue(withIdentifier: "profileToAccount", sender: nil)
        case "Acompany Patient":
            performSegue(withIdentifier: "profileToAcompany", sender: nil)
        case "Information App":
            performSegue(withIdentifier: "informApp", sender: nil)
        case "Log Out":
            logout()
        default: fatalError()
            
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

