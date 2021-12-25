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

struct DataUser {
    var name = ""
    var userName =  ""
    var numberiphone = 0
    var email = ""
    var age = 0
    var imageUrl = ""
    

    
    
    init(dict:[String:Any]) {
        if let age = dict["age"] as? Int,
           let name = dict["name"] as? String,
           let numberiphone = dict["number"] as? Int,
           let imageUrl = dict["imageUrl"] as? String,
           let email = dict["email"] as? String {
            self.age = age
            self.name = name
            self.numberiphone = numberiphone
            self.email = email
            self.imageUrl = imageUrl
        }
}
}
//struct Profile {
//    var name: String
//    var number: Int
//    var imageProfile: String
//    var email:String
//}

