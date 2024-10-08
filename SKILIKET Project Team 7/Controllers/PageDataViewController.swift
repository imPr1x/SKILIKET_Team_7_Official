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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        // Verificar si los textos están siendo recibidos
        print("Título recibido: \(titleText ?? "Sin título")")
        print("Descripción recibida: \(descriptionText ?? "Sin descripción")")
        
         */
        
        // Configura propiedades del botón
        selectButton.layer.cornerRadius = 10
        selectButton.setTitleColor(UIColor.white, for: .normal)
        
        
        print("Mostrando la vista con título: \(titleText ?? "Sin título")")
        print("Descripción: \(descriptionText ?? "Sin descripción")")
        print("imageView está conectado: \(imageView != nil)")
        
        // Configurar los textos
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
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

}
