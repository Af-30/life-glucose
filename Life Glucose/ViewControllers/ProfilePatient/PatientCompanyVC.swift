//
//  InformationOldVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class PatientCompanyVC: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    @IBAction func saveAction(_ sender: Any) {
        guard let firstName = firstNameField.text else { return }
        guard let lastName = lastNameField.text else { return }
        guard let phoneNumber = phoneNumberField.text else { return }
        guard let city = cityField.text else { return }
        
        Activity.showIndicator(parentView: self.view, childView: self.activityIndicator)
        let db = Firestore.firestore()
        let updatedCompany = PatientCompany(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, city: city)
        patient.company = updatedCompany
        do {
            try db.collection("patients").document(patient.docID!).setData(from: patient, merge: true) { error in
                if let error = error {
                    fatalError()
                }
                print("updated profile")
                
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                //self.navigationController?.popViewController(animated: true)
                self.navigationController?.dismiss(animated: true, completion: nil)
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
        phoneNumberField.text = patient.phoneNumber
        cityField.text = patient.city
    }
    
    
    
}
