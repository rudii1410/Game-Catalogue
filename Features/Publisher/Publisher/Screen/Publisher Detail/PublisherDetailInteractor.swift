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
import Common

protocol PublisherDetailUseCase {
    func getGameListByPublisher(publisherId: String, page: Int, count: Int) -> AnyPublisher<[Game], Error>
    func getPublisherDetail(id: String) -> AnyPublisher<GamePublisher, Error>
}

class PublisherDetailInteractor: PublisherDetailUseCase {
    private let publisherRepo: GamePublisherRepositoryInterface
    private let gameRepo: GameRepositoryInterface
    init(gameRepo: GameRepositoryInterface, publisherRepo: GamePublisherRepositoryInterface) {
        self.gameRepo = gameRepo
        self.publisherRepo = publisherRepo
    }
}

extension PublisherDetailInteractor {
    func getGameListByPublisher(publisherId: String, page: Int, count: Int) -> AnyPublisher<[Game], Error> {
        return self.gameRepo.getGameListByPublisher(publisherId: publisherId, page: page, count: count)
    }

    func getPublisherDetail(id: String) -> AnyPublisher<GamePublisher, Error> {
        return self.publisherRepo.getPublisherDetail(id: id)
    }
}
