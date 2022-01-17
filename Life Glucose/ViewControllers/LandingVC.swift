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
import UserNotifications

class LandingVC: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    //    local
    @IBOutlet weak var welcomeLabel: UILabel! {
    didSet {
            welcomeLabel.text = "Welcome To App Life Glucose".localized
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet {
            loginButton.setTitle("Login".localized, for: .normal)
            }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet {
            registerButton.setTitle("register".localized, for: .normal)
            }
    }
    
    @IBOutlet weak var languageSegmentControl: UISegmentedControl! {
        didSet {
            if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
                switch lang {
                case "ar":
                    languageSegmentControl.selectedSegmentIndex = 0
                case "en":
                    languageSegmentControl.selectedSegmentIndex = 1
                default:
                    let localLang =  Locale.current.languageCode
                    if localLang == "ar" {
                        languageSegmentControl.selectedSegmentIndex = 0
                    }else {
                        languageSegmentControl.selectedSegmentIndex = 1
                    }
                    
                }
                
            }else {
                let localLang =  Locale.current.languageCode
                if localLang == "ar" {
                    languageSegmentControl.selectedSegmentIndex = 0
                }else {
                    languageSegmentControl.selectedSegmentIndex = 1
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        
        
//        content
        let content = UNMutableNotificationContent()
        content.title = "Life Glucose"
        content.body = "Welcome to App Life Glucose"
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-Notifiction temp"
        
//        trigger
        let date = Date(timeIntervalSinceNow: 20)
        let dateComponnent = Calendar.current.dateComponents([.year , .month ,.day ,.hour , .minute , .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponnent, repeats: false)
        
        
        let requset = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        center.add(requset) { (error) in
        if error != nil {
            print(error)
        
        }
        //        try! Auth.auth().signOut()
    }
        
        
    }
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        if let lang = sender.titleForSegment(at:sender.selectedSegmentIndex)?.lowercased() {
            UserDefaults.standard.set(lang, forKey: "currentLanguage")
            Bundle.setLanguage(lang)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                print(lang)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("LANDING")
        
        if let usr = Auth.auth().currentUser {
            // activity
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
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
                                        
                                        if let url = URL(string: doctor.imageUrl) {
                                            DispatchQueue.global().async {
                                                if let data = try? Data(contentsOf: url) {
                                                    DispatchQueue.main.async {
                                                        if let downloadedImage = UIImage(data: data) {
                                                            profileImage = downloadedImage
                                                            
                                                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeNavigationController") as? UITabBarController {
                                                                vc.modalPresentationStyle = .fullScreen
                                                                self.present(vc, animated: true, completion: nil)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
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
                                                            
                                                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                                                                vc.modalPresentationStyle = .fullScreen
                                                                self.present(vc, animated: true, completion: nil)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
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
            //                }
        }
    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: "")
    }
    
}

