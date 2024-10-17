
import UIKit

class networkStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonDownload: UIButton!
    @IBOutlet weak var buttonSelectProject: UIButton!
    @IBOutlet weak var buttonSelectDevice: UIButton!

    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var connectivityStatusLabel: UILabel!
    @IBOutlet weak var networkHealthLabel: UILabel!
    @IBOutlet weak var networkHealthProgressView: UIProgressView!
    
    
    @IBOutlet weak var selectedDeviceNameLabel: UILabel!
    @IBOutlet weak var selectedDeviceConnectivityStatusLabel: UILabel!
    @IBOutlet weak var selectedDeviceNetworkHealthLabel: UILabel!
    
    

    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    var connectedDevices = [Host]()  // Array de hosts (dispositivos conectados)
    var selectedRouter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularButton()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        networkHealthProgressView.setProgress(0.0, animated: false)
    }

    @IBAction func onClickSelectProject(_ sender: Any) {
        // Llamamos a la función para obtener los proyectos
        Task {
            do {
                let projects = try await YourProject.fetchyourProjects()
                let projectTitles = projects.map { $0.title }
                self.dataSource = projectTitles
                self.selectedButton = buttonSelectProject
                self.addTransparentView(frames: buttonSelectProject.frame)
            } catch {
                print("Error al obtener los proyectos: \(error)")
            }
        }
    }

    @IBAction func onClickSelectDevice(_ sender: Any) {
        if let router = selectedRouter {
            Task {
                do {
                    // Obtenemos los hosts filtrados según el router seleccionado
                    let filteredHosts = try await fetchHostsForSelectedRouter()
                    
                    // Actualizamos la lista desplegable con los hostNames de los hosts filtrados
                    dataSource = filteredHosts.map { $0.hostName }
                    connectedDevices = filteredHosts // Aquí actualizamos connectedDevices
                    
                    selectedButton = buttonSelectDevice
                    addTransparentView(frames: buttonSelectDevice.frame)
                } catch {
                    print("Error al obtener hosts: \(error)")
                }
            }
        } else {
            print("No hay router seleccionado")
        }
    }


    
    // Función para obtener el estado de la red en función de la ubicación seleccionada
    func fetchNetworkStateForLocation(location: String) async throws -> [NetworkDeviceResponse] {
        do {
            guard let token = try await NetworkState.getToken() else {
                print("Error: No se pudo obtener el token.")
                throw NetworkStateError.TokenGenerationError
            }

            let devices = try await NetworkState.getNetworkDevices(token: token)

            // Normalizar las ubicaciones para que la comparación sea más confiable
            let normalizedLocation = location.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

            let filteredDevices = devices.filter { device in
                if normalizedLocation.contains("ciudad de méxico") {
                    return device.hostname.contains("RouterCDMX")
                } else if normalizedLocation.contains("monterrey") {
                    return device.hostname.contains("RouterMonterrey")
                } else if normalizedLocation.contains("guadalajara") {
                    return device.hostname.contains("RouterGuadalajara")
                } else {
                    return false
                }
            }

            if filteredDevices.isEmpty {
                print("Advertencia: No se encontraron dispositivos para la ubicación: \(location)")
            }

            return filteredDevices
        } catch {
            print("Error en fetchNetworkStateForLocation: \(error)")
            throw error
        }
    }
    
        func setupCircularButton() {
            buttonDownload.heightAnchor.constraint(equalTo: buttonDownload.widthAnchor).isActive = true
            buttonDownload.layer.cornerRadius = buttonDownload.frame.height / 2
            buttonDownload.clipsToBounds = true
        }


        func addTransparentView(frames: CGRect) {
            guard let window = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first else { return }
            
            transparentView.frame = window.frame
            view.addSubview(transparentView)

            tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            view.addSubview(tableView)
            tableView.layer.cornerRadius = 5

            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            tableView.reloadData()

            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
            transparentView.addGestureRecognizer(tapgesture)
            transparentView.alpha = 0

            UIView.animate(withDuration: 0.4, animations: {
                self.transparentView.alpha = 0.5
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
            })
        }

        @objc func removeTransparentView() {
            let frames = selectedButton.frame
            UIView.animate(withDuration: 0.4, animations: {
                self.transparentView.alpha = 0
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            })
        }

        // UITableViewDataSource Methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = dataSource[indexPath.row]
            return cell
        }

        // UITableViewDelegate Methods
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
            
            if selectedButton == buttonSelectProject {
                // Obtener la localización del proyecto seleccionado y mostrar la información del router
                let selectedProjectLocation = dataSource[indexPath.row]
                Task {
                    do {
                        let filteredData = try await fetchNetworkStateForLocation(location: selectedProjectLocation)
                        updateUI(with: filteredData)
                        selectedRouter = selectedProjectLocation // Aquí almacenamos el router seleccionado
                    } catch {
                        print("Error al obtener el estado de red: \(error)")
                    }
                }
            } else if selectedButton == buttonSelectDevice {
                // Mostrar la información del device seleccionado
                let selectedDevice = connectedDevices[indexPath.row]
                updateDeviceUI(with: selectedDevice)
            }

            removeTransparentView()
        }

        // Función para obtener los hosts filtrados según el router seleccionado
    func fetchHostsForSelectedRouter() async throws -> [Host] {
        do {
            guard let token = try await NetworkState.getToken() else {
                throw NetworkStateError.TokenGenerationError
            }
            
            // Obtenemos los hosts
            let hosts = try await NetworkState.getHosts(token: token)

            // Extraemos el nombre del router desde deviceNameLabel (ej. "RouterCDMX")
            guard let routerText = deviceNameLabel.text else {
                print("No router name found in deviceNameLabel")
                return []
            }
            
            // El routerText es algo como "Router: RouterCDMX", así que lo limpiamos
            let router = routerText.replacingOccurrences(of: "Router: ", with: "")
            
            // Definimos el filtro según el router
            let searchKeyword: String
            if router.contains("CDMX") {
                searchKeyword = "CDMX"
            } else if router.contains("Monterrey") {
                searchKeyword = "Monterrey"
            } else if router.contains("Guadalajara") {
                searchKeyword = "Guadalajara"
            } else {
                print("No matching router found")
                return []
            }

            // Filtramos los hosts que tienen "connectedNetworkDeviceName" que contenga la palabra clave (CDMX, Monterrey, Guadalajara)
            let filteredHosts = hosts.filter { $0.connectedNetworkDeviceName.contains(searchKeyword) }

            // Si no se encuentran hosts
            if filteredHosts.isEmpty {
                print("No hosts found for router: \(router)")
            }

            return filteredHosts
        } catch let error {
            print("Error al obtener hosts: \(error.localizedDescription)")
            throw error
        }
    }


        // Actualización de la UI con los datos del router
        func updateUI(with networkDevices: [NetworkDeviceResponse]) {
            DispatchQueue.main.async {
                if let firstDevice = networkDevices.first {
                    self.deviceNameLabel.text = "Router: \(firstDevice.hostname)"
                    self.connectivityStatusLabel.text = "Conectividad: \(firstDevice.reachabilityStatus)"
                    
                    let health = firstDevice.reachabilityStatus == "Reachable" ? 100 : 50
                    self.networkHealthLabel.text = "Salud de Red: \(health)%"
                    self.networkHealthProgressView.progress = firstDevice.reachabilityStatus == "Reachable" ? 1.0 : 0.5
                } else {
                    self.deviceNameLabel.text = "No hay dispositivos"
                    self.connectivityStatusLabel.text = "Desconocido"
                    self.networkHealthLabel.text = "Salud de Red: 0%"
                    self.networkHealthProgressView.progress = 0.0
                }
            }
        }


    // Actualización de la UI con los datos del device seleccionado
    func updateDeviceUI(with selectedDevice: Host) {
        DispatchQueue.main.async {
            // Mostrar el hostName en el label correspondiente
            self.selectedDeviceNameLabel.text = "Device: \(selectedDevice.hostName)"
            
            // Mostrar el pingStatus en el label correspondiente
            self.selectedDeviceConnectivityStatusLabel.text = "Conectividad: \(selectedDevice.pingStatus)"
            
            // Mostrar el lastUpdated en el label correspondiente
            self.selectedDeviceNetworkHealthLabel.text = "Última actualización: \(selectedDevice.lastUpdated)"
        }
    }


    }
