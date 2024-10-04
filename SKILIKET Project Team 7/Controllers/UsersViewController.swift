//
//  UsersViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 04/10/24.
//

import UIKit

class UsersViewController: UIViewController {

    
    var loggedUser: data?  // Usuario que se recibe del login
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
          super.viewDidLoad()

          // Ocultar los elementos de la interfaz inicialmente
          profileImageView.isHidden = true
          usernameLabel.isHidden = true
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
          }
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
