//
//  RegisterViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 01/10/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    
    

    @IBOutlet weak var checkboxButton: UIButton!
    //Elementos
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    
    
    // Acción cuando el usuario toca el botón de registro
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Primero, verifica que todos los campos estén llenos.
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(withTitle: "Error", message: "Please fill in all fields.")
            return
        }

        // Segundo, verifica que las contraseñas coincidan.
        guard password == confirmPassword else {
            showAlert(withTitle: "Error", message: "Passwords do not match.")
            return
        }

        // Tercero, verifica que el checkbox esté seleccionado.
        guard checkboxButton.isSelected else {
            showAlert(withTitle: "Error", message: "You must agree to the Terms & Conditions.")
            return
        }

        // Si no hay errores, realizar el segue.
        performSegue(withIdentifier: "confirmEmailSegue", sender: self)
    }



    // Función para mostrar alertas
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    //Logica para ver que las contrasenas coincidan.

    
    //Cambiar de imagen Admin/User
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmEmailSegue" {
            if let confirmVC = segue.destination as? confirmEmailViewController {
                confirmVC.email = emailTextField.text // Pasando el email al siguiente ViewController
            }
        }
    }

    

}
