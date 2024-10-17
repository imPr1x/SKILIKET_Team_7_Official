//
//  registerAdminViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 04/10/24.
//
import UIKit
import UniformTypeIdentifiers // Importa este para iOS 14+

class registerAdminViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var addresTextField: UITextField!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        // Asegúrate de usar UTType.pdf para los documentos PDF
        var types = [UTType.pdf.identifier] // Para PDF
        if #available(iOS 14, *) {
            types.append(UTType.presentation.identifier) // Para presentaciones (PPTX)
        } else {
            // Fallback en versiones anteriores
            types.append("org.openxmlformats.presentationml.presentation")
        }
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: types.map { UTType($0)! }, asCopy: true)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen // Ahora debería reconocer esto correctamente
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Primero, verifica que todos los campos estén llenos.
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let addres = addresTextField.text,!addres.isEmpty,
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
        
        // Cuarto, Verifica que el formato del correo electrónico sea válido.
        guard isValidEmail(email) else {
            showAlert(withTitle: "Error", message: "Please enter a valid email address.")
            return
        }

        // Si no hay errores, realizar el segue.
        performSegue(withIdentifier: "requestSentIdentifier", sender: self)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Función para mostrar alertas
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    
    
    
    @IBAction func checkbox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    // UIDocumentPickerDelegate method
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedURL = urls.first else {
            return
        }
        
        // Puedes hacer algo con el archivo aquí, como cargarlo a un servidor o leer su contenido.
        print("Picked document at \(pickedURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.layer.masksToBounds = true
        setupCircularButton()
        setupHideKeyboardOnTap()
        setupKeyboardNotifications()
        setupPasswordField(confirmPasswordTextField)
        setupPasswordField(passwordTextField) 
    }
    
    
    private func setupPasswordField(_ textField: UITextField) {
        textField.isSecureTextEntry = true

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye black"), for: .normal)  // Icono de ojo cerrado
        button.setImage(UIImage(named: "eye closeb"), for: .selected)  // Icono de ojo abierto
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20))
        button.addTarget(self, action: #selector(togglePasswordView(_:)), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }

    @objc func togglePasswordView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let textField = sender.superview as? UITextField {
            textField.isSecureTextEntry = !sender.isSelected
        }
    }

    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        registerButton.heightAnchor.constraint(equalTo: registerButton.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.clipsToBounds = true
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
    }

    @objc func keyboardWillHide(notification: NSNotification) {
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "requestSentIdentifier", let confirmVC = segue.destination as? requestSentViewController{
        }
    }
    

}
