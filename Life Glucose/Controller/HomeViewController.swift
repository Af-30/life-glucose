//
//  HomeViewController.swift
//  Life Glucose
//
//  Created by grand ahmad on 15/05/1443 AH.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    //    @IBOutlet weak var leading: NSLayoutConstraint!
    //    @IBOutlet weak var trailing: NSLayoutConstraint!

//    @IBOutlet weak var menue: UIView!
//    var menuOut = false
//
//    @IBAction func menuTabbed(_ sender: Any) {
//        if menuOut == false {
//            leading.constant = 150
//            trailing.constant = -150
//            menuOut = true
//        }else{
//            leading.constant = 0
//            trailing.constant = 0
//            menuOut = false
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.backgroundColor = .cyan
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingViewController") as? LandingViewController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } catch  {
            print("ERROR in signout",error.localizedDescription)
        }
        
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return 0
    }
    
    
}

