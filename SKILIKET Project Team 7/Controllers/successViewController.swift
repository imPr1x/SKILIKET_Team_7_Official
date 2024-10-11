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

        // Do any additional setup after loading the view.
    }
    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.clipsToBounds = true
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
