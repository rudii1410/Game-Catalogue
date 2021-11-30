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
import Common

protocol GameGenreRepositoryInterface {
    func getGenreList(page: Int, count: Int) -> AnyPublisher<[Genre], Error>
    func getGenreDetail(id: String) -> AnyPublisher<Genre, Error>
}

class GameGenreRepository: GameGenreRepositoryInterface {
    private let remoteDataSource: RemoteDataSource

    init(remote: RemoteDataSource) {
        self.remoteDataSource = remote
    }
}

extension GameGenreRepository {
    func getGenreList(page: Int, count: Int) -> AnyPublisher<[Genre], Error> {
        return self.remoteDataSource
            .getGenreList(page: page, count: count)
            .tryMap { output in
                return Mapper.mapRawgGenreListToModel(output.results)
            }
            .eraseToAnyPublisher()
    }

    func getGenreDetail(id: String) -> AnyPublisher<Genre, Error> {
        return self.remoteDataSource
            .getGenreDetail(id: id)
            .tryMap { output in
                return Mapper.mapRawgGenreToModel(output)
            }
            .eraseToAnyPublisher()
    }
}
