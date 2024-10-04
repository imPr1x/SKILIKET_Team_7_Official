//
//  ProjectViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 01/10/24.
//

import UIKit

class ProjectViewController: UIViewController {

    var selectedproject: New?

    @IBOutlet weak var locationproject: UILabel!
    @IBOutlet weak var dateproject: UILabel!
    @IBOutlet weak var participantsproject: UILabel!
    @IBOutlet weak var titleprojec: UILabel!
    @IBOutlet weak var nameproject: UILabel!
    @IBOutlet weak var descriptionproject: UILabel!
    @IBOutlet weak var imageproject: UIImageView!
    @IBOutlet weak var imageuserproject: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageuserproject.layer.cornerRadius = imageuserproject.frame.size.width / 2
        imageuserproject.clipsToBounds = true
        
        // Asignar valores a los labels
        locationproject.text = selectedproject?.location
        dateproject.text = selectedproject?.date
        participantsproject.text = "\(selectedproject?.participants ?? 0)"
        titleprojec.text = selectedproject?.title
        nameproject.text = selectedproject?.userName
        descriptionproject.text = selectedproject?.description

        // Cargar las imágenes desde URLs
        if let projectImageURLString = selectedproject?.imageName,
           let projectImageURL = URL(string: projectImageURLString) {
            loadImage(from: projectImageURL, into: imageproject)
        }

        if let userImageURLString = selectedproject?.userImageName,
           let userImageURL = URL(string: userImageURLString) {
            loadImage(from: userImageURL, into: imageuserproject)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Tamaño fijo para todas las imágenes de usuario
            let size: CGFloat = 50.0
            imageuserproject.layer.cornerRadius = size / 2
            imageuserproject.clipsToBounds = true
            
            // Establecer el tamaño de la imagen de usuario si no está restringido en Auto Layout
            imageuserproject.frame.size = CGSize(width: size, height: size)
            
    
    }


    // Función para descargar imágenes
    func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al descargar la imagen: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Error al convertir los datos en imagen")
                return
            }
            // Actualizar la imagen en el hilo principal
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
}


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

