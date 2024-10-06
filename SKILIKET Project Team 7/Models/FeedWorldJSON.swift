// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let worldFeed = try? JSONDecoder().decode(WorldFeed.self, from: jsonData)

import Foundation

// MARK: - WorldFeed
class WorldFeed: Codable {
    let response: [Response]

    init(response: [Response]) {
        self.response = response
    }
}

// MARK: - Response
class Response: Codable {
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

