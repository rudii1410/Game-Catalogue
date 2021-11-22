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

class BaseDetail {
    var id: Int = 0
    var name: String = ""
    var slug: String = ""
    var gamesCount: Int = 0
    var imageBackground: String = ""
    var description: String?
}

class Game: BaseDetail {
    var released: String?
    var rating: Double?
    var ratingsCount: Int?
    var genres: [Genre]?
    var platforms: [GamePlatform]?
    var publishers: [GamePublisher]?
    var developers: [Developer]?

    func getFormattedString(format: String) -> String {
        guard let data = released?.toDate(format: "yyyy-MM-dd") else {
            return released ?? "-"
        }
        return data.toString(format: format)
    }
}

class GamePlatform {
    var platform: GamePlatformDetail?
    var releasedAt: String = ""
    var requirements: Requirements?
}

class GamePlatformDetail: BaseDetail {
    var image: String?
    var yearStart: Int?
    var yearEnd: Int?
}

class Requirements {
    var minimum: String?
    var recommended: String?
}

class Genre: BaseDetail {}

class GamePublisher: BaseDetail {}

class Developer: BaseDetail {}
