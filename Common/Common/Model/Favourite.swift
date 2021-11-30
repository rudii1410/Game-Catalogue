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

public struct Favourite: Hashable {
    public let createdAt: Date
    public let image: String
    public let name: String
    public let rating: Double
    public let releaseDate: Date?
    public let slug: String
    public let genres: String

    public init(
        createdAt: Date,
        image: String,
        name: String,
        rating: Double,
        releaseDate: Date?,
        slug: String,
        genres: String
    ) {
        self.createdAt = createdAt
        self.image = image
        self.name = name
        self.rating = rating
        self.releaseDate = releaseDate
        self.slug = slug
        self.genres = genres
    }

    public func getGenreAsArray() -> [String] {
        let result = genres.components(separatedBy: ",")
        if result.count == 1 && result[0] == "" {
            return []
        } else {
            return result
        }
    }

    public func getReleaseDate() -> String {
        guard let date = releaseDate else {
            return "-"
        }
        return date.toString()
    }
}
