//
//  UsersViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 04/10/24.
//

import UIKit

class UsersViewController: UIViewController {
    
    
    var loggedUser: data?  // Usuario que se recibe del login
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    
    @IBAction func editEmailTapped(_ sender: UIButton) {
        emailTextField.isEnabled = true
        emailTextField.becomeFirstResponder()
        saveButton.isHidden = false // Abrir el teclado
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
    
    @IBAction func editAddressTapped(_ sender: UIButton) {        addressTextField.isEnabled = true
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
        disableTextFields()  // Opcionalmente, deshabilita los campos de texto
    }
    
    func disableTextFields() {
        // Deshabilitar los campos de texto y volverlos a su estilo de solo lectura
        emailTextField.isEnabled = false
        fullnameTextField.isEnabled = false
        ageTextField.isEnabled = false
        addressTextField.isEnabled = false
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        
        // Ocultar los elementos de la interfaz inicialmente
        profileImageView.isHidden = true
        usernameLabel.isHidden = true
        /*
         mailLabel.isHidden = true
         fullnameLabel.isHidden = true
         ageLabel.isHidden = true
         addressLabel.isHidden = true
         
         // Cargar los datos del usuario
         if let user = loggedUser {
         usernameLabel.text = user.username
         mailLabel.text = user.mail
         fullnameLabel.text = user.fullname
         ageLabel.text = "\(user.age)"
         addressLabel.text = user.address
         
         // Cargar la imagen del usuario desde la URL
         if let url = URL(string: user.profileImageURL) {
         loadImage(from: url, into: profileImageView)
         }
         
         // Mostrar los elementos de la interfaz una vez cargados los datos
         DispatchQueue.main.async {
         self.profileImageView.isHidden = false
         self.usernameLabel.isHidden = false
         self.mailLabel.isHidden = false
         self.fullnameLabel.isHidden = false
         self.ageLabel.isHidden = false
         self.addressLabel.isHidden = false
         }
         */
        setupHideKeyboardOnTap() 
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
