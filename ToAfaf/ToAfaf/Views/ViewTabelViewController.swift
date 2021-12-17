import UIKit
class ViewTabelViewController: UIViewController {
    @IBOutlet weak var drsTableView: UITableView!
    var arrOfDr: [DoctorData] = []
    var name = ""
    var age = ""
    var job = ""
    var salory = ""
    var decreption = ""
    var expertise = ""
    var language = ""
    var address = ""
    var doctor = DoctorData(name: "", age: "", job: "", salory: "", decreption: "", expertise: "", language: "", address: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        drsTableView.delegate = self
        drsTableView.dataSource = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendTo = segue.destination as? ViewDesplayController
        sendTo?.doctor.name = name
        sendTo?.doctor.age = age
        sendTo?.doctor.job = job
        sendTo?.doctor.salory = salory
        sendTo?.doctor.decreption = decreption
        sendTo?.doctor.expertise = expertise
        sendTo?.doctor.language = language
        sendTo?.doctor.address = address
    }
}
extension ViewTabelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfDr.count
    }
}
extension ViewTabelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drsTableView.dequeueReusableCell(withIdentifier: "drCell", for: indexPath)
        var contant = cell.defaultContentConfiguration()
        contant.text = arrOfDr[indexPath.row].name
        cell.contentConfiguration = contant
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name = arrOfDr[indexPath.row].name
        age = arrOfDr[indexPath.row].age
        job = arrOfDr[indexPath.row].job
        salory = arrOfDr[indexPath.row].salory
        decreption = arrOfDr[indexPath.row].decreption
        expertise = arrOfDr[indexPath.row].expertise
        language = arrOfDr[indexPath.row].language
        address = arrOfDr[indexPath.row].address
        performSegue(withIdentifier: "toDesplay", sender: self)
    }
}
