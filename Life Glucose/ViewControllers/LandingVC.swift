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
//        try! Auth.auth().signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("LANDING")
        
        if let usr = Auth.auth().currentUser {
            print(usr.uid)
            let db = Firestore.firestore()
            db.collection("users").whereField("uid", isEqualTo: usr.uid).getDocuments { snapshot, error in
                if let error = error {
                    fatalError(error.localizedDescription)
                    return
                }
                if let doc = snapshot?.documents.first {
                    do {
                        try user = doc.data(as: UserModel.self)
                        
                        if user.isDoctor {
                            db.collection("doctors").whereField("uid", isEqualTo: user.uid).getDocuments { snapshot, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }
                                if let doc = snapshot?.documents.first {
                                    do {
                                        try doctor = doc.data(as: DoctorModel.self)
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeNavigationController") as? UITabBarController {
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        } else {
                            print("NOTT DCOOTOOR")
                            db.collection("patients").whereField("uid", isEqualTo: user.uid).getDocuments { snapshot, error in
                                if let error = error {
                                    fatalError(error.localizedDescription)
                                    return
                                }
                                
                                if let doc = snapshot?.documents.first {
                                    do {
                                        try patient = doc.data(as: PatientModel.self)
                                        
                                        if let url = URL(string: patient.imageUrl) {
                                            DispatchQueue.global().async {
                                                if let data = try? Data(contentsOf: url) {
                                                    DispatchQueue.main.async {
                                                        if let downloadedImage = UIImage(data: data) {
                                                            profileImage = downloadedImage
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
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
