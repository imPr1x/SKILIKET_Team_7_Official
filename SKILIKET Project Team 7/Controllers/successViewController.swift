//
//  successViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 04/10/24.
//

import UIKit

class successViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularButton()
        // Do any additional setup after loading the view.
    }
    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.clipsToBounds = true
    }
    
}
