import UIKit

class NetworkHealthTableViewController: UITableViewController {
    
    var networkHealthData: [ResponseAH] = [] // Array para almacenar los datos de la red
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registrar la celda personalizada
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Llamar al método para obtener los datos de la red
        fetchNetworkHealthData()
    }
    
    // Método para obtener la salud de la red
    func fetchNetworkHealthData() {
        Task {
            do {
                // Obtener el token
                if let token = try await NetworkStateV2.getTokenV2() {
                    // Obtener el estado de salud de la red usando el token
                    let networkHealth = try await NetworkStateV2.getNetworkHealthV2(token: token)
                    self.networkHealthData = networkHealth.response
                    self.tableView.reloadData() // Recarga los datos en la tabla
                }
            } catch {
                print("Error al obtener la salud de la red: \(error)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkHealthData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let data = networkHealthData[indexPath.row]
        
        // Extraemos los datos para Routers y Switches
        let routers = data.networkDevices.networkDevices.first(where: { $0.deviceType == .routers })
        let switches = data.networkDevices.networkDevices.first(where: { $0.deviceType == .switches })
        
        // Configurar la celda para mostrar los datos
        cell.textLabel?.numberOfLines = 0 // Permite que el texto se muestre en múltiples líneas
        
        // Mostramos los datos relevantes en cada celda
        cell.textLabel?.text = """
        Timestamp: \(data.timestamp)
        Total Connected: \(data.clients.totalConnected)
        Routers Healthy: \(routers?.healthyPercentage ?? "N/A")% (\(routers?.healthyRatio ?? "N/A"))
        Switches Healthy: \(switches?.healthyPercentage ?? "N/A")% (\(switches?.healthyRatio ?? "N/A"))
        Total Devices: \(data.networkDevices.totalDevices)
        """
        
        return cell
    }
}

