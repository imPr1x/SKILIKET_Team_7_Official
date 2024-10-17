//
//  PageDataViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 03/10/24.
//

import UIKit

class PageDataViewController: UIViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var titleText: String?
    var descriptionText: String?
    
    var imageURL: URL?  // Propiedad para almacenar la URL de la imagen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        
        // Si tienes la URL de la imagen almacenada, llama al método para cargar la imagen aquí
        if let imageURL = imageURL {
            Task {
                await loadImage(from: imageURL)
            }
        } else {
            print("No se proporcionó una URL válida para la imagen")
        }
        setupCircularButton()
        setupRoundedRectangleImageView()
    }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            print("Mostrando la vista con título: \(titleText ?? "Sin título")")
            print("Descripción: \(descriptionText ?? "Sin descripción")")
            print("imageView está conectado: \(imageView != nil)")

            // Configurar los textos
            titleLabel.text = titleText
            descriptionLabel.text = descriptionText

            // Si tienes la URL de la imagen almacenada, llama al método para cargar la imagen aquí
            if let imageURL = imageURL {
                Task {
                    await loadImage(from: imageURL)
                }
            }
        }

        
        // Función para cargar la imagen desde una URL
        func loadImage(from url: URL) async {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Verifica si `imageView` no es nil antes de usarlo
                        guard self.imageView != nil else {
                            print("Error: imageView es nil")
                            return
                        }
                        self.imageView.image = image
                    }
                } else {
                    print("Error: No se pudo convertir los datos en una imagen")
                }
            } catch {
                print("Error al cargar la imagen: \(error)")
            }
        }
    

    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        selectButton.heightAnchor.constraint(equalTo: selectButton.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        selectButton.layer.cornerRadius = selectButton.frame.height / 2
        selectButton.clipsToBounds = true
    }
    
    func setupRoundedRectangleImageView() {
        // Asegúrate de que la vista de imagen tenga dimensiones antes de ajustar el cornerRadius
        imageView.layoutIfNeeded()
        
        // Ajustar el cornerRadius para obtener bordes redondeados
        // El valor del cornerRadius puede ajustarse para obtener el efecto deseado
        imageView.layer.cornerRadius = 20  // Este valor puede variar según el tamaño de la vista y la estética deseada
        imageView.clipsToBounds = true
    }


}
