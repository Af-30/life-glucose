//
//  EntriesViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 28/05/1443 AH.
//

import UIKit
import Firebase

class EntriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var entries: [EntryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        
        let db = Firestore.firestore()
        
        // load entries from database
        
        db.collection("patients/\(patient.docID!)/entries").getDocuments(source: .server) { snapshot, error in
            if let error = error {
                return
            }
            if let docs = snapshot?.documents {
                for doc in docs {
                    do {
                        try self.entries.append(doc.data(as: EntryModel.self)!)
                    } catch {
                        fatalError()
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    


}
extension EntriesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(entries[indexPath.row].value)"
        return cell
    }
    
    
}
