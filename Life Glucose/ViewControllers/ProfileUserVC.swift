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
}

class ProfileUserVC: UIViewController {
    let imagePickerController = UIImagePickerController()
//    var selectProfile :ProfileTV?
    
    let tableItems: [ProfileTableItem] = [
        ProfileTableItem(title: "Account", imageName: "person"),
        ProfileTableItem(title: "Acompany Patient", imageName: "person.fill.badge.plus"),
        ProfileTableItem(title: "Privacy and noficitions", imageName: "bell.slash")
    ]
    
    @IBOutlet weak var NameLabel: UILabel!{
        didSet{
            NameLabel.layer.shadowColor = UIColor.darkGray.cgColor
            NameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
            NameLabel.layer.shadowRadius = 10.0
            NameLabel.layer.shadowOpacity = 8.0

        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!{
        didSet {
            profileImage.layer.borderColor = UIColor.systemGreen.cgColor
            profileImage.layer.borderWidth = 3.0
            profileImage.layer.masksToBounds = true
            profileImage.isUserInteractionEnabled = true
            profileImage.backgroundColor = .black
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
            
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            profileImage.addGestureRecognizer(tabGesture)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    }
    @IBAction func handleLogout(_ sender: Any) {
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
}

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
        profileImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableItems[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: tableItems[indexPath.row].imageName)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
//
