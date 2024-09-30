// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

//  Created by Fernando Chiñas on 29/09/24.
//   let feed = try? JSONDecoder().decode(Feed.self, from: jsonData)

import Foundation

// MARK: - Feed
class Feed: Codable {
    let response: [Response]

    init(response: [Response]) {
        self.response = response
    }
}

// MARK: - Response
class Response: Codable {
    let title, description, imageName, date: String
    let userImageName, userName: String
    let participants: Int

    init(title: String, description: String, imageName: String, date: String, userImageName: String, userName: String, participants: Int) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.date = date
        self.userImageName = userImageName
        self.userName = userName
        self.participants = participants
    }
}

typealias New = Response
typealias News = [Response]

enum NewError: Error, LocalizedError {
    case notConnected
    case wrongData
}

extension Feed {
    static func fetchNews() async throws -> News {
        var urlComponents = URLComponents(string: "https://raw.githubusercontent.com/imPr1x/data_SKILIKET/refs/heads/main/newsjson.json")!
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        let jsonDecoder = JSONDecoder()
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200,
           let newResponse = try? jsonDecoder.decode(Feed.self, from: data) {
            return newResponse.response
        }
        else {
            print("Hubo un error al recuperar la informacion")
            throw NewError.notConnected
        }
    }
}
