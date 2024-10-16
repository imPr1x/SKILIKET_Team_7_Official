//
//  successViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 04/10/24.
//

import UIKit

class successViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
        
    @IBAction func continueButtonTapped(_ sender: UIButton) {

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularButton()
    }
    
    func setupCircularButton() {
        continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor).isActive = true
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.clipsToBounds = true
    }
    
}
