//
//  yourProjectsViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 06/10/24.
//

import UIKit

class yourProjectsViewController: UIViewController {
    
    
    var yourProjectSelected: yourproject?
    
    
    
    

    @IBOutlet weak var titleproject: UILabel!
    
    @IBOutlet weak var locationproject: UILabel!
    @IBOutlet weak var nameproject: UILabel!
    @IBOutlet weak var descriptionproject: UILabel!
    @IBOutlet weak var dateproject: UILabel!
    @IBOutlet weak var participantsproject: UILabel!
    @IBOutlet weak var imageuserproject: UIImageView!
    @IBOutlet weak var imageproject: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageuserproject.layer.cornerRadius = imageuserproject.frame.size.width / 2
        imageuserproject.clipsToBounds = true
        
        // Asignar valores a los labels
        locationproject.text = yourProjectSelected?.location
        dateproject.text = yourProjectSelected?.date
        participantsproject.text = "\(yourProjectSelected?.participants ?? 0)"
        titleproject.text = yourProjectSelected?.title
        nameproject.text = yourProjectSelected?.userName
        descriptionproject.text = yourProjectSelected?.description

        // Cargar las imágenes desde URLs
        if let projectImageURLString = yourProjectSelected?.imageName,
           let projectImageURL = URL(string: projectImageURLString) {
            loadImage(from: projectImageURL, into: imageproject)
        }

        if let userImageURLString = yourProjectSelected?.userImageName,
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

