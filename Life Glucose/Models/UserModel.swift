//
//  Item.swift
//  Life Glucose
//
//  Created by grand ahmad on 12/04/1443 AH.
//

import Foundation
import Firebase
//struct Item {
//    var dataUserName:DataUser?
//    var dataDoctor:DataDoctor?
//}

struct UserModel {
    var id = ""
    var name = ""
    var userName =  ""
    var phoneNumber = 0
    var email = ""
    var age = 0
    var imageUrl = ""
    var gender = ""
    var city = ""


    
    
    init(dict:[String:Any]) {
        if let id = dict["id"] as? String,
            let age = dict["age"] as? Int,
           let name = dict["name"] as? String,
           let phoneNumber = dict["phoneNumber"] as? Int,
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
