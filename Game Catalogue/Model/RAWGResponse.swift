//
//  RAWGResponse.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 18/08/21.
//  swiftlint:disable identifier_name

import Foundation

// MARK: - Welcome
class RAWGResponse<T: Codable>: Codable {
    let count: Int?
    let next, previous: String?
    let results: [T]?
}

// MARK: - Result
class GameShort: Codable {
    let id: Int?
    let slug, name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingsCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingsCount = "ratings_count"
    }
}

// MARK: - Rating
class Rating: Codable {
    let id: Int?
    let title: String?
    let count: Int?
    let percent: Double?
}
