//
//  DataDr.swift
//  Life Glucose
//
//  Created by grand ahmad on 20/05/1443 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct DoctorModel: Codable {
    @DocumentID var docID: String?
    var uid: String
    var firstName: String
    var lastName: String
    var imageUrl: String
    var phoneNumber: String
    var city: String
    var gender: String
    var description: String
    //var createdAt:Timestamp?
    
    
}
