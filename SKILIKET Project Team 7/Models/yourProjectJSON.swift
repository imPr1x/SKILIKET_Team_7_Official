//
//  yourProjectJSON.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 06/10/24.
//

import Foundation

// MARK: - YourProject
class YourProject: Codable {
    let yourProject: [YourProjectElement]

    init(yourProject: [YourProjectElement]) {
        self.yourProject = yourProject
    }
}

// MARK: - YourProjectElement
class YourProjectElement: Codable {
    let title, description: String
    let imageName: String
    let date: String
    let userImageName: String
    let userName: String
    let participants: Int
    let dashboardURL: String
    let location: String
    let topics: [String]

    init(title: String, description: String, imageName: String, date: String, userImageName: String, userName: String, participants: Int, dashboardURL: String, location: String, topics: [String]) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.date = date
        self.userImageName = userImageName
        self.userName = userName
        self.participants = participants
        self.dashboardURL = dashboardURL
        self.location = location
        self.topics = topics
    }
}


typealias yourproject = YourProjectElement
typealias yourprojects = [YourProjectElement]

enum yourprojectError: Error, LocalizedError {
    case notConnected
    case wrongData
}

extension YourProject {
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
        }
        else {
            print("Hubo un error al recuperar la informacion")
            throw NewError.notConnected
        }
    }
}
