import Foundation

// MARK: - NetworkState
class NetworkState: Codable {
    let response: [NetworkDeviceResponse]
    let version: String

    init(response: [NetworkDeviceResponse], version: String) {
        self.response = response
        self.version = version
    }
}

enum NetworkStateError: Error, LocalizedError {
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
class NetworkDeviceResponse: Codable {
    let hostname: String
    let managementIpAddress: String
    let reachabilityStatus: String
    let type: String
    let softwareVersion: String

    init(hostname: String, managementIpAddress: String, reachabilityStatus: String, type: String, softwareVersion: String) {
        self.hostname = hostname
        self.managementIpAddress = managementIpAddress
        self.reachabilityStatus = reachabilityStatus
        self.type = type
        self.softwareVersion = softwareVersion
    }
}

extension NetworkState {
    // Método para obtener el token
    static func getToken() async throws -> String? {
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
                throw NetworkStateError.TokenGenerationError
            }
            
            let ticketResponse = try? JSONDecoder().decode(TicketResponse.self, from: data)
            token = ticketResponse?.response.serviceTicket ?? "TokenError"
            return token
        } catch {
            print("Error al obtener token: \(error)")
            return nil
        }
    }
    
    // Método para obtener los dispositivos de red
    static func getNetworkDevices(token: String) async throws -> [NetworkDeviceResponse] {
        let url = "http://127.0.0.1:58000/api/v1/network-device"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        request.addValue(token, forHTTPHeaderField: "X-Auth-Token")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            print("Data received: \(String(describing: String(data: data, encoding: .utf8))))")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkStateError.DevicesNotFound
            }
            
            let networkDevices = try JSONDecoder().decode(NetworkState.self, from: data)
            return networkDevices.response
        } catch {
            print("Error al obtener dispositivos de red: \(error)")
            throw error
        }
    }
    
    
    static func fetchyourProjects() async throws -> yourprojects {
        var urlComponents = URLComponents(string: "http://martinmolina.com.mx/martinmolina.com.mx/reto_skiliket/Equipo7/yourprojectsJSON.json")!
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        let jsonDecoder = JSONDecoder()
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON recibido: \(jsonString)")
        }
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200,
           let newResponse = try? jsonDecoder.decode(YourProject.self, from: data) {
            return newResponse.yourProject
        } else {
            print("Hubo un error al recuperar la información")
            throw yourprojectError.notConnected
        }
    }
    
    // Método para obtener los hosts conectados
    static func getHosts(token: String) async throws -> [Host] {
        let url = "http://127.0.0.1:58000/api/v1/host"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        request.addValue(token, forHTTPHeaderField: "X-Auth-Token")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            print("Data received: \(String(describing: String(data: data, encoding: .utf8)))")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkStateError.DevicesNotFound
            }
            
            // Aquí se ajusta la decodificación al nuevo formato
            let hostResponse = try JSONDecoder().decode(HostResponse.self, from: data)
            return hostResponse.response
        } catch {
            print("Error al obtener hosts: \(error)")
            throw error
        }
    }
    
    
}

// MARK: - HostsResponse
class HostsResponse: Codable {
    let response: [Host]
    
    init(response: [Host]) {
        self.response = response
    }
}

// MARK: - TicketResponse (Para decodificar el ticket del API)
class TicketResponse: Codable {
    let response: Ticket

    init(response: Ticket) {
        self.response = response
    }
}

// MARK: - Ticket
class Ticket: Codable {
    let serviceTicket: String

    init(serviceTicket: String) {
        self.serviceTicket = serviceTicket
    }
}

// Estructura para la respuesta que envuelve el array de hosts
struct HostResponse: Codable {
    let response: [Host]
}

// Clase para el Host
class Host: Codable {
    let hostName: String
    let hostIp: String
    let pingStatus: String
    let lastUpdated: String
    let connectedNetworkDeviceName: String

    init(hostName: String, hostIp: String, pingStatus: String, connectedNetworkDeviceName: String, lastUpdated: String) {
        self.hostName = hostName
        self.hostIp = hostIp
        self.pingStatus = pingStatus
        self.connectedNetworkDeviceName = connectedNetworkDeviceName
        self.lastUpdated = lastUpdated
    }
}
