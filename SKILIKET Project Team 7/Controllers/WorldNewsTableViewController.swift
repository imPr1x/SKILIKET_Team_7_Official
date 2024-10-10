//
//  TableViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 29/09/24.
//

import UIKit

class WorldNewsTableViewController: UITableViewController {
    
    // Array de respuestas que contendrá los datos obtenidos desde el JSON remoto
    var projects = NewsWorld()
    
    @IBOutlet weak var userIcon: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300 // Ajusta este valor estimado si es necesario

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    // Configuración de cada celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectTableViewCell
        
        // Obtén el proyecto actual (en tu caso, se llaman "Response")
        let project = projects[indexPath.row]
        
        // Configura los textos
        cell.projectTitle.text = project.title
        cell.projectDescription.text = project.description
        cell.projectDate.text = project.date
        cell.projectUser.text = project.userName
        cell.projectParticipants.text = "\(project.participants) participants"
        
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
        let nextView = segue.destination as! ProjectWorldViewController
        let index = tableView.indexPathForSelectedRow?.row
        let h = projects[index!]
        nextView.selectedworldproject = h
    }
}
