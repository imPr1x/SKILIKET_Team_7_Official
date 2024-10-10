//
//  GlobalNewsViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 09/10/24.
//

import UIKit

class GlobalNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var projects = NewsWorld()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300 // Ajusta este valor estimado si es necesario
        
        
        // Asignar delegado y fuente de datos
        tableView.delegate = self
        tableView.dataSource = self

        // Cargar los datos desde la URL
        Task {
            await fetchNewsData()
        }
    }

    // MARK: - Función para cargar los datos de la URL
    func fetchNewsData() async {
        do {
            let newsworld = try await WorldFeed.fetchNewsWorld()
            self.projects = newsworld
            DispatchQueue.main.async {
                self.tableView.reloadData() // Recargar la tabla con los datos obtenidos
            }
        } catch {
            print("Error al obtener los datos: \(error.localizedDescription)")
        }
    }

    // MARK: - Métodos de UITableViewDataSource y UITableViewDelegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    // Configuración de cada celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectTableViewCell
        
        // Obtén el proyecto actual (en tu caso, se llaman "Response")
        let project = projects[indexPath.row]
        
        // Configura los textos
        cell.projectTitle.text = project.title
        cell.projectDescription.text = project.description
        cell.projectDate.text = project.date
        cell.projectUser.text = project.userName
        
        // Cargar la imagen del proyecto desde una URL
        if let projectImageURL = URL(string: project.imageName) {
            loadImage(from: projectImageURL, into: cell.projectImage)
        }

        // Cargar la imagen del usuario desde una URL
        if let userImageURL = URL(string: project.userImageName) {
            loadImage(from: userImageURL, into: cell.userProjectImage)
        }
        
        return cell
    }

    // Función para descargar imágenes desde una URL
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

    // Preparación para el segue
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showNewsDetail" {
        // Este segue es para mostrar los detalles de una noticia específica
        if let nextView = segue.destination as? ProjectWorldViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            let h = projects[index]
            nextView.selectedworldproject = h
        }
    } else if segue.identifier == "showGlobalNews" {
        // Este segue es para el botón que cambia a otra pantalla
        // Configura el destino según sea necesario, por ejemplo:
        let otherViewController = segue.destination as? WorldNewsTableViewController
        // Configura `otherViewController` con la información necesaria
    }
}


    //Ocultar la navbar en la pantalla principal de news
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
