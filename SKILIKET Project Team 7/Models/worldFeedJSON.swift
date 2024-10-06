// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let worldFeed = try? JSONDecoder().decode(WorldFeed.self, from: jsonData)

//  Created by Fernando Chiñas on 04/10/24.

import Foundation

// MARK: - WorldFeed
class WorldFeed: Codable {
    let answer: [Answer]

    init(answer: [Answer]) {
        self.answer = answer
    }
}

// MARK: - Answer
class Answer: Codable {
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


typealias NewWorld = Answer
typealias NewsWorld = [Answer]

enum NewWorldError: Error, LocalizedError {
    case notConnected
    case wrongData
}

extension WorldFeed{
    static func fetchNewsWorld() async throws -> NewsWorld {
        var urlComponents = URLComponents(string: "http://martinmolina.com.mx/martinmolina.com.mx/reto_skiliket/Equipo7/newsWorldJSON.json")!
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        let jsonDecoder = JSONDecoder()
        
        
        if let jsonString = String(data: data, encoding: .utf8) {
             print("JSON recibido: \(jsonString)")
         }
         
         
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200,
           let newResponse = try? jsonDecoder.decode(WorldFeed.self, from: data) {
            return newResponse.answer
        }
        else {
            print("Hubo un error al recuperar la informacion")
            throw NewError.notConnected
        }
    }
}
