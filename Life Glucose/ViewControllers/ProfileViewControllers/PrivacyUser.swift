//
//  PrivacyUser.swift
//  Life Glucose
//
//  Created by grand ahmad on 25/05/1443 AH.
//

import UIKit

class PrivacyUser: UIViewController {
//    Model
    struct TablePrivacy {
        var title: String
        var descrtion: String
    }
    
    @IBOutlet weak var tableView: UITableView!
    let tablePrivacyes: [TablePrivacy] = [
        TablePrivacy(title: "Show notifications", descrtion: "message notifications"),
        TablePrivacy(title: "Message Preview", descrtion: "Preview message text in new message notifications"),
        TablePrivacy(title: "Automatic account deletion", descrtion: "If you are absent for 12 months"),
        TablePrivacy(title: "Preview the features of the facilities ", descrtion: "Preview all facility data"),
        TablePrivacy(title: "Show Phone Number", descrtion: "Preview another mobile number?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchAction(_ sender: Any) {
    }
    

}
extension PrivacyUser: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablePrivacyes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tablePrivacyes[indexPath.row].title
        cell.textLabel?.text = tablePrivacyes[indexPath.row].descrtion
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
