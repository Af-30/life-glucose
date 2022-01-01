//
//  PatientModel.swift
//  Life Glucose
//
//  Created by grand ahmad on 24/05/1443 AH.
//

import Foundation
import FirebaseFirestoreSwift

struct PatientModel: Codable {
    @DocumentID var docID: String?
    var uid: String
    var firstName: String
    var lastName: String
    //var imageUrl: String
    var phoneNumber: String
    //var doctors: [String] // doctors uids
    //var city: String
    //var gender: String
    //var description = ""
    //var createdAt:Timestamp?
    
    
}
