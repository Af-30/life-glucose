//
//  WelcomeVC.swift
//  Life Glucose
//
//  Created by grand ahmad on 24/05/1443 AH.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.bool(forKey: "firstRun") {
            defaults.set(true, forKey: "firstRun")
        } else {
            self.performSegue(withIdentifier: "landingToHome", sender: nil)
        }
    }
    
}
