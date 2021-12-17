//
//  TableViewDoctors.swift
//  Life Glucose
//
//  Created by grand ahmad on 26/04/1443 AH.
//

import Foundation
import UIKit
class TableViewDoctors: UIViewController{
//    var selectInformation: Information!
    
@IBOutlet weak var tableViewDoctors: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDoctors.delegate = self
        tableViewDoctors.dataSource = self
    }
}

extension TableViewDoctors: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
       3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else if section == 1 {
            return 3
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let content = cell.defaultContentConfiguration()
        
        cell.contentConfiguration = content
     return cell
    }

}
