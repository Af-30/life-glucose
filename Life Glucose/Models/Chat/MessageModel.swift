//
//  MessageModel.swift
//  Life Glucose
//
//  Created by grand ahmad on 01/06/1443 AH.
//

import Foundation

struct MessageModel: Codable {
    var id: UUID = UUID()
    var content: String
    var sender: String
}
