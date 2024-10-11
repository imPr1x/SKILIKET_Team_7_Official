//
//  requestSentViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 10/10/24.
//

import UIKit

class requestSentViewController: UIViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleScreenChange()
    }

    
    // Función para cambiar de pantalla después de un delay
    func scheduleScreenChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            // Asegúrate de que self aún existe
            self?.performSegue(withIdentifier: "successIdentifier", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successIdentifier" {
            if segue.destination is successViewController {
            }
        }
    }

}
