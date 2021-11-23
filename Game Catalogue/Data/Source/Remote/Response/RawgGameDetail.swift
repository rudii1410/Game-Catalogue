//
//  This file is part of Game Catalogue.
//
//  Game Catalogue is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Game Catalogue is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Game Catalogue.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation

class RawgGameDetail: Codable {
    let id: Int
    let slug, name, description: String
    let released: String?
    let backgroundImage: String
    let rating: Double?
    let ratingsCount: Int?
    let genres: [RawgBaseDetail]?
    let platforms: [RawgGamePlatform]?
    let publishers: [RawgBaseDetail]?
    let developers: [RawgBaseDetail]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, description, released
        case backgroundImage = "background_image"
        case rating
        case ratingsCount = "ratings_count"
        case genres, platforms, publishers, developers
    }
}

class RawgGamePlatform: Codable {
    let platform: RawgGamePlatformDetail
    let releasedAt: String
    let requirements: RawgRequirements

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

class RawgRequirements: Codable {
    let minimum, recommended: String?
}
