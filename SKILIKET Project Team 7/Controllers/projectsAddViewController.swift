//
//  projectsAddViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 15/10/24.
//

import UIKit

class projectsAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Title and Descrption
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    

    @IBOutlet weak var addButtonProject: UIButton!
    //Image
    var isImageSelected = false
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBAction func uploadImageTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.image"]
            imagePickerController.allowsEditing = true // Si quieres permitir edición

            let alertController = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    imagePickerController.sourceType = .camera
                    self.present(imagePickerController, animated: true)
                }))
            }

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                    imagePickerController.sourceType = .photoLibrary
                    self.present(imagePickerController, animated: true)
                }))
            }

            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL {
            imageNameLabel.text = url.lastPathComponent  // Actualiza el UILabel con el nombre de la imagen
            isImageSelected = true  // Indica que una imagen ha sido seleccionada
        }

        if let editedImage = info[.editedImage] as? UIImage {
            // Utiliza la imagen editada
        } else if let originalImage = info[.originalImage] as? UIImage {
            // Utiliza la imagen original
        }
        dismiss(animated: true)
    }

    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    //Add Topic and Add Parameters
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var topicsCounterLabel: UILabel!
    @IBOutlet weak var deleteLastButton: UIButton!
    
    @IBOutlet weak var deleteLastParameter: UIButton!
    @IBOutlet weak var tableViewParameters: UITableView!
    @IBOutlet weak var addParameter: UIButton!
    @IBOutlet weak var parametersCounterLabel: UILabel!
    
    var topics = [String]()
    let maxTopics = 5
    
    var parameters = [String]()
    let maxParameters = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularButton()
        tableViewParameters.delegate = self
        tableViewParameters.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        // Registrar celdas si no estás usando prototipos en storyboard
        tableViewParameters.register(UITableViewCell.self, forCellReuseIdentifier: "ParameterCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TopicCell")
        updateTopicsCounter()
        updateParametersCounter()
        deleteLastButton.isEnabled = !topics.isEmpty
        
        setupHideKeyboardOnTap()

    }
    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        addButtonProject.heightAnchor.constraint(equalTo: addButtonProject.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        addButtonProject.layer.cornerRadius = addButtonProject.frame.height / 2
        addButtonProject.clipsToBounds = true
    }
    
    func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Esto asegura que otros controles como botones todavía puedan responder a los toques.
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true) // Esto hará que la vista o cualquier subvista que esté editando termine de editar, ocultando el teclado.
    }

 
    // Método para determinar el número de filas en cada sección de las tablas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewParameters {
            return parameters.count
        } else {
            return topics.count
        }
    }

    // Método para configurar las celdas de cada tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewParameters {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParameterCell", for: indexPath)
            cell.textLabel?.text = parameters[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
            cell.textLabel?.text = topics[indexPath.row]
            return cell
        }
    }

    // Método para permitir la edición de filas en cada tabla
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Puedes ajustar según la tabla
    }

    // Método para manejar la eliminación de filas en cada tabla
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == self.tableViewParameters {
                parameters.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                updateParametersCounter() // Asegúrate de implementar esta función
            } else {
                topics.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                updateTopicsCounter()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editTopicName(at: indexPath)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if topics.count < maxTopics {
            // Aquí puedes añadir un diálogo para ingresar el nuevo tópico
            let newTopic = "Tópico \(topics.count + 1)" // Ejemplo de nuevo tópico
            topics.append(newTopic)
            tableView.reloadData()
            updateTopicsCounter()
        } else {
            showAlert("You can only add up to \(maxTopics) topics.")
        }
    }
    
    @IBAction func deleteLastTopicTapped(_ sender: UIButton) {
        if !topics.isEmpty {
            topics.removeLast()
            tableView.reloadData()
            updateTopicsCounter()
        }
    }
    
        
    func updateTopicsCounter() {
        topicsCounterLabel.text = "\(topics.count)/\(maxTopics)"
        deleteLastButton.isEnabled = !topics.isEmpty
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAddTopicDialog() {
        let alertController = UIAlertController(title: "Add Topic", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter topic name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self] _ in
            if let topicName = alertController.textFields?.first?.text, !topicName.isEmpty {
                self.topics.append(topicName)
                self.tableView.reloadData()
                updateTopicsCounter()
            }
        }
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func editTopicName(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Topic", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.topics[indexPath.row]
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            if let newName = alertController.textFields?.first?.text, !newName.isEmpty {
                self.topics[indexPath.row] = newName
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        alertController.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func addParameterTapped(_ sender: UIButton) {
        if parameters.count < maxParameters {
            showAddParameterDialog()
        } else {
            showAlert("You can only add up to \(maxParameters) parameters.")
        }
    }
    
    @IBAction func deleteLastParameterTapped(_ sender: UIButton) {
            if !parameters.isEmpty {
                parameters.removeLast()
                tableViewParameters.reloadData()
                updateParametersCounter()
            }
        }
        
        func updateParametersCounter() {
            parametersCounterLabel.text = "\(parameters.count)/\(maxParameters)"
            deleteLastParameter.isEnabled = !parameters.isEmpty
        }
        
        func showAddParameterDialog() {
            let alertController = UIAlertController(title: "Add Parameter", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Enter parameter name"
            }
            let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self] _ in
                if let paramName = alertController.textFields?.first?.text, !paramName.isEmpty {
                    self.parameters.append(paramName)
                    self.tableViewParameters.reloadData()
                    updateParametersCounter()
                }
            }
            alertController.addAction(addAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    
    
    //Upload project
    @IBAction func addProjectTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              !topics.isEmpty,
              !parameters.isEmpty,
              isImageSelected else {
            showAlertProject("Error", "Please fill in all fields and add at least one topic and one parameter.")
            return
        }
        
        showAlertProject("Success", "Project added successfully!")

    }
    
    func showAlertProject(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
}
