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
import GameCatalogue_Core

public protocol LocalDataSourceInterface {
    func addGameToFavourites(_ favourite: FavouriteEntity) -> AnyPublisher<Void, Error>
    func removeGameFavouriteByEntity(_ favourite: FavouriteEntity) -> AnyPublisher<Void, Error>
    func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[FavouriteEntity], Error>
    func getFavouriteBySlug(slug: String) -> AnyPublisher<FavouriteEntity, Error>
}

public class LocalDataSource: LocalDataSourceInterface {
    private let sharedDb: CoreDataWrapperInterface

    public init(database: CoreDataWrapperInterface) {
        self.sharedDb = database
    }
}

extension LocalDataSource {
    public func addGameToFavourites(_ entity: FavouriteEntity) -> AnyPublisher<Void, Error> {
        return sharedDb.save()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func removeGameFavouriteByEntity(_ item: FavouriteEntity) -> AnyPublisher<Void, Error> {
        return sharedDb.delete(item: item)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func fetchFavourites(offset: Int?, limit: Int?) -> AnyPublisher<[FavouriteEntity], Error> {
        let sort = NSSortDescriptor(key: #keyPath(FavouriteEntity.createdAt), ascending: false)
        return sharedDb.fetchAll(offset: offset, size: limit, predicate: nil, sortDesc: [sort])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func getFavouriteBySlug(slug: String) -> AnyPublisher<FavouriteEntity, Error> {
        let predicate = NSPredicate(
            format: "slug = %@", slug
        )
        return sharedDb.fetchFirst(predicate: predicate)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
