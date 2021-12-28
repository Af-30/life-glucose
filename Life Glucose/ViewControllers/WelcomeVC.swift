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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.bool(forKey: "firstRun") {
            defaults.set(true, forKey: "firstRun")
        } else {
            self.performSegue(withIdentifier: "landingToHome", sender: nil)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
