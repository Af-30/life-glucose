//
//  Item.swift
//  Life Glucose
//
//  Created by grand ahmad on 12/04/1443 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct UserModel: Codable {
    //var phoneNumber: String
    @DocumentID var docID: String?
    var uid: String
    var email: String
    var isDoctor: Bool
}
