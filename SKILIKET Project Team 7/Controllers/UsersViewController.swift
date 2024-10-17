//
//  UsersViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 04/10/24.
//

import UIKit

class UsersViewController: UIViewController {

    var loggedUser: User?  // Usuario autenticado

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        
        // Deshabilita los campos de texto por defecto
        disableTextFields()
        
        // Carga los datos del usuario autenticado desde UserDefaults
        loadAuthenticatedUser()
        
        // Ocultar los elementos de la interfaz inicialmente
        profileImageView.isHidden = true
        usernameLabel.isHidden = true
        
        setupHideKeyboardOnTap()
    }
    
    func loadAuthenticatedUser() {
        if let userData = UserDefaults.standard.data(forKey: "authenticatedUser") {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: userData)
                loggedUser = user
                
                // Llena los campos con los datos del usuario autenticado
                usernameLabel.text = user.username
                emailTextField.text = user.mail
                fullnameTextField.text = user.fullname
                ageTextField.text = "\(user.age)"
                addressTextField.text = user.address
                
                // Muestra la imagen del usuario si tiene una URL de perfil
                if let url = URL(string: user.profileImageURL) {
                    loadImage(from: url, into: profileImageView)
                }
                
                // Una vez que se carguen los datos, muestra los elementos
                DispatchQueue.main.async {
                    self.profileImageView.isHidden = false
                    self.usernameLabel.isHidden = false
                }
            } catch {
                print("Error al decodificar el usuario: \(error)")
            }
        } else {
            print("No hay usuario autenticado guardado en UserDefaults.")
        }
    }

    @IBAction func editEmailTapped(_ sender: UIButton) {
        emailTextField.isEnabled = true
        emailTextField.becomeFirstResponder()
        saveButton.isHidden = false // Mostrar el botón de guardar
    }

    @IBAction func editFullnameTapped(_ sender: UIButton) {
        fullnameTextField.isEnabled = true
        fullnameTextField.becomeFirstResponder()
        saveButton.isHidden = false
    }

    @IBAction func editAgeTapped(_ sender: UIButton) {
        ageTextField.isEnabled = true
        ageTextField.becomeFirstResponder()
        saveButton.isHidden = false
    }

    @IBAction func editAddressTapped(_ sender: UIButton) {
        addressTextField.isEnabled = true
        addressTextField.becomeFirstResponder()
        saveButton.isHidden = false
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveChanges()
        dismissEditing()
    }

    func saveChanges() {
        // Aquí implementarías cómo se guardan los cambios en los campos de texto
        print("Cambios guardados")
    }

    func dismissEditing() {
        view.endEditing(true)  // Esto ocultará el teclado
        saveButton.isHidden = true  // Oculta el botón de guardar después de guardar
        disableTextFields()  // Deshabilita los campos de texto nuevamente
    }

    func disableTextFields() {
        emailTextField.isEnabled = false
        fullnameTextField.isEnabled = false
        ageTextField.isEnabled = false
        addressTextField.isEnabled = false
    }

    func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Esto asegura que otros controles como botones todavía puedan responder a los toques.
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true) // Esto hará que la vista o cualquier subvista que esté editando termine de editar, ocultando el teclado.
    }

    // Función para descargar y mostrar imágenes desde una URL
    func loadImage(from url: URL, into imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}

