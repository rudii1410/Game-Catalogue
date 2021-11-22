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
    var description: String? = nil
}

class Game: BaseDetail {
    var released: String? = nil
    var rating: Double? = nil
    var ratingsCount: Int? = nil
    var genres: [Genre]? = nil
    var platforms: [GamePlatform]? = nil
    var publishers: [Publisher]? = nil
    var developers: [Developer]? = nil

    func getFormattedString(format: String) -> String {
        guard let data = released?.toDate(format: "yyyy-MM-dd") else {
            return released ?? "-"
        }
        return data.toString(format: format)
    }
}

class GamePlatform {
    var platform: GamePlatformDetail? = nil
    var releasedAt: String = ""
    var requirements: Requirements? = nil
}

class GamePlatformDetail: BaseDetail {
    var image: String? = nil
    var yearStart: Int? = nil
    var yearEnd: Int? = nil
}

class Requirements {
    var minimum: String? = nil
    var recommended: String? = nil
}

class Genre: BaseDetail {}

class Publisher: BaseDetail {}

class Developer: BaseDetail {}
