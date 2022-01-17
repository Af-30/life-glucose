//
//  EntriesViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 28/05/1443 AH.
//

import UIKit
import Firebase

class EntriesViewController: UIViewController {

//    @IBOutlet weak var viewChart: UIView!{
//        didSet{
//            viewChart.layer.cornerRadius = 100
//            viewChart.layer.shadowOpacity = 0.5
//            viewChart.layer.shadowRadius = 30
//        }
//    }
//
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
        
//        fetchData()
//        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
    }
    
//    private func createChart() {
//        var chart = BarChartView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        var chartEntries = [BarChartDataEntry]()
//        for entry in entries {
//            chartEntries.append(BarChartDataEntry(x: 1, y: Double(entry.value)))
//        }
//        let set = BarChartDataSet(entries: chartEntries, label: "Glucose")
//        let data = BarChartData(dataSet: set)
//        chart.data = data
//        view.addSubview(chart)
//
//    }
    
    
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
                fatalError(error.localizedDescription)
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
                //self.createChart()
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

       
        let result = (getResult(entries[indexPath.row].value, fasting: entries[indexPath.row].fasting))
        
        switch result {
        case "normal".localized :
            cell.resultLabel.textColor = UIColor.systemGreen
        case "normal rate".localized :
            cell.resultLabel.textColor = UIColor.systemGreen
            
        case "high".localized :
            cell.resultLabel.textColor = UIColor.systemRed
        case "very high".localized :
            cell.resultLabel.textColor = UIColor.systemRed
        case "very very high".localized :
            cell.resultLabel.textColor = UIColor.systemRed
        case "dangerous high".localized :
            cell.resultLabel.textColor = UIColor.systemRed
        case "very dangerous high".localized :
            cell.resultLabel.textColor = UIColor.systemRed
            
        case "low" :
            cell.resultLabel.textColor = UIColor.systemYellow
        case "very low".localized :
            cell.resultLabel.textColor = UIColor.systemYellow
        case "very dangerous low".localized :
            cell.resultLabel.textColor = UIColor.systemYellow
            
            
        default :
            cell.resultLabel.textColor = UIColor.systemPurple
        }
        
        cell.resultLabel.text = getResult(entries[indexPath.row].value, fasting: entries[indexPath.row].fasting)
        
        cell.nameLabel.text = patient.firstName
        cell.glucose.text = "\(entries[indexPath.row].value)"
        
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
