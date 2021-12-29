//
//  PatientModel.swift
//  Life Glucose
//
//  Created by grand ahmad on 24/05/1443 AH.
//

import Foundation

struct PatientModel: Codable {
    var id = ""
    var name = ""
    var phoneNumber = ""
    var email = ""
    var age = ""
    var imageUrl = ""
    var gender = ""
    var city = ""
    var DoctorId = ""
    
    
    
    
    init(dict:[String:Any]) {
        if let id = dict["id"] as? String,
           let age = dict["age"] as? String,
           let name = dict["name"] as? String,
           let phoneNumber = dict["phoneNumber"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           let email = dict["email"] as? String {
            self.id = id
            self.age = age
            self.name = name
            self.phoneNumber = phoneNumber
            self.email = email
            self.imageUrl = imageUrl
        }
        
    }
}
