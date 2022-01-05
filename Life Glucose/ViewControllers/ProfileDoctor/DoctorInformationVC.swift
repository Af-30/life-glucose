//
//  InformationOldVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class DoctorInformationVC: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var AgeField: UITextField!
    
    @IBOutlet weak var desciriptionaField: UITextView!
    
    @IBAction func saveAction(_ sender: Any) {
        guard let firstName = firstNameField.text else { return }
        guard let lastName = lastNameField.text else { return }
        guard let phoneNumber = phoneNumberField.text else { return }
        guard let city = cityField.text else { return }
        guard let gender = genderField.text else { return }
        guard let description = desciriptionaField.text else { return }
        
        
        Activity.showIndicator(parentView: self.view, childView: self.activityIndicator)
        let db = Firestore.firestore()
        
        let updatedProfile = DoctorModel(uid: doctor.uid,
                                         firstName: firstName,
                                         lastName: lastName,
                                         imageUrl: doctor.imageUrl,
                                         phoneNumber: phoneNumber,
                                         city: city,
                                         gender: gender,
                                         description: description)
        
        do {
            try db.collection("doctors").document(doctor.docID!).setData(from: updatedProfile, merge: true) { error in
                if let error = error {
                    fatalError()
                }
                print("updated profile")
                doctor = updatedProfile
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                //self.navigationController?.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
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
        
        firstNameField.text = doctor.firstName
        lastNameField.text = doctor.lastName
        // fill all fields from patient profile
    }
    
    func updateProfile() {
        
    }
    


}
