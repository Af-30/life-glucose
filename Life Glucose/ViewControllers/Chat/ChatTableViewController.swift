//
//  ChatViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 02/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ChatTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var conversations: [ConversationModel] = []
    var selectedConversation: ConversationModel?
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatDetails" {
            let vc = segue.destination as! ChatViewController
            vc.conversation = self.selectedConversation
        }
    }
    
    private func fetchData() {
        
        let db = Firestore.firestore()
        conversations.removeAll()
        db.collection("conversations").whereField("usersIDs", arrayContainsAny: [user.uid]).getDocuments { snapshot, error in
            if let error = error {
                fatalError()
            }
            guard let docs = snapshot?.documents else {
                self.conversations.removeAll()

                return }
            print(docs.count)
            for doc in docs {
                do {
                    try self.conversations.append(doc.data(as: ConversationModel.self)!)
                } catch {
                    fatalError()
                }
            }
            self.tableView.reloadData()
        }
    }

    @IBAction func newChatAction(_ sender: Any) {
        performSegue(withIdentifier: "newChat", sender: self)
    }

    private func deleteItem(index: Int) {
        Activity.showIndicator(parentView: view, childView: activityIndicator)
        let db = Firestore.firestore()
        db.collection("conversations").document(conversations[index].docID!).delete(completion: { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
            self.fetchData()
        })
    }
    
    
    
}

extension ChatTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].users.first(where: { $0.uid != user.uid})?.name
        cell.detailTextLabel?.text = conversations[indexPath.row].messages.last!.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedConversation = conversations[indexPath.row]
        performSegue(withIdentifier: "chatDetails", sender: self)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteItem(index: indexPath.row)
        }
    }
}
