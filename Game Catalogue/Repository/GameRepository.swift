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

protocol GameRepository {
    func getUpcomingRelease(endDate inputEndDate: Date?, page: Int, count: Int) -> AnyPublisher<ListResponse<GameShort>, Error>
    func getGameListByPublisher(publisherId: String, page: Int, count: Int) -> AnyPublisher<ListResponse<GameShort>, Error>
    func getGameListByGenres(genres: String, page: Int, count: Int) -> AnyPublisher<ListResponse<GameShort>, Error>
    func getGameDetail(id: String) -> AnyPublisher<GameDetail, Error>
    func getGameScreenShots(id: String) -> AnyPublisher<ListResponse<Screenshot>, Error>
    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error>
    func removeGameFromFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error>
    func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[Favourite], Error>
    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error>
    func getUserFavouriteGameGenre() -> AnyPublisher<[String], Error>
}

class GameRepositoryImpl: GameRepository {
    private let rawgApiKey = GameCatalogueKeys().rawgApiKey
    private let db = Database.shared

    func getUpcomingRelease(
        endDate inputEndDate: Date? = nil,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<ListResponse<GameShort>, Error> {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        guard let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) else {
            return Fail<ListResponse<GameShort>, Error>(
                error: GenericError.error("invalid start date")
            ).eraseToAnyPublisher()
        }

        var tempEndDate = inputEndDate
        if tempEndDate == nil {
            dateComponent.month = 3
            tempEndDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        }
        guard let endDate = tempEndDate else {
            return Fail<ListResponse<GameShort>, Error>(
                error: GenericError.error("invalid end date")
            ).eraseToAnyPublisher()
        }

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let fDates = "\(format.string(from: startDate)),\(format.string(from: endDate))"

        return Request("\(Constant.rawgApiUrl)/games")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "dates", value: fDates)
            .addQuery(key: "ordering", value: "-rating")
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    func getGameListByPublisher(
        publisherId: String,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<ListResponse<GameShort>, Error> {
        return Request("\(Constant.rawgApiUrl)/games")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "publishers", value: publisherId)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    func getGameListByGenres(
        genres: String,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<ListResponse<GameShort>, Error> {
        return Request("\(Constant.rawgApiUrl)/games")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "genres", value: genres)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    func getGameDetail(id: String) -> AnyPublisher<GameDetail, Error> {
        return Request("\(Constant.rawgApiUrl)/games/\(id)")
            .addQuery(key: "key", value: rawgApiKey)
            .resultPublisher()
    }

    func getGameScreenShots(id: String) -> AnyPublisher<ListResponse<Screenshot>, Error> {
        return Request("\(Constant.rawgApiUrl)/games/\(id)/screenshots")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "page_size", value: "10")
            .resultPublisher()
    }

    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error> {
        return db.save()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func removeGameFromFavourites(_ item: Favourite) -> AnyPublisher<Void, Error> {
        return db.delete(item: item)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[Favourite], Error> {
        let sort = NSSortDescriptor(key: #keyPath(Favourite.createdAt), ascending: false)
        return db.fetchAll(offset: offset, size: limit, sortDesc: [sort])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error> {
        let predicate = NSPredicate(
            format: "slug = %@", slug
        )
        return db.fetchFirst(predicate: predicate)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getUserFavouriteGameGenre() -> AnyPublisher<[String], Error> {
        return self.fetchFavourites(offset: nil, limit: nil)
            .tryMap { output in
                var genres = Set<String>()
                for fav in output {
                    for genre in fav.getGenreAsArray() {
                        genres.insert(genre)
                    }
                }
                return Array(genres)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
