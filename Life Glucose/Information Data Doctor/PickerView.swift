//
//  PickerView.swift
//  Life Glucose
//
//  Created by grand ahmad on 12/04/1443 AH.
//

import Foundation
import UIKit
class PickerView: UIViewController{
    @IBOutlet weak var codingPicker: UIPickerView!
    @IBOutlet weak var userPicker: UIPickerView!
    @IBOutlet weak var resultPicker: UILabel!
    var codeing = ["...","LAG345JAZ","LGG345RUD","LGG345JED","LFG345DMM","LFG345MED"]
    var user = ["...","New","DR","PA"]
    override func viewDidLoad() {
        super.viewDidLoad()
        codingPicker.delegate = self
        codingPicker.dataSource = self
        userPicker.delegate = self
        userPicker.dataSource = self
        
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
        return 1
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return codeing.count
        } else{
            return user.count
    }
        } 
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
           
            return codeing[row]
        } else{
            return user[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let code = codeing[codingPicker.selectedRow(inComponent: 0)]
        let use = user[userPicker.selectedRow(inComponent: 0)]
        resultPicker.text = "\(code) and \(use)"
    }
}
