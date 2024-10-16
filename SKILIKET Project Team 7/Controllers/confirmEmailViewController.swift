import UIKit

class confirmEmailViewController: UIViewController {

    var email: String?
    var password: String?  // Si necesitas el password
    var name: String?      // Si necesitas el nombre

    let activityIndicator = UIActivityIndicatorView(style: .large)

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
        if segue.identifier == "successIdentifier", let successVC = segue.destination as? successViewController {
            successVC.registeredEmail = email
            successVC.registeredPassword = password
            successVC.registeredName = name
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

