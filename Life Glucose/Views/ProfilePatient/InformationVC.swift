//
//  InformationVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 29/05/1443 AH.
//

import UIKit

class InformationVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var dataLabel: UIStackView!
//    @IBOutlet weak var textField: UITextField!
    struct Information {
        var name: String
    }
    let tableInformation: [Information] = [
        Information(name: "Name:"),
        Information(name: "Age:"),
        Information(name: "Gander:"),
        Information(name: "Phone Number:"),
        Information(name: "Email:")
    ]

  
    override func viewDidLoad() {
        super.viewDidLoad()
//       textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

}

extension InformationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableInformation[indexPath.row].name
        return cell
        
    }
    
}
