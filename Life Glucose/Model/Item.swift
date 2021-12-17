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
    var logninCoding:LogninCoding
}

struct DataUserName {
    var name: String
    var userName:String
    var email:String
    var password:String
    var age:Int
    var numnberIphone:Int
}

struct DataDoctor{
    var name:String
    var age:Int
    var number:Int
    var city:String
    var yearEmplyment:String
    var house: String
    var email:String
    var workTime:Int
    var check:Int
    var numberDay:Int
}


struct LogninCoding {
var nameDoctor: String
    var coding: String
}