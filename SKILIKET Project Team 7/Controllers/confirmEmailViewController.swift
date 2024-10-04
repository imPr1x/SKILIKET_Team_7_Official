//
//  confirmEmailViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 03/10/24.
//
import UIKit

class confirmEmailViewController: UIViewController {

    var email: String?
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifyEmail()
    }

    private func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }

    func verifyEmail() {
        guard let url = URL(string: "https://api.tuservidor.com/verifyemail") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": self.email ?? ""
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        activityIndicator.startAnimating()
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    self?.showAlert(title: "Error", message: "Error verifying email: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data,
                      let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let success = jsonResponse["verified"] as? Bool else {
                    self?.showAlert(title: "Error", message: "Invalid response from server")
                    return
                }
                
                if success {
                    self?.showAlert(title: "Success", message: "Email successfully verified")
                    // Aquí puedes realizar una transición a otra pantalla si es necesario
                } else {
                    self?.showAlert(title: "Failed", message: "Email verification failed")
                }
            }
        }
        
        task.resume()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

