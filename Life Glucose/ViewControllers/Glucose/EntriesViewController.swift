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

 
    @IBOutlet weak var imageView: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    var entries: [EntryModel] = []
    var selectedEntry: EntryModel?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var glucoseLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        
        //fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "newEntry", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "editEntry" {
                let vc = segue.destination as! CalculatorGlucoseVC
                vc.entry = selectedEntry
                vc.editEntry = true
            }else {
                let vc = segue.destination as! CalculatorGlucoseVC
                vc.entry = nil
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
                self.entries.sort(by: { $0.created > $1.created })
                self.tableView.reloadData()
                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
            }
        }
    }
//    this func delete in firebase and file patients in docId 
    private func deleteItem(index: Int) {
        Activity.showIndicator(parentView: view, childView: activityIndicator)
        let db = Firestore.firestore()
        db.collection("patients/\(patient.docID!)/entries").document(entries[index].docID!).delete(completion: { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
            self.fetchData()
        })
    }
    


}
extension EntriesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntriesTableViewCell
//        cell.textLabel?.text = "\(resultLabel[indexPath.row])"
        cell.nameLabel.text = patient.firstName
        cell.glucose.text = "\(entries[indexPath.row].value)"
        cell.resultLabel.text = getResult(entries[indexPath.row].value, fasting: entries[indexPath.row].fasting)
        cell.imageViewCell.image = profileImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = entries[indexPath.row]
        performSegue(withIdentifier: "editEntry", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
//use delete in table view 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteItem(index: indexPath.row)
        }
    }
    
    
    
    
}
