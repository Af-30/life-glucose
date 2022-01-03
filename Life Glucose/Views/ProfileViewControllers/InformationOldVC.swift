//
//  InformationOldVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class InformationOldVC: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var AgeField: UITextField!
    
    
    @IBAction func saveAction(_ sender: Any) {
        guard let firstName = firstNameField.text else { return }
        Activity.showIndicator(parentView: self.view, childView: self.activityIndicator)
        let db = Firestore.firestore()
        
        let updatedProfile = PatientModel(uid: patient.uid,
                                          firstName: firstName,
                                          lastName: lastNameField.text!,
                                          imageUrl: patient.imageUrl,
                                          phoneNumber: phoneNumberField.text!,
                                          city: cityField.text!,
                                          gender: genderField.text!)
        do {
            try db.collection("patients").document(patient.docID!).setData(from: updatedProfile, merge: true) { error in
                if let error = error {
                    fatalError()
                }
                print("updated profile")
                patient = updatedProfile
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
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
        
        firstNameField.text = patient.firstName
        lastNameField.text = patient.lastName
        // fill all fields from patient profile
    }
    
    func updateProfile() {
        
    }
    


}
