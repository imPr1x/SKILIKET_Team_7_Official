import Foundation

// MARK: - Assurancehealth
class Assurancehealth: Codable {
    let response: [ResponseAH]
    let version: String

    init(response: [ResponseAH], version: String) {
        self.response = response
        self.version = version
    }
}

// MARK: - ResponseAH
class ResponseAH: Codable {
    let clients: Clients
    let networkDevices: NetworkDevices
    let timestamp: String

    init(clients: Clients, networkDevices: NetworkDevices, timestamp: String) {
        self.clients = clients
        self.networkDevices = networkDevices
        self.timestamp = timestamp
    }
}


// MARK: - NetworkState
class NetworkStateV2: Codable { // Cambié el nombre a NetworkStateV2
    let response: [NetworkDeviceResponseV2]
    let version: String

    init(response: [NetworkDeviceResponseV2], version: String) {
        self.response = response
        self.version = version
    }
}

enum NetworkStateErrorV2: Error, LocalizedError { // Cambié a NetworkStateErrorV2
    case DevicesNotFound
    case TokenGenerationError
    case UnknownError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .DevicesNotFound:
            return "Dispositivos no encontrados en la red."
        case .TokenGenerationError:
            return "Error al generar el token de autenticación."
        case .UnknownError(let message):
            return "Error desconocido: \(message)"
        }
    }
}

// MARK: - NetworkDeviceResponse
class NetworkDeviceResponseV2: Codable { // Cambié a NetworkDeviceResponseV2
    let hostname: String
    let managementIpAddress: String
    let reachabilityStatus: String
    let type: String
    let softwareVersion: String
    let id: String

    // Especificamos las claves correctas para mapear desde el JSON
    enum CodingKeys: String, CodingKey {
        case hostname
        case managementIpAddress = "managementIpAddress" // Mapeamos la clave JSON correctamente
        case reachabilityStatus
        case type
        case softwareVersion
        case id
    }

    init(hostname: String, managementIpAddress: String, reachabilityStatus: String, type: String, softwareVersion: String, id: String) {
        self.hostname = hostname
        self.managementIpAddress = managementIpAddress
        self.reachabilityStatus = reachabilityStatus
        self.type = type
        self.softwareVersion = softwareVersion
        self.id = id
    }
}

extension NetworkStateV2 {
    // Método para obtener el token
    static func getTokenV2() async throws -> String? { // Cambié a getTokenV2
        let url = "http://127.0.0.1:58000/api/v1/ticket"
        var token = "TokenError"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parametros: [String: String] = [
            "username": "Admin",
            "password": "G7f!xN9p#T2zL$w4"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parametros, options: [])
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            print("Data received: \(String(describing: String(data: data, encoding: .utf8))))")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                throw NetworkStateErrorV2.TokenGenerationError
            }
            
            let ticketResponseV2 = try? JSONDecoder().decode(TicketResponseV2.self, from: data) // Cambié a TicketResponseV2
            token = ticketResponseV2?.response.serviceTicket ?? "TokenError"
            return token
        } catch {
            print("Error al obtener token: \(error)")
            return nil
        }
    }

    // Método para obtener el estado de salud de la red
    static func getNetworkHealthV2(token: String) async throws -> Assurancehealth { // Cambié a getNetworkHealthV2
        let url = "http://127.0.0.1:58000/api/v1/assurance/health"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        request.addValue(token, forHTTPHeaderField: "X-Auth-Token") // Añadimos el token a los headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            print("Data received: \(String(describing: String(data: data, encoding: .utf8))))")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkStateErrorV2.DevicesNotFound
            }

            // Decodificamos la respuesta del estado de salud de la red
            let networkHealth = try JSONDecoder().decode(Assurancehealth.self, from: data)
            return networkHealth
        } catch {
            print("Error al obtener el estado de salud de la red: \(error)")
            throw error
        }
    }
}

// MARK: - TicketResponse (Para decodificar el ticket del API)
class TicketResponseV2: Codable { // Cambié a TicketResponseV2
    let response: TicketV2 // Cambié a TicketV2

    init(response: TicketV2) { // Cambié a TicketV2
        self.response = response
    }
}

// MARK: - TicketV2 (Renombrado para evitar conflicto)
class TicketV2: Codable { // Cambié a TicketV2
    let serviceTicket: String

    init(serviceTicket: String) {
        self.serviceTicket = serviceTicket
    }
}




// MARK: - Clients
class Clients: Codable {
    let totalConnected, totalPercentage: String

    init(totalConnected: String, totalPercentage: String) {
        self.totalConnected = totalConnected
        self.totalPercentage = totalPercentage
    }
}

// MARK: - NetworkDevices
class NetworkDevices: Codable {
    let networkDevices: [NetworkDevice]
    let totalDevices, totalPercentage: String

    init(networkDevices: [NetworkDevice], totalDevices: String, totalPercentage: String) {
        self.networkDevices = networkDevices
        self.totalDevices = totalDevices
        self.totalPercentage = totalPercentage
    }
}

// MARK: - NetworkDevice
class NetworkDevice: Codable {
    let deviceType: DeviceType
    let healthyPercentage: String
    let healthyRatio: String // Cambié de HealthyRatio a String

    init(deviceType: DeviceType, healthyPercentage: String, healthyRatio: String) {
        self.deviceType = deviceType
        self.healthyPercentage = healthyPercentage
        self.healthyRatio = healthyRatio
    }
}


enum DeviceType: String, Codable {
    case routers = "Routers"
    case switches = "Switches"
}

enum HealthyRatio: Codable {
    case known(value: String) // Para valores que conocemos
    case unknown // Para valores desconocidos
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue {
        case "4:4", "6:6", "5:6": // Agrega todos los casos esperados aquí
            self = .known(value: rawValue)
        default:
            self = .unknown
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .known(let value):
            try container.encode(value)
        case .unknown:
            try container.encode("unknown")
        }
    }
}

