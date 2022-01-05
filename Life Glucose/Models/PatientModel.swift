//
//  PatientModel.swift
//  Life Glucose
//
//  Created by grand ahmad on 24/05/1443 AH.
//

import Foundation
import FirebaseFirestoreSwift

struct PatientCompany: Codable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var city: String
}

struct PatientModel: Codable {
    @DocumentID var docID: String?
    var uid: String
    var firstName: String
    var lastName: String
    var imageUrl: String
    var phoneNumber: String
    //var doctors: [String] // doctors uids
    var city: String
    var gender: String
    var company: PatientCompany
    var description: String
    //var createdAt:Timestamp?
    
    
}
