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
    @DocumentID var docID: String?
    var uid: String
    var fasting: Bool
    var date: Date
    var created: Date
    var value: Int
//    var result: String
}

class CalculatorGlucoseVC: UIViewController {
//    local
    @IBOutlet weak var dayLabel: UILabel!{
        didSet {
            dayLabel.text = "Day".localized
        }
    }
    @IBOutlet weak var glucoseLabel: UILabel!{
        didSet{
            glucoseLabel.text = "Input number Glucose".localized
        }
    }

    var editEntry: Bool = false
    var entry: EntryModel?
    
    @IBOutlet weak var fastingPicker: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberGlucoseTextField: UITextField!
    @IBOutlet weak var calculatorGlucoseButton: UIButton!
//    local
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if editEntry {
            saveButton.setTitle("Update", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
        }
        guard let entry = entry else { return }
        self.fastingPicker.selectedSegmentIndex = entry.fasting ? 0 : 1
        self.numberGlucoseTextField.text = "\(entry.value)"
        self.datePicker.date = entry.date
    }
    
    @IBAction func calculatorGlucoseAction(_ sender: Any) {
        guard let strValue = numberGlucoseTextField.text else { return }
        guard let intValue = Int(strValue) else { return }
        resultLabel.text = getResult(intValue, fasting: fastingPicker.selectedSegmentIndex == 0)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let strValue = numberGlucoseTextField.text else { return }
        guard let intValue = Int(strValue) else { return }
        
        let updatedEntry = EntryModel(uid: user.uid,
                               fasting: fastingPicker.selectedSegmentIndex == 0,
                               date: datePicker.date,
                                      created: editEntry ? entry!.created : Date(), value: intValue)
        
        let db = Firestore.firestore()
        
        if editEntry {
            guard let entry = entry else {
                return
            }

            do {
                try db.collection("patients/\(patient.docID!)/entries/").document(entry.docID!).setData(from: updatedEntry, merge: true, completion: { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("updated")
                    self.navigationController?.popViewController(animated: true)
                })
                    
                    // clear fields
                } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            do {
                try db.collection("patients/\(patient.docID!)/entries").addDocument(from: updatedEntry) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("ADDED")
                    self.navigationController?.popViewController(animated: true)
//                    self.dismiss(animated: true, completion: nil)
                    // clear fields
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }

    }
    
    
}


func getResult(_ glucose:Int, fasting: Bool) -> String {
    if fasting {
        switch glucose {
        case 0...50:
            return "very dangerous low"
        case 50...80:
            return "very low"
        case 80...130:
            return "normal"
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
