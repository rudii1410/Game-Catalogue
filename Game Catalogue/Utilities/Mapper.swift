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

import Common

enum Mapper {
    static func mapRawgGameShortListToModel(_ rawList: [RawgGameShort]) -> [Game] {
        return rawList.map { raw in
            let game = Game()
            game.id = raw.id
            game.slug = raw.slug
            game.name = raw.name
            game.released = raw.released
            game.imageBackground = raw.backgroundImage
            game.rating = raw.rating
            game.ratingsCount = raw.ratingsCount
            return game
        }
    }

    static func mapRawgGameDetailToModel(_ raw: RawgGameDetail) -> Game {
        let game = Game()
        game.id = raw.id
        game.slug = raw.slug
        game.name = raw.name
        game.released = raw.released
        game.imageBackground = raw.backgroundImage
        game.rating = raw.rating
        game.ratingsCount = raw.ratingsCount
        game.description = raw.description
        game.genres = Mapper.mapRawgGenreListToModel(raw.genres)
        game.platforms = Mapper.mapRawgGamePlatformListToModel(raw.platforms)
        game.publishers = Mapper.mapRawgPublisherListToModel(raw.publishers)
        game.developers = Mapper.mapRawgDeveloperListToModel(raw.developers)
        return game
    }

    static func mapRawgGenreToModel(_ genre: RawgBaseDetail) -> Genre {
        let newGenre = Genre()
        newGenre.id = genre.id
        newGenre.name = genre.name
        newGenre.slug = genre.slug
        newGenre.gamesCount = genre.gamesCount
        newGenre.imageBackground = genre.imageBackground
        newGenre.description = genre.description
        return newGenre
    }

    static func mapRawgGenreListToModel(_ maybeGenres: [RawgBaseDetail]?) -> [Genre] {
        guard let genres = maybeGenres else { return [] }
        return genres.map { genre in
            return Mapper.mapRawgGenreToModel(genre)
        }
    }

    static func mapRawgGamePlatformListToModel(_ maybePlatformList: [RawgGamePlatform]?) -> [GamePlatform] {
        guard let gamePlatform = maybePlatformList else { return [] }
        return gamePlatform.map { gamePlatform in
            let newPlatformDetail = GamePlatformDetail()
            newPlatformDetail.id = gamePlatform.platform.id
            newPlatformDetail.name = gamePlatform.platform.name
            newPlatformDetail.slug = gamePlatform.platform.slug
            newPlatformDetail.gamesCount = gamePlatform.platform.gamesCount ?? 0
            newPlatformDetail.imageBackground = gamePlatform.platform.imageBackground ?? ""
            newPlatformDetail.description = gamePlatform.platform.platformDescription ?? ""

            let requirements = Requirements()
            requirements.minimum = gamePlatform.requirements.minimum
            requirements.recommended = gamePlatform.requirements.recommended

            let newGamePlatform = GamePlatform()
            newGamePlatform.platform = newPlatformDetail
            newGamePlatform.releasedAt = gamePlatform.releasedAt
            newGamePlatform.requirements = requirements
            return newGamePlatform
        }
    }

    static func mapRawgPublisherToModel(_ publisher: RawgBaseDetail) -> GamePublisher {
        let newPublisher = GamePublisher()
        newPublisher.id = publisher.id
        newPublisher.name = publisher.name
        newPublisher.slug = publisher.slug
        newPublisher.gamesCount = publisher.gamesCount
        newPublisher.imageBackground = publisher.imageBackground
        newPublisher.description = publisher.description
        return newPublisher
    }

    static func mapRawgPublisherListToModel(_ maybePublishers: [RawgBaseDetail]?) -> [GamePublisher] {
        guard let publishers = maybePublishers else { return [] }
        return publishers.map { publisher in
            return Mapper.mapRawgPublisherToModel(publisher)
        }
    }

    static func mapRawgDeveloperListToModel(_ maybeDevelopers: [RawgBaseDetail]?) -> [Developer] {
        guard let developers = maybeDevelopers else { return [] }
        return developers.map { developer in
            let newDeveloper = Developer()
            newDeveloper.id = developer.id
            newDeveloper.name = developer.name
            newDeveloper.slug = developer.slug
            newDeveloper.gamesCount = developer.gamesCount
            newDeveloper.imageBackground = developer.imageBackground
            newDeveloper.description = developer.description
            return newDeveloper
        }
    }

    static func mapRawgScreenshotListToModel(_ maybeScreenshot: [RawgScreenshot]?) -> [Screenshot] {
        guard let screenshots = maybeScreenshot else { return [] }
        return screenshots.map { screenshot in
            let newScreenshot = Screenshot()
            newScreenshot.id = screenshot.id
            newScreenshot.image = screenshot.image
            newScreenshot.width = screenshot.width
            newScreenshot.height = screenshot.height
            newScreenshot.isDeleted = screenshot.isDeleted
            return newScreenshot
        }
    }

    static func mapFavouriteEntityToModel(_ entity: FavouriteEntity) -> Favourite {
        let favourite = Favourite(
            createdAt: entity.createdAt,
            image: entity.image,
            name: entity.name,
            rating: entity.rating,
            releaseDate: entity.releaseDate,
            slug: entity.slug,
            genres: entity.genres
        )
        return favourite
    }

    static func mapFavouriteEntityListToModel(_ entities: [FavouriteEntity]) -> [Favourite] {
        return entities.map { raw in
            return Mapper.mapFavouriteEntityToModel(raw)
        }
    }
}
