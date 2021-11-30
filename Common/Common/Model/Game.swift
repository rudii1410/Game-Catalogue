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

public class BaseDetail {
    public var id: Int = 0
    public var name: String = ""
    public var slug: String = ""
    public var gamesCount: Int = 0
    public var imageBackground: String = ""
    public var description: String?

    public init() {}
}

public class Game: BaseDetail {
    public var released: String?
    public var rating: Double?
    public var ratingsCount: Int?
    public var genres: [Genre]?
    public var platforms: [GamePlatform]?
    public var publishers: [GamePublisher]?
    public var developers: [Developer]?

    public override init() {}

    public func getFormattedString(format: String) -> String {
        guard let data = released?.toDate(format: "yyyy-MM-dd") else {
            return released ?? "-"
        }
        return data.toString(format: format)
    }
}

public class GamePlatform {
    public var platform: GamePlatformDetail?
    public var releasedAt: String = ""
    public var requirements: Requirements?

    public init() {}
}

public class GamePlatformDetail: BaseDetail {
    public var image: String?
    public var yearStart: Int?
    public var yearEnd: Int?

    public override init() {}
}

public class Requirements {
    public var minimum: String?
    public var recommended: String?

    public init() {}
}

public class Genre: BaseDetail {
    public override init() {}
}

public class GamePublisher: BaseDetail {
    public override init() {}
}

public class Developer: BaseDetail {
    public override init() {}
}
