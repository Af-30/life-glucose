//
//  InformationOldVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class InformationVC: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var changeView: UIView!{
            didSet{
                changeView.layer.cornerRadius = 100
//                changeView.layer.shadowOffset = CGSize(width: 5, height: 5)
                changeView.layer.shadowOpacity = 0.7
                changeView.layer.shadowRadius = 30
//                changeView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            }
        }

    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    @IBAction func saveAction(_ sender: Any) {
        guard let firstName = firstNameField.text else { return }
        guard let lastName = lastNameField.text else { return }
        guard let phoneNumber = phoneNumberField.text else { return }
        guard let city = cityField.text else { return }
        guard let gender = genderField.text else { return }
        
        Activity.showIndicator(parentView: self.view, childView: self.activityIndicator)
        let db = Firestore.firestore()
        let updatedProfile = PatientModel(uid: patient.uid,
                                          firstName: firstName,
                                          lastName: lastName,
                                          imageUrl: patient.imageUrl,
                                          phoneNumber: phoneNumber,
                                          city: city,
                                          gender: gender,
                                          company: PatientCompany(firstName: "", lastName: "", phoneNumber: "", city: ""), description: "")
        do {
            try db.collection("patients").document(patient.docID!).setData(from: updatedProfile, merge: true) { error in
                if let error = error {
                    fatalError()
                }
                print("updated profile")
                patient = updatedProfile
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                self.navigationController?.popViewController(animated: true)
                //self.navigationController?.dismiss(animated: true, completion: nil)
            }
        } catch {
            fatalError()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNameField.text = patient.firstName
        lastNameField.text = patient.lastName
//        imageUrl.text = patient.imageUrl
        phoneNumberField.text = patient.phoneNumber
        cityField.text = patient.city
        genderField.text = patient.gender
    }
    
    func updateProfile() {
        
    }
    
}
