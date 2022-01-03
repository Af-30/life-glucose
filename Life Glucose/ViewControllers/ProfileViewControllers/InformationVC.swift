//
//  InformationVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 29/05/1443 AH.
//

import UIKit

class InformationVC: UIViewController {
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
    @IBOutlet weak var writeTextFeild: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
