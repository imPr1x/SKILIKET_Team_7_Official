//
//  networkAdminJSON.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 14/10/24.
//

import Foundation

// MARK: - NetworkAdmin
class NetworkAdmin: Codable {
    let response: [NetworkAdminResponse]
    let version: String

    enum CodingKeys: String, CodingKey {
        case response
        case version
    }

    init(response: [NetworkAdminResponse], version: String) {
        self.response = response
        self.version = version
    }
    
    // Método para obtener el token de autenticación
    static func getToken() async throws -> String? {
        let url = "http://127.0.0.1:58000/api/v1/ticket"
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
                print("Error: No se pudo generar el token")
                return nil
            }

            // Decodificamos la respuesta JSON del token
            let ticketResponse = try JSONDecoder().decode(AuthTicketResponse.self, from: data)
            let token = ticketResponse.response.serviceTicket
            return token
        } catch {
            print("Error al obtener token: \(error)")
            return nil
        }
    }

    // Método para obtener los dispositivos de red
    static func getNetworkDevices(token: String) async throws -> [NetworkAdminResponse] {
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
                print("Error: No se encontraron dispositivos de red")
                return []
            }
            
            // Decodificamos los datos de los dispositivos de red
            let networkDevices = try JSONDecoder().decode(NetworkAdmin.self, from: data)
            return networkDevices.response
        } catch {
            print("Error al obtener dispositivos de red: \(error)")
            throw error
        }
    }
}


// MARK: - NetworkAdminResponse (antes Response)
class NetworkAdminResponse: Codable {
    let collectionStatus: CollectionStatus
    let connectedInterfaceName, connectedNetworkDeviceIPAddress, connectedNetworkDeviceName: [String]
    let errorDescription, globalCredentialID, hostname, id: String
    let interfaceCount: String
    let inventoryStatusDetail: CollectionStatus
    let ipAddresses: [String]?
    let lastUpdateTime, lastUpdated, macAddress, managementIPAddress: String
    let platformID: String
    let productID: ProductID
    let reachabilityFailureReason: ReachabilityFailureReason
    let reachabilityStatus: ReachabilityStatus
    let serialNumber, softwareVersion: String
    let type: TypeEnum
    let upTime: UpTime

    enum CodingKeys: String, CodingKey {
        case collectionStatus, connectedInterfaceName
        case connectedNetworkDeviceIPAddress = "connectedNetworkDeviceIpAddress"
        case connectedNetworkDeviceName, errorDescription
        case globalCredentialID = "globalCredentialId"
        case hostname, id, interfaceCount, inventoryStatusDetail, ipAddresses, lastUpdateTime, lastUpdated, macAddress
        case managementIPAddress = "managementIpAddress"
        case platformID = "platformId"
        case productID = "productId"
        case reachabilityFailureReason, reachabilityStatus, serialNumber, softwareVersion, type, upTime
    }

    init(collectionStatus: CollectionStatus, connectedInterfaceName: [String], connectedNetworkDeviceIPAddress: [String], connectedNetworkDeviceName: [String], errorDescription: String, globalCredentialID: String, hostname: String, id: String, interfaceCount: String, inventoryStatusDetail: CollectionStatus, ipAddresses: [String]?, lastUpdateTime: String, lastUpdated: String, macAddress: String, managementIPAddress: String, platformID: String, productID: ProductID, reachabilityFailureReason: ReachabilityFailureReason, reachabilityStatus: ReachabilityStatus, serialNumber: String, softwareVersion: String, type: TypeEnum, upTime: UpTime) {
        self.collectionStatus = collectionStatus
        self.connectedInterfaceName = connectedInterfaceName
        self.connectedNetworkDeviceIPAddress = connectedNetworkDeviceIPAddress
        self.connectedNetworkDeviceName = connectedNetworkDeviceName
        self.errorDescription = errorDescription
        self.globalCredentialID = globalCredentialID
        self.hostname = hostname
        self.id = id
        self.interfaceCount = interfaceCount
        self.inventoryStatusDetail = inventoryStatusDetail
        self.ipAddresses = ipAddresses
        self.lastUpdateTime = lastUpdateTime
        self.lastUpdated = lastUpdated
        self.macAddress = macAddress
        self.managementIPAddress = managementIPAddress
        self.platformID = platformID
        self.productID = productID
        self.reachabilityFailureReason = reachabilityFailureReason
        self.reachabilityStatus = reachabilityStatus
        self.serialNumber = serialNumber
        self.softwareVersion = softwareVersion
        self.type = type
        self.upTime = upTime
    }
}

// MARK: - AuthTicketResponse (Para decodificar el ticket del API)
class AuthTicketResponse: Codable {
    let response: AuthTicket

    init(response: AuthTicket) {
        self.response = response
    }
}

// MARK: - AuthTicket
class AuthTicket: Codable {
    let serviceTicket: String

    init(serviceTicket: String) {
        self.serviceTicket = serviceTicket
    }
}



enum CollectionStatus: String, Codable {
    case managed = "Managed"
    case unreachable = "Unreachable"
}

enum ProductID: String, Codable {
    case isr4331 = "ISR4331"
    case the296024Tt = "2960-24TT"
}

enum ReachabilityFailureReason: String, Codable {
    case empty = ""
    case notValidated = "NOT_VALIDATED"
}

enum ReachabilityStatus: String, Codable {
    case reachable = "Reachable"
}

enum TypeEnum: String, Codable {
    case router = "Router"
    case typeSwitch = "Switch"
}

enum UpTime: String, Codable {
    case the6Hours45Minutes37Seconds = "6 hours, 45 minutes, 37 seconds"
    case the6Hours45Minutes50Seconds = "6 hours, 45 minutes, 50 seconds"
    case the6Hours45Minutes51Seconds = "6 hours, 45 minutes, 51 seconds"
}
