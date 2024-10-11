//
//  networkStatusViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 11/10/24.
//

import UIKit

class networkStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var buttonSelectProject: UIButton!
    
    @IBOutlet weak var buttonSelectDevice: UIButton!
    // Vista transparente y tabla que se mostrarán para selección de elementos.
    let transparentView = UIView()
    let tableView = UITableView()
        
    // Botón seleccionado y los datos para el UITableView.
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configura el delegado y la fuente de datos de la tabla, y registra la celda personalizada.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }

    @IBAction func onClickSelectProject(_ sender: Any) {
        // Configura la fuente de datos y muestra la tabla para seleccionar un proyecto.
        dataSource = ["Project 1", "Project 2", "Project 3"]
        selectedButton = buttonSelectProject
        addTransparentView(frames: buttonSelectProject.frame)
    }
    
    @IBAction func onClickSelectDevice(_ sender: Any) {
        dataSource = ["Device 1", "Device 2", "Device 3"]
        selectedButton = buttonSelectDevice
        addTransparentView(frames: buttonSelectProject.frame)
    }
    
    
    func addTransparentView(frames: CGRect) {
        // Intenta obtener la ventana clave actual y configura el marco de la vista transparente.
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        transparentView.frame = window.frame
        view.addSubview(transparentView)
        
        // Configura y añade la tabla bajo el botón seleccionado.
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        // Configura el fondo de la vista transparente y actualiza la tabla.
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        // Añade un gesto para quitar la vista transparente al tocar fuera de la tabla.
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        
        // Anima la aparición de la vista transparente y la expansión de la tabla.
        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        })
    }
    
    @objc func removeTransparentView() {
        // Anima la desaparición de la vista transparente y el colapso de la tabla.
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        })
    }


    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Devuelve el número de elementos en la fuente de datos.
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configura cada celda de la tabla.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    // UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Establece la altura de las filas de la tabla.
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Configura el título del botón seleccionado al elemento seleccionado y oculta la vista transparente.
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
