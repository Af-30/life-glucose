//
//  NewChatViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 02/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class NewChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var doctors: [DoctorModel] = []
    var patients: [PatientModel] = []
    var selectedPatient: PatientModel?
    var selectedDoctor: DoctorModel?
    var selectedConversation: ConversationModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newToChat" {
            let vc = segue.destination as! ChatViewController
            vc.conversation = self.selectedConversation
        }
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        patients.removeAll()
        doctors.removeAll()
        db.collection(user.isDoctor ? "patients" : "doctors").getDocuments { snapshot, error in
            if let error = error {
                fatalError()
            }
            guard let docs = snapshot?.documents else { return }
            for doc in docs {
                do {
                    if user.isDoctor {
                        try self.patients.append(doc.data(as: PatientModel.self)!)
                    } else {
                        try self.doctors.append(doc.data(as: DoctorModel.self)!)
                    }
                } catch {
                    fatalError()
                }
            }
            self.tableView.reloadData()
        }
    }
    
    private func search() {
        //searchBar.
    }
}

extension NewChatViewController: UISearchBarDelegate {
    //search
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user.isDoctor ? patients.count : doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if user.isDoctor {
            cell.textLabel?.text = patients[indexPath.row].fullName
        } else {
            cell.textLabel?.text = doctors[indexPath.row].fullName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var ids: [String] = [user.uid]
        if user.isDoctor {
            selectedPatient = patients[indexPath.row]
            ids.append(selectedPatient!.uid)
        } else {
            selectedDoctor = doctors[indexPath.row]
            ids.append(selectedDoctor!.uid)
        }
        // create new conversation and segue to chat details
        let db = Firestore.firestore()
        var conversations: [ConversationModel] = []
        db.collection("conversations").whereField("users", arrayContains: ids).getDocuments { snapshot, error in
            if let error = error {
                fatalError()
            }
            guard let docs = snapshot?.documents else { return }
            for doc in docs {
                do {
                    try conversations.append(doc.data(as: ConversationModel.self)!)
                } catch {
                    fatalError()
                }
            }
            if conversations.count != 0 {
                self.selectedConversation = conversations.first!
                self.performSegue(withIdentifier: "newToChat", sender: self)
            } else {
                // create new conversation
                var users: [ConversationUserModel] = []
                if user.isDoctor {
                    users.append(ConversationUserModel(uid: self.selectedPatient!.uid,
                                                       name: self.selectedPatient!.fullName))
                    users.append(ConversationUserModel(uid: doctor.uid,
                                                       name: doctor.fullName))
                } else {
                    users.append(ConversationUserModel(uid: self.selectedDoctor!.uid,
                                                       name: self.selectedDoctor!.fullName))
                    users.append(ConversationUserModel(uid: patient.uid,
                                                       name: patient.fullName))
                }
                var conversation = ConversationModel(usersIDs: ids, users: users, messages: [])
                do {
                    var ref: DocumentReference!
                    ref = try db.collection("conversations").addDocument(from: conversation) { error in
                        if let error = error {
                            fatalError()
                        }
                        conversation.docID = ref.documentID
                        self.selectedConversation = conversation
                        self.performSegue(withIdentifier: "newToChat", sender: self)
                    }
                } catch {
                    fatalError()
                }
                
            }
            //self.tableView.reloadData()
        }
    }
}
