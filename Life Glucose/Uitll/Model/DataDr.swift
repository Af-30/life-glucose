//
//  DataDr.swift
//  Life Glucose
//
//  Created by grand ahmad on 20/05/1443 AH.
//

import Foundation
import Firebase
struct DataDr{
    var name = ""
    var imageUrl = ""
    var age = 0
    var number = 0
    var city = ""
    var email = ""
    var description = ""
    var user: User
    var createdAt:Timestamp?
    
    init(dict:[String:Any],age:Int,user:User) {
        if let name = dict["name"] as? String,
           let city = dict["city"] as? String,
           let number = dict["number"] as? Int,
           let imageUrl = dict["imageUrl"] as? String,
           let email = dict["email"] as? String,
           let description = dict["description"] as? String,
           let createdAt = dict["createdAt"] as? Timestamp{
            self.name = name
            self.city = city
            self.number = number
            self.email = email
            self.imageUrl = imageUrl
            self.description = description
            self.createdAt = createdAt
        }
            self.age = age
            self.user = user
        }
   }
