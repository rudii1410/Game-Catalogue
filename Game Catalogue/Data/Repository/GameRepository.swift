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

import Keys
import Combine

protocol GameRepositoryInterface {
    func getUpcomingRelease(endDate inputEndDate: Date?, page: Int, count: Int) -> AnyPublisher<[Game], Error>
    func getGameListByPublisher(publisherId: String, page: Int, count: Int) -> AnyPublisher<[Game], Error>
    func getGameListByGenres(genres: String, page: Int, count: Int) -> AnyPublisher<[Game], Error>
    func getGameDetail(id: String) -> AnyPublisher<Game, Error>
    func getGameScreenShots(id: String) -> AnyPublisher<[Screenshot], Error>
    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error>
    func removeGameFromFavourites(_ slug: String) -> AnyPublisher<Void, Error>
    func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[Favourite], Error>
    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error>
    func getUserFavouriteGameGenre() -> AnyPublisher<[String], Error>
}

class GameRepository: GameRepositoryInterface {
    private let localDataSource: LocalDataSource
    private let remoteDataSource: RemoteDataSource
    private let database: Database

    init(local: LocalDataSource, remote: RemoteDataSource, database: Database) {
        self.localDataSource = local
        self.remoteDataSource = remote
        self.database = database
    }
}

extension GameRepository {
    func getUpcomingRelease(
        endDate inputEndDate: Date? = nil,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<[Game], Error> {
        return self.remoteDataSource
            .getUpcomingRelease(endDate: inputEndDate, page: page, count: count)
            .tryMap { output in
                return Mapper.mapRawgGameShortListToModel(output.results)
            }
            .eraseToAnyPublisher()
    }

    func getGameListByPublisher(
        publisherId: String,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<[Game], Error> {
        return self.remoteDataSource
            .getGameListByPublisher(publisherId: publisherId, page: page, count: count)
            .tryMap { output in
                return Mapper.mapRawgGameShortListToModel(output.results)
            }
            .eraseToAnyPublisher()
    }

    func getGameListByGenres(
        genres: String,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<[Game], Error> {
        return self.remoteDataSource
            .getGameListByGenres(genres: genres, page: page, count: count)
            .tryMap { output in
                return Mapper.mapRawgGameShortListToModel(output.results)
            }
            .eraseToAnyPublisher()
    }

    func getGameDetail(id: String) -> AnyPublisher<Game, Error> {
        return self.remoteDataSource
            .getGameDetail(id: id)
            .tryMap { output in
                return Mapper.mapRawgGameDetailToModel(output)
            }
            .eraseToAnyPublisher()
    }

    func getGameScreenShots(id: String) -> AnyPublisher<[Screenshot], Error> {
        return self.remoteDataSource
            .getGameScreenShots(id: id)
            .tryMap { output in
                return Mapper.mapRawgScreenshotListToModel(output.results)
            }
            .eraseToAnyPublisher()
    }

    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error> {
        let entity = FavouriteEntity(context: self.database.bgContext)
        entity.slug = favourite.slug
        entity.name = favourite.name
        entity.image = favourite.image
        entity.rating = favourite.rating
        entity.releaseDate = favourite.releaseDate
        entity.genres = favourite.genres
        entity.createdAt = favourite.createdAt
        return self.localDataSource
            .addGameToFavourites(entity)
            .eraseToAnyPublisher()
    }

    func removeGameFromFavourites(_ slug: String) -> AnyPublisher<Void, Error> {
        return self.localDataSource
            .getFavouriteBySlug(slug: slug)
            .tryMap { output in
                _ = self.localDataSource.removeGameFavouriteByEntity(output)
                return
            }
            .eraseToAnyPublisher()
    }

    func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[Favourite], Error> {
        return self.localDataSource
            .fetchFavourites(offset: offset, limit: limit)
            .tryMap { output in
                return Mapper.mapFavouriteEntityListToModel(output)
            }
            .eraseToAnyPublisher()
    }

    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error> {
        return self.localDataSource
            .getFavouriteBySlug(slug: slug)
            .tryMap { output in
                return Mapper.mapFavouriteEntityToModel(output)
            }
            .eraseToAnyPublisher()
    }

    func getUserFavouriteGameGenre() -> AnyPublisher<[String], Error> {
        return self.fetchFavourites(offset: nil, limit: nil)
            .tryMap { output in
                var genres = Set<String>()
                for fav in output {
                    for genre in fav.getGenreAsArray() {
                        genres.insert(
                            genre.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    }
                }
                return Array(genres)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
