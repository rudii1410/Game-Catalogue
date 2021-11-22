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

import Combine
import Keys

protocol LocalDataSourceInterface {
    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error>
    func removeGameFromFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error>
    func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[Favourite], Error>
    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error>
    func getUserFavouriteGameGenre() -> AnyPublisher<[String], Error>
}

class LocalDataSource: LocalDataSourceInterface {
    private let sharedDb: Database

    init(database: Database) {
        self.sharedDb = database
    }

    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error> {
        return sharedDb.save()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func removeGameFromFavourites(_ item: Favourite) -> AnyPublisher<Void, Error> {
        return sharedDb.delete(item: item)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[Favourite], Error> {
        let sort = NSSortDescriptor(key: #keyPath(Favourite.createdAt), ascending: false)
        return sharedDb.fetchAll(offset: offset, size: limit, sortDesc: [sort])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error> {
        let predicate = NSPredicate(
            format: "slug = %@", slug
        )
        return sharedDb.fetchFirst(predicate: predicate)
            .receive(on: DispatchQueue.main)
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
