//
//  LandingViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class LandingVC: UIViewController {
    
    //var user: UserModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let usr = Auth.auth().currentUser {
            
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: usr.uid).getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let doc = snapshot?.documents.first {
                    do {
                        try currentUser = doc.data(as: UserModel.self)
                        if currentUser.isDoctor {
                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeNavigationController") as? UINavigationController {
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                        } else {
                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                    
                }
            }
                                             
            
            
//
//            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
//            }
        }
    }
}
