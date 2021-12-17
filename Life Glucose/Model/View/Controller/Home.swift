//
//  Menu.swift
//  Life Glucose
//
//  Created by grand ahmad on 26/04/1443 AH.
//

import Foundation
import UIKit
class Home: UIViewController{
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    @IBOutlet weak var menue: UIView!
    var menuOut = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func menuTabbed(_ sender: Any) {
    if menuOut == false {
        leading.constant = 150
        trailing.constant = -150
        menuOut = true
    }else{
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
    }
}
