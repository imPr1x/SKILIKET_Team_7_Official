//
//  yourProjectsViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 06/10/24.
//

import UIKit

class yourProjectsAdminViewController: UIViewController {
    
    
    @IBOutlet weak var deleteButton: UIButton!
    var yourProjectSelected: yourproject?
    
    var timer: Timer?
    var maxValue: Double = -Double.greatestFiniteMagnitude
    var minValue: Double = Double.greatestFiniteMagnitude
    
    @IBOutlet weak var titleproject: UILabel!
    @IBOutlet weak var locationproject: UILabel!
    @IBOutlet weak var nameproject: UILabel!
    @IBOutlet weak var descriptionproject: UILabel!
    @IBOutlet weak var dateproject: UILabel!
    @IBOutlet weak var participantsproject: UILabel!
    @IBOutlet weak var imageuserproject: UIImageView!
    @IBOutlet weak var imageproject: UIImageView!
        
    @IBOutlet weak var variables: UILabel!
        
        
    @IBOutlet weak var chartView: BarChartView!
    
    @IBOutlet weak var maxLabel: UILabel! // Para mostrar el valor máximo registrado
    @IBOutlet weak var minLabel: UILabel! // Para mostrar el valor mínimo registrado
    
    // Array para almacenar los datos de las barras
    var dataEntries: [BarChartDataEntry] = []
    var currentTopic: String = "Sensor Data" // Variable para guardar el nombre del topic medido
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularButton()
        // Inicialización del temporizador
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(refreshSensorData), userInfo: nil, repeats: true)
        
        imageuserproject.layer.cornerRadius = imageuserproject.frame.size.width / 2
        imageuserproject.clipsToBounds = true
        
        // Asignar valores a los labels
        locationproject.text = yourProjectSelected?.location
        dateproject.text = yourProjectSelected?.date
        participantsproject.text = "\(yourProjectSelected?.participants ?? 0)"
        titleproject.text = yourProjectSelected?.title
        nameproject.text = yourProjectSelected?.userName
        descriptionproject.text = yourProjectSelected?.description
        variables.text = yourProjectSelected?.topics.joined(separator: "\n")
        
        // Cargar las imágenes desde URLs
        if let projectImageURLString = yourProjectSelected?.imageName,
           let projectImageURL = URL(string: projectImageURLString) {
            loadImage(from: projectImageURL, into: imageproject)
        }
        
        if let userImageURLString = yourProjectSelected?.userImageName,
           let userImageURL = URL(string: userImageURLString) {
            loadImage(from: userImageURL, into: imageuserproject)
        }
        
        // Realizar la petición para los datos de los sensores y generar el gráfico
        if let location = yourProjectSelected?.location, let topics = yourProjectSelected?.topics {
            fetchSensorData(forLocation: location, topics: topics)
        }
        
        // Inicializamos el UILabel del valor máximo y mínimo
        maxLabel.text = "Máximo registrado: \(maxValue)"
        minLabel.text = "Mínimo registrado: \(minValue)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Tamaño fijo para todas las imágenes de usuario
        let size: CGFloat = 50.0
        imageuserproject.layer.cornerRadius = size / 2
        imageuserproject.clipsToBounds = true
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
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    // Función para hacer fetch de los datos del sensor según la ubicación
    func fetchSensorData(forLocation location: String, topics: [String]) {
        // Determina la URL según la ubicación
        var urlString: String
        
        if location.lowercased().contains("monterrey") {
            urlString = "http://localhost:8767/sensors"
        } else if location.lowercased().contains("ciudad de méxico") {
            urlString = "http://localhost:8765/sensors"
        } else if location.lowercased().contains("jalisco") {
            urlString = "http://localhost:8766/sensors"
        } else {
            print("Unknown location")
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        // Realiza la petición
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching sensor data: \(String(describing: error))")
                return
            }
            
            do {
                let sensorData = try JSONDecoder().decode(SensorData.self, from: data)
                self.handleSensorData(sensorData, topics: topics)
            } catch {
                print("Error decoding sensor data: \(error)")
            }
        }
        task.resume()
    }
    
    // Procesar los datos del sensor según los topics
    func handleSensorData(_ sensorData: SensorData, topics: [String]) {
        var values: [Double] = []
        
        // Convertir la lista de topics a un solo string
        let topicString = topics.joined(separator: " ").lowercased()
        
        // Validar los topics y agregar los valores según corresponda
        if topicString.contains("noise"), let soundValue = sensorData.sound {
            values.append(Double(soundValue))
            currentTopic = "Noise"
        }
        if topicString.contains("air quality"), let smokeValue = sensorData.smoke {
            values.append(Double(smokeValue))
            currentTopic = "Air Quality"
        }
        if topicString.contains("water quality"), let waterValue = sensorData.water {
            values.append(Double(waterValue))
            currentTopic = "Water Quality"
        }
        if topicString.contains("temperature"), let temperatureValue = sensorData.temperature {
            values.append(Double(temperatureValue))
            currentTopic = "Temperature"
        }
        if topicString.contains("humidity"), let humidityValue = sensorData.humidity {
            values.append(Double(humidityValue))
            currentTopic = "Humidity"
        }
        
        DispatchQueue.main.async {
            self.updateChart(with: values)
        }
    }
    
    // Función para actualizar el gráfico de barras con los valores obtenidos
    func updateChart(with values: [Double]) {
        // Añadir los nuevos valores como nuevas barras
        for (index, value) in values.enumerated() {
            let newDataEntry = BarChartDataEntry(x: Double(dataEntries.count + index), y: value)
            dataEntries.append(newDataEntry)
            
            // Actualizar el valor máximo y mínimo si el valor actual es mayor o menor
            if value > maxValue {
                maxValue = value
            }
            if value < minValue {
                minValue = value
            }
        }
        
        // Actualizar los UILabels con el valor máximo y mínimo registrados
        maxLabel.text = "Maximum registered: \(String(format: "%.2f", maxValue))"
        minLabel.text = "Minimum registered: \(String(format: "%.2f", minValue))"
        
        // Reiniciar la gráfica si tiene más de 5 mediciones
        if dataEntries.count > 5 {
            dataEntries.removeAll()
        }
        
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: currentTopic)
        
        // Personalizar el estilo de las barras
        barChartDataSet.colors = [NSUIColor.systemGreen]
        barChartDataSet.valueTextColor = NSUIColor.white
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        
        // Actualizar el gráfico
        if let chartView = chartView {
            chartView.data = barChartData
            
            // Animación
            chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInOutQuart)
            
            // Configuraciones adicionales del gráfico
            chartView.xAxis.labelPosition = .bottom
            chartView.rightAxis.enabled = false
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.leftAxis.drawGridLinesEnabled = true
            chartView.leftAxis.labelTextColor = NSUIColor.white
            
            // Notificar al gráfico que se ha actualizado
            chartView.notifyDataSetChanged()
        } else {
            print("chartView is nil")
        }
    }

    @objc func refreshSensorData() {
        if let location = yourProjectSelected?.location, let topics = yourProjectSelected?.topics {
            fetchSensorData(forLocation: location, topics: topics)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    // Modelo para los datos del sensor
    struct SensorData: Codable {
        let temperature: Int?
        let sound: Int?
        let water: Int?
        let smoke: Int?
        let humidity: Int? // Agregamos humedad, ya que puede estar en algunos casos
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        showDeletionConfirmationAlert()
    }
    
    func showDeletionConfirmationAlert() {
        let alertController = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this project?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteProject()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func deleteProject() {
        showAlertProjectDeletedSuccessfully()
    }
    
    func showAlertProjectDeletedSuccessfully() {
        let alertController = UIAlertController(title: "Deleted Successfully", message: "The project has been deleted successfully.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        deleteButton.clipsToBounds = true
    }

}

