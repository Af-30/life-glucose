//
//  DataDrTableVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 20/05/1443 AH.
//

import UIKit
import Firebase

class ProfileDoctorVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    let tableItems: [ProfileTableItem] = [
        ProfileTableItem(title: "Account", imageName: "person"),
        ProfileTableItem(title: "Patients", imageName: "person.fill.badge.plus"),
        ProfileTableItem(title: "Privacy and noficitions", imageName: "bell.slash"),
        ProfileTableItem(title: "Log Out", imageName: "trash")
    ]

    var selectedDataDr:DoctorModel?
    var selectedDataImage:UIImage?
    let imagePickerController = UIImagePickerController()
    
    //    this table data dr vc
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            profileImage.layer.borderColor = UIColor.systemGreen.cgColor
            profileImage.layer.borderWidth = 3.0
            profileImage.layer.masksToBounds = true
            profileImage.isUserInteractionEnabled = true
            profileImage.backgroundColor = .cyan
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
}


//extension image
extension ProfileDoctorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func selectImage() {
        showAlert()
    }
    //    func alert image
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

//extension table view data dr type datasource and delegate
extension ProfileDoctorVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if tableItems[indexPath.row].imageName == "trash" {
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
        case "Privacy and noficitions":
            performSegue(withIdentifier: "profileToPrivacy", sender: nil)
        case "Log Out":
            logout()
        default: fatalError()
            
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

