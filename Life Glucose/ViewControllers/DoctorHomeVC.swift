//
//  DataDrTableVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 20/05/1443 AH.
//

import UIKit
import Firebase
class DoctorHomeVC: UIViewController {
    var menuOut = true
    var doctors = [DoctorModel]()
    var selectedDataDr:DoctorModel?
    var selectedDataImage:UIImage?
    let imagePickerController = UIImagePickerController()
    
    //    outershell profile image
    @IBOutlet weak var outershellView: UIView!{
        didSet{
            outershellView.layer.cornerRadius = 25
        }
    }
    //    this table data dr vc
    @IBOutlet weak var drsTableView: UITableView!{
        didSet{
            drsTableView.delegate = self
            drsTableView.dataSource = self
            drsTableView.register(UINib(nibName: "DataDrCell", bundle: nil), forCellReuseIdentifier: "DataDrCell")
        }
    }
    //    relationshep menu and leading tralling view
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
//        getDoctors()
    }
}

//func getDoctors() {
//    let ref = Firestore.firestore()
//    ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
//        if let error = error {
//            print("DB ERROR Posts",error.localizedDescription)
//        }
//        if let snapshot = snapshot {
//            snapshot.documentChanges.forEach { diff in
//                let doc = diff.document.data()
//                switch diff.type {
//                case .added :
//                    if let userId = doc["doctorId"] as? String {
//                        ref.collection("users").document(userId).getDocument { userSnapshot, error in
//                            if let error = error {
//                                print("ERROR user Data",error.localizedDescription)
//
//                            }
//                            if let userSnapshot = userSnapshot,
//                               let userData = userSnapshot.data(){
//                                let user = UserModel(dict:userData)
//                                let doctor = DoctorModel(dict:doc,id:diff.document.documentID,user:user)
//                                self.doctors.insert(doctor, at: 0)
//                                DispatchQueue.main.async {
//                                    self.drsTableView.reloadData()
//                                }
//
//                            }
//                        }
//                    }
//                case .modified:
//                    let drId = diff.document.documentID
//                    if let currentPost = self.doctors.first(where: {$0.id == drId}),
//                       let updateIndex = self.doctors.firstIndex(where: {$0.id == drId}){
//                        let newDr = DoctorModel(dict:doc, id: drId, user: currentPost.user)
//                        self.doctors[updateIndex] = newDr
//                        DispatchQueue.main.async {
//                            self.drsTableView.reloadData()
//                        }
//                    }
//                case .removed:
//                    let doctorId = diff.document.documentID
//                    if let deleteIndex = self.doctors.firstIndex(where: {$0.id == doctorId}){
//                        self.doctors.remove(at: deleteIndex)
//                        DispatchQueue.main.async {
//                            self.drsTableView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

//extension image
extension DoctorHomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        profileDrImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//extension table view data dr type datasource and delegate
extension DoctorHomeVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataDrCell") as! DataDrCell
        return cell.configure(with: doctors[indexPath.row])
    }
}
extension DoctorHomeVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DataDrCell
        selectedDataImage = cell.dataCellImage.image
        selectedDataDr = doctors[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == doctors[indexPath.row].id{
            performSegue(withIdentifier: "toDataVC", sender: self)
        }
    }
}

