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

public class RawgGameDetail: Codable {
    public let id: Int
    public let slug, name, description: String
    public let released: String?
    public let backgroundImage: String
    public let rating: Double?
    public let ratingsCount: Int?
    public let genres: [RawgBaseDetail]?
    public let platforms: [RawgGamePlatform]?
    public let publishers: [RawgBaseDetail]?
    public let developers: [RawgBaseDetail]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, description, released
        case backgroundImage = "background_image"
        case rating
        case ratingsCount = "ratings_count"
        case genres, platforms, publishers, developers
    }
}

public class RawgGamePlatform: Codable {
    public let platform: RawgGamePlatformDetail
    public let releasedAt: String
    public let requirements: RawgRequirements

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

public class RawgRequirements: Codable {
    public let minimum, recommended: String?
}
