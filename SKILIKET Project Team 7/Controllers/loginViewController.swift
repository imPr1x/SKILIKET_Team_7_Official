//
//  loginViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 03/10/24.
//

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var usersData: [User] = []
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // Verifica que los campos no estén vacíos
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(withTitle: "Error", message: "Please fill in all fields.")
            return
        }
        
        // Llama a la función que obtiene los datos y autentica el usuario
        Task {
            await fetchUserData(email: email, password: password)
        }
    }

    // Función para autenticar al usuario
    func authenticateUser(email: String, password: String) -> User? {
        // Verifica si existe un usuario en el JSON con el email y la contraseña proporcionados
        return usersData.first { $0.mail.lowercased() == email.lowercased() && $0.password == password }
    }

    // Función para la persistencia de datos
    func saveUserToUserDefaults(user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "authenticatedUser")
        } catch {
            print("Error al guardar el usuario en UserDefaults: \(error)")
        }
    }

    // Muestra una alerta
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    // Obtener los datos del archivo JSON
    func fetchUserData(email: String, password: String) async {
        do {
            let users = try await Users.fetchData()  // Llama al método que obtiene los datos del JSON
            self.usersData = users

            guard !usersData.isEmpty else {
                showAlert(withTitle: "Login Failed", message: "No user data found.")
                return
            }

            // Verifica las credenciales del usuario
            if let authenticatedUser = authenticateUser(email: email, password: password) {
                // Guarda el usuario autenticado en UserDefaults para la persistencia
                saveUserToUserDefaults(user: authenticatedUser)
                

                if self.presentedViewController == nil {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let projectPageVC = storyboard.instantiateViewController(withIdentifier: "ProjectPageViewController") as? ProjectPageViewController {
                            projectPageVC.user = authenticatedUser
                            projectPageVC.modalPresentationStyle = .fullScreen  // Presenta en pantalla completa
                            self.present(projectPageVC, animated: true, completion: nil)
                        }
                    }
                } else {
                    print("Ya hay una vista presentada, no se puede realizar el segue")
                }
            } else {
                showAlert(withTitle: "Login Failed", message: "Invalid email or password.")
            }
        } catch {
            showAlert(withTitle: "Error", message: "Unable to fetch user data.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        setupKeyboardNotifications()
        setupCircularButton()
        setupPasswordField()
    }
    
    private func setupPasswordField() {
        passwordTextField.isSecureTextEntry = true

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye"), for: .normal)  // Reemplaza "eyeIcon" con el nombre de tu imagen que representa un ojo cerrado
        button.setImage(UIImage(named: "eye (1)"), for: .selected)  // Reemplaza "eyeSlashIcon" con el nombre de tu imagen que representa un ojo abierto
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20))
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
    }

    @objc func togglePasswordView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        loginButton.heightAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
    }
    
    func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
