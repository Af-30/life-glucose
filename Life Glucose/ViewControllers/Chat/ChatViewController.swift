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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageChat: UIImageView!
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var conversation: ConversationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imageChat
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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
                guard let conversation = self.conversation else {
                    return
                }

                let otherProfile = conversation.users.first(where: { $0.uid != user.uid })!
                if self.imageChat.image == nil {
                    let imgURL = otherProfile.imageUrl
                    self.imageChat.loadImageUsingCache(with: imgURL)
                    self.nameLabel.text = otherProfile.name
                }
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
        let message = conversation!.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
        cell.getMessageDesgin(sender: message.sender == user.uid ? .me : .other)
        cell.messageLabel.text = message.content
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
