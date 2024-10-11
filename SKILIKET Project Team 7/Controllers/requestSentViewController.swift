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
        // Programar cambio de pantalla después de 5 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.changeScreen()
        }
        // Do any additional setup after loading the view.
    }
    
    func changeScreen() {
        // Asegúrate de ajustar "NextViewController" al nombre de tu controlador de vista destino
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "successIdentifier") as? successViewController {
            self.navigationController?.pushViewController(nextViewController, animated: true)
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
