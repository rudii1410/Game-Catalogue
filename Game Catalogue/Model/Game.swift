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
    let id: Int = 0
    let name: String = ""
    let slug: String = ""
    let gamesCount: Int = 0
    let imageBackground: String = ""
    let description: String? = nil
}

class Game: BaseDetail {
    let released: String? = nil
    let rating: Double? = nil
    let ratingsCount: Int? = nil
    let genres: [BaseDetail]? = nil
    let platforms: [GamePlatform]? = nil
    let publishers: [BaseDetail]? = nil
    let developers: [BaseDetail]? = nil

    func getFormattedString(format: String) -> String {
        guard let data = released?.toDate(format: "yyyy-MM-dd") else {
            return released ?? "-"
        }
        return data.toString(format: format)
    }
}

class GamePlatform: BaseDetail {
    let platform: GamePlatformDetail? = nil
    let releasedAt: String = ""
    let requirements: Requirements? = nil
}

class GamePlatformDetail: BaseDetail {
    let image: String? = nil
    let yearStart: Int? = nil
    let yearEnd: Int? = nil
}

class Requirements {
    let minimum: String? = nil
    let recommended: String? = nil
}
