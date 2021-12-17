import UIKit
class ViewDesplayController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var salory: UILabel!
    @IBOutlet weak var decreption: UILabel!
    @IBOutlet weak var expertise: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var address: UILabel!
    var doctor = DoctorData(name: "", age: "", job: "", salory: "", decreption: "", expertise: "", language: "", address: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = doctor.name
        age.text = doctor.age
        job.text = doctor.job
        salory.text = doctor.salory
        decreption.text = doctor.decreption
        expertise.text = doctor.expertise
        language.text = doctor.language
        address.text = doctor.address
    }
}
