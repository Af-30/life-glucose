//
//  Item.swift
//  Life Glucose
//
//  Created by grand ahmad on 12/04/1443 AH.
//

import Foundation
struct Item {
    var dataUserName:DataUserName
    var dataDoctor:DataDoctor
}

struct DataUserName {
    var name: String
    var userName:String
    var numnberIphone:Int
    var email:String
    var password:String
    var age:Int
}

struct DataDoctor{
    var name:String
    var age:Int
    var numnberIphone:Int
    var city:String
    var yearEmplyment:String
    var house: String
    var email:String
    var workTime:Int
    var check:Int
    var numberDay:Int

}

struct Profile {
    var name: String
    var number: Int
    var imageProfile: String
    var email:String
}


