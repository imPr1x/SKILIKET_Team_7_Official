//
//  userJSON.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 04/10/24.
//

import Foundation

// MARK: - Users
class Users: Codable {
    let users: [User]

    init(users: [User]) {
        self.users = users
    }
}

// MARK: - User
class User: Codable {
    let username, mail, password, fullname: String
    let age: Int
    let address: String
    let profileImageURL: String

    init(username: String, mail: String, password: String, fullname: String, age: Int, address: String, profileImageURL: String) {
        self.username = username
        self.mail = mail
        self.password = password
        self.fullname = fullname
        self.age = age
        self.address = address
        self.profileImageURL = profileImageURL
    }
}


typealias data = User
typealias datas = [User]

enum DataError: Error, LocalizedError {
    case notConnected
    case wrongData
}

extension Users {
    static func fetchData() async throws -> datas {
        var urlComponents = URLComponents(string: "http://martinmolina.com.mx/martinmolina.com.mx/reto_skiliket/Equipo7/users.json")!
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        let jsonDecoder = JSONDecoder()
        
        
        if let jsonString = String(data: data, encoding: .utf8) {
             print("JSON recibido: \(jsonString)")
         }
         
         
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200,
           let dataResponse = try? jsonDecoder.decode(Users.self, from: data) {
            return dataResponse.users
        }
        else {
            print("Hubo un error al recuperar la informacion")
            throw NewError.notConnected
        }
    }
}

