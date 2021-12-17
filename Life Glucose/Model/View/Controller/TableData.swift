//
//  TableData.swift
//  Life Glucose
//
//  Created by grand ahmad on 26/04/1443 AH.
//

import Foundation
import UIKit
class TableData: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension TableData: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let content = cell.defaultContentConfiguration()
        
        
        cell.contentConfiguration = content
     return cell
    }
    
    
    
}
