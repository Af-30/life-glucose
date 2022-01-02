//
//  EntriesViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 28/05/1443 AH.
//

import UIKit
import Firebase
import SwiftUI

class EntriesViewController: UIViewController {

    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    var entries: [EntryModel] = []
    var selectedEntry: EntryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        
        //fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "editEntry" {
                let vc = segue.destination as! CalculatorGlucoseVC
                vc.entry = selectedEntry
                vc.editEntry = true
            }else {
                let vc = segue.destination as! CalculatorGlucoseVC
                vc.editEntry = false
            }
        }
    }
    
    private func fetchData() {
        Activity.showIndicator(parentView: view, childView: activityIndicator)
        let db = Firestore.firestore()
        
        // load entries from database
        
        db.collection("patients/\(patient.docID!)/entries").getDocuments(source: .server) { snapshot, error in
            if let error = error {
                return
            }
            if let docs = snapshot?.documents {
                self.entries.removeAll()
                for doc in docs {
                    do {
                        try self.entries.append(doc.data(as: EntryModel.self)!)
                    } catch {
                        fatalError()
                    }
                }
                self.tableView.reloadData()
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
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
//        cell.textLabel?.text = "\(resultLabel[indexPath.row])"
        cell.textLabel?.text = "Glucose:  \(entries[indexPath.row].value)"
        cell.imageView?.image = UIImage(systemName: "checkmark")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = entries[indexPath.row]
        performSegue(withIdentifier: "editEntry", sender: nil)
    }
    
    
}
