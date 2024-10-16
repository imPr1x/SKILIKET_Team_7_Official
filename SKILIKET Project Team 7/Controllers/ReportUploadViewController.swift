import UIKit

class CellClass: UITableViewCell {

}

class ReportUploadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var buttonSelectProject: UIButton!
    @IBOutlet weak var buttonSelectTopic: UIButton!
    
    
    // Vista transparente y tabla que se mostrarán para selección de elementos.
    let transparentView = UIView()
    let tableView = UITableView()
    
    // Botón seleccionado y los datos para el UITableView.
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configura el delegado y la fuente de datos de la tabla, y registra la celda personalizada.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        //Configuración inicial del UITextView
        commentTextView.delegate = self
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.cornerRadius = 5
        commentTextView.text = "Enter your comment here..."
        commentTextView.textColor = UIColor.lightGray
        
        
        // Tap Gesture para esconder el teclado
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupCircularButton()
    }
    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        uploadButton.heightAnchor.constraint(equalTo: uploadButton.widthAnchor).isActive = true
        
        // Configura el radio de las esquinas para hacer el botón circular
        uploadButton.layer.cornerRadius = uploadButton.frame.height / 2
        uploadButton.clipsToBounds = true
    }
    
    //Funcion para esconder el teclado.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
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
        }
        
        if info[UIImagePickerController.InfoKey.editedImage] is UIImage {
            // Utiliza la imagen editada
        } else if info[UIImagePickerController.InfoKey.originalImage] is UIImage {
            // Utiliza la imagen original
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
    func addTransparentView(frames: CGRect) {
        // Intenta obtener la ventana clave actual y configura el marco de la vista transparente.
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        transparentView.frame = window.frame
        view.addSubview(transparentView)
        
        // Configura y añade la tabla bajo el botón seleccionado.
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        // Configura el fondo de la vista transparente y actualiza la tabla.
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        // Añade un gesto para quitar la vista transparente al tocar fuera de la tabla.
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        
        // Anima la aparición de la vista transparente y la expansión de la tabla.
        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        })
    }
    
    @objc func removeTransparentView() {
        // Anima la desaparición de la vista transparente y el colapso de la tabla.
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        })
    }
    
    @IBAction func onClickSelectProject(_ sender: Any) {
        // Configura la fuente de datos y muestra la tabla para seleccionar un proyecto.
        dataSource = ["Project 1", "Project 2", "Project 3"]
        selectedButton = buttonSelectProject
        addTransparentView(frames: buttonSelectProject.frame)
    }
    
    @IBAction func onClickSelectTopic(_ sender: Any) {
        // Configura la fuente de datos y muestra la tabla para seleccionar un tópico.
        dataSource = ["Topic 1", "Topic 2"]
        selectedButton = buttonSelectTopic
        addTransparentView(frames: buttonSelectTopic.frame)
    }
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Devuelve el número de elementos en la fuente de datos.
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configura cada celda de la tabla.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    // UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Establece la altura de las filas de la tabla.
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Configura el título del botón seleccionado al elemento seleccionado y oculta la vista transparente.
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
    
    // Métodos de UITextViewDelegate para manejar el texto predeterminado
    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @objc func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your comment here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    // Métodos para manejar la aparición y desaparición del teclado
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                // Ajusta este valor según el diseño de tu aplicación
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //Upload Report
    
    @IBAction func submitReportTapped(_ sender: UIButton) {
        guard let project = buttonSelectProject.titleLabel?.text, project != "Select project",
              let topic = buttonSelectTopic.titleLabel?.text, topic != "Select topic",
              let comment = commentTextView.text, !comment.isEmpty && comment != "Enter your comment here..." else {
            showAlertSubmit(withTitle: "Error", message: "Please fill in all fields and upload an image.")
            return
        }
        showAlertSubmit(withTitle: "Success", message: "Your report has been successfully uploaded.")
    }
    
    func showAlertSubmit(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}
