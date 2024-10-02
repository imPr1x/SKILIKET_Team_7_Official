//
//  RegisterViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 01/10/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var circleView: UIView!
    
    @IBAction func type(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(named: "user"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "admin"), for: .normal)
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func checkbox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.layer.masksToBounds = true

        // Do any additional setup after loading the view.
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
