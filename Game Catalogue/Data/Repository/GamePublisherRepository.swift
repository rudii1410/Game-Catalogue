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

protocol GamePublisherRepositoryInterface {
    func getPublisherList(page: Int, count: Int) -> AnyPublisher<[GamePublisher], Error>
    func getPublisherDetail(id: String) -> AnyPublisher<GamePublisher, Error>
}

class GamePublisherRepository: GamePublisherRepositoryInterface {
    private let remoteDataSource: RemoteDataSource

    init(remote: RemoteDataSource) {
        self.remoteDataSource = remote
    }
}

extension GamePublisherRepository {
    func getPublisherList(page: Int, count: Int) -> AnyPublisher<[GamePublisher], Error> {
        self.remoteDataSource
            .getPublisherList(page: page, count: count)
            .tryMap { output in
                return Mapper.mapRawgPublisherListToModel(output.results)
            }
            .eraseToAnyPublisher()
    }

    func getPublisherDetail(id: String) -> AnyPublisher<GamePublisher, Error> {
        self.remoteDataSource
            .getPublisherDetail(id: id)
            .tryMap { output in
                return Mapper.mapRawgPublisherToModel(output)
            }
            .eraseToAnyPublisher()
    }
}
