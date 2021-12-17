import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var job: UITextField!
    @IBOutlet weak var salory: UITextField!
    @IBOutlet weak var decreption: UITextField!
    @IBOutlet weak var expertise: UITextField!
    @IBOutlet weak var language: UITextField!
    @IBOutlet weak var address: UITextField!
    
    var doctor = DoctorData(name: "", age: "", job: "", salory: "", decreption: "", expertise: "", language: "", address: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        age.delegate = self
        job.delegate = self
        salory.delegate = self
        decreption.delegate = self
        expertise.delegate = self
        language.delegate = self
        address.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendTo = segue.destination as? ViewTabelViewController
        sendTo?.arrOfDr.append(doctor)
//        if let text = age.text{
//            arrOfDr.append(doctor)
//           let indexPath = IndexPath(row: arrOfDr.count - 1 , section: 0)
//            drsTableView.beginUpdates()
//            drsTableView.insertRows(at: [indexPath], with: .automatic)
//            drsTableView.endUpdates()
//         }
    }
    @IBAction func inputDrName(_ sender: Any) {
        if let drName = name.text {
            doctor.name = drName
        }
    }
    @IBAction func inputDrAge(_ sender: Any) {
        if let drAge = age.text {
            doctor.age = drAge
        }
    }
    @IBAction func inputDrJob(_ sender: Any) {
        if let drJob = job.text {
            doctor.job = drJob
        }
    }
    @IBAction func inputDrSalory(_ sender: Any) {
        if let drSalory = salory.text {
            doctor.salory = drSalory
        }
    }
    @IBAction func inputDrDescreption(_ sender: Any) {
        if let drDescreption = decreption.text {
            doctor.decreption = drDescreption
        }
    }
    @IBAction func inputDrExpertise(_ sender: Any) {
        if let drExpertise = expertise.text {
            doctor.expertise = drExpertise
        }
    }
    @IBAction func inputDrLanguage(_ sender: Any) {
        if let drLanguage = language.text {
            doctor.language = drLanguage
        }
    }
    @IBAction func inputDrAddress(_ sender: Any) {
        if let drAddress = address.text {
            doctor.address = drAddress
        }
    }
    @IBAction func done(_ sender: Any) {
    
        if doctor.name == "" || doctor.age == "" || doctor.address == "" || doctor.language == "" || doctor.expertise == "" || doctor.decreption == "" || doctor.salory == "" || doctor.job == "" {
            emptyTexts()
        }else {
            performSegue(withIdentifier: "toTableView", sender: self)
        }
    }
    
    func emptyTexts() {
        let alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
            .self; present(alert, animated: true)
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

