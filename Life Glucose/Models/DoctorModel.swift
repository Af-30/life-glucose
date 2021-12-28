//
//  DataDr.swift
//  Life Glucose
//
//  Created by grand ahmad on 20/05/1443 AH.
//

import Foundation
import Firebase
struct DoctorModel{
    var id = ""
    var name = ""
    var imageUrl = ""
    var age = 0
    var phoneNumber = 0
    var city = ""
    var email = ""
    var description = ""
    var gender = ""
    var user: UserModel
    var createdAt:Timestamp?
    
    init(dict:[String:Any],id:String,user: UserModel) {
        if let name = dict["name"] as? String,
           let city = dict["city"] as? String,
           let phoneNumber = dict["phoneNumber"] as? Int,
           let imageUrl = dict["imageUrl"] as? String,
           let email = dict["email"] as? String,
           let description = dict["description"] as? String,
           let age = dict["age"] as? Int,
           let createdAt = dict["createdAt"] as? Timestamp{
            self.name = name
            self.city = city
            self.phoneNumber = phoneNumber
            self.email = email
            self.imageUrl = imageUrl
            self.description = description
            self.age = age
            self.createdAt = createdAt
        }
            self.id = id
            self.user = user
        }
   }