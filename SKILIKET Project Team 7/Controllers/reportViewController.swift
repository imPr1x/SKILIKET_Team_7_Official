import UIKit

class CellClass2: UITableViewCell {

}

class reportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isImageSelected = false
    
    @IBOutlet weak var buttonSelectTopic: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageNameLabel: UILabel!
    

    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass2.self, forCellReuseIdentifier: "Cell")
        
        commentTextView.delegate = self
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.cornerRadius = 5
        commentTextView.text = "Enter your comment here..."
        commentTextView.textColor = UIColor.lightGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupCircularButton()
    }
    
    func setupCircularButton() {
        uploadButton.heightAnchor.constraint(equalTo: uploadButton.widthAnchor).isActive = true
        uploadButton.layer.cornerRadius = uploadButton.frame.height / 2
        uploadButton.clipsToBounds = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func uploadImageTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.allowsEditing = true

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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL {
            imageNameLabel.text = url.lastPathComponent
        }

        if let editedImage = info[.editedImage] as? UIImage {
            // use editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            // use originalImage
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func addTransparentView(frames: CGRect) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        transparentView.frame = window.frame
        view.addSubview(transparentView)

        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 5

        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()

        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0

        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        })
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        })
    }
    
    @IBAction func onClickSelectTopic(_ sender: UIButton) {
        dataSource = ["Topic 1", "Topic 2"]
        selectedButton = buttonSelectTopic
        addTransparentView(frames: buttonSelectTopic.frame)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
    
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
    
    
    @IBAction func submitReportTapped(_ sender: UIButton) {
        guard let topic = buttonSelectTopic.titleLabel?.text, topic != "Select topic",
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
    }}
