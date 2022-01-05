//
//  ChatViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 02/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ChatViewController: UIViewController {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var conversation: ConversationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        let db = Firestore.firestore()
//        db.collection("conversations").whereField("users", arrayContains: [user.uid]). { snapshot, error in
//            if let error = error {
//                fatalError()
//            }
//            do {
//                try self.conversation = snapshot?.documents.first!.data(as: ConversationModel.self)
//            } catch {
//                fatalError()
//            }
//
//        }
    }
    
    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("conversations").document(conversation!.docID!).addSnapshotListener { snapshot, error in
            print("snapshot")
            if let error = error {
                fatalError()
            }
            
            guard let doc = snapshot else { return }
            do {
                try self.conversation = doc.data(as: ConversationModel.self)
                self.tableView.reloadData()
            } catch {
                fatalError()
            }
            
        }
    }
    
    @IBAction func sendAction(_ sender: Any) {
        guard let message = messageField.text else { return }
        let msg = MessageModel(content: message, sender: user.uid, seen: false)
        conversation!.messages.append(msg)
        
        let db = Firestore.firestore()
        do {
            try db.collection("conversations").document(conversation!.docID!).setData(from: conversation, merge: true) { error in
                if let error = error {
                    fatalError()
                }
                //self.fetchData()
            }
        } catch {
            
        }
        
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversation!.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = conversation?.messages[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
