//
//  ConversationModel.swift
//  Life Glucose
//
//  Created by grand ahmad on 01/06/1443 AH.
//

import Foundation
import FirebaseFirestoreSwift

struct ConversationUserModel: Codable {
    var uid: String
    var name: String
    var imageUrl: String
}

struct ConversationModel: Codable {
    @DocumentID var docID: String?
    var usersIDs: [String]
    var users: [ConversationUserModel]
    var messages: [MessageModel]
}
