//
//  PageDataViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 03/10/24.
//
import UIKit

class PageDataViewController: UIViewController {
    // Outlets que debes conectar en tu storyboard


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Variables para almacenar la información que cada página mostrará
    var image: UIImage?
    var titleText: String?
    var descriptionText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configurando los elementos de la UI con los datos pasados
        imageView.image = image
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
    }
}

