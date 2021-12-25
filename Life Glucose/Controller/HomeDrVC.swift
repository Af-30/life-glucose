//
//  DataDrTableVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 20/05/1443 AH.
//

import UIKit

class HomeDrVC: UIViewController {
    @IBOutlet weak var outershellView: UIView!{
        didSet{
            outershellView.layer.cornerRadius = 25
        }
    }
    let imagePickerController = UIImagePickerController()
    var menuOut = true
    @IBOutlet weak var addDrTableVC: UITableView!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var tralling: NSLayoutConstraint!
    @IBAction func menuTabbed(_ sender: Any) {
          if menuOut == false {
              leading.constant = 220
              tralling.constant = -220
              menuOut = true
          }else{
              leading.constant = 0
              tralling.constant = 0
              menuOut = false
          }
    }
    @IBOutlet weak var profileDrImage: UIImageView!{
        didSet{
            profileDrImage.layer.borderColor = UIColor.systemGreen.cgColor
            profileDrImage.layer.borderWidth = 3.0
            profileDrImage.layer.masksToBounds = true
            profileDrImage.isUserInteractionEnabled = true
            
            profileDrImage.backgroundColor = .cyan
            profileDrImage.layer.masksToBounds = true
            profileDrImage.layer.cornerRadius = profileDrImage.frame.height / 2
            
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            profileDrImage.addGestureRecognizer(tabGesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }

}

extension HomeDrVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        profileDrImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
