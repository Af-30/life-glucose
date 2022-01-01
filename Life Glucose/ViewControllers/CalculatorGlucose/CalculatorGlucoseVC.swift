//
//  CalculatorGlucoseVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 25/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

struct EntryModel: Codable {
    var uid: String
    var fasting: Bool
    var date: Date
    var value: Int
}

class CalculatorGlucoseVC: UIViewController {
    
    var entry: EntryModel?
    
    @IBOutlet weak var fastingPicker: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberGlucoseTextField: UITextField!
    @IBOutlet weak var calculatorGlucoseButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func calculatorGlucoseAction(_ sender: Any) {
        guard let strValue = numberGlucoseTextField.text else { return }
        guard let intValue = Int(strValue) else { return }
        resultLabel.text = getResult(intValue)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let strValue = numberGlucoseTextField.text else { return }
        guard let intValue = Int(strValue) else { return }
        
        let entry = EntryModel(uid: user.uid,
                               fasting: fastingPicker.selectedSegmentIndex == 0,
                               date: datePicker.date,
                               value: intValue)
        
        let db = Firestore.firestore()
        do {
            try db.collection("patients/\(patient.docID!)/entries").addDocument(from: entry) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("ADDED")
                // clear fields
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        
    }
    
    func getResult(_ glucose:Int) -> String {
        if fastingPicker.selectedSegmentIndex == 0 {
            switch glucose {
            case 0...50:
                return "very dangerous low"
            case 50...80:
                return "very low"
            case 80...130:
                return "normal rate"
            case 130...160:
                return "high"
            case 160...240:
                return "very high"
            case 240...300:
                return "dangerous high"
            case 300...500:
                return "very dangerous high"
            default:
                return "ERROR"
            }
        } else {
            switch glucose {
            case 0...50:
             return "very dangerous low"
               case 50...80:
                return "low"
            case 80...130:
                return "normal rate"
            case 130...180:
                return "normal"
            case 180...200:
                return "very very high"
            case 200...240:
                return "very high"
            case 240...300:
                return "dangerous high"
            case 300...500:
                return "veryn dangerous high"
            default:
                return "ERROR"
            }
        }
        return "Az"
    }
}

