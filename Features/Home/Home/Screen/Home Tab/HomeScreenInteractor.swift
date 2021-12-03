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
import Foundation
import Common

protocol HomeUseCase {
    func getUpcomingRelease(endDate inputEndDate: Date?, page: Int, count: Int) -> AnyPublisher<[Game], Error>
    func getPublisherList(page: Int, count: Int) -> AnyPublisher<[GamePublisher], Error>
    func getGenreList(page: Int, count: Int) -> AnyPublisher<[Genre], Error>
    func getGameListByUserFavourites(page: Int, count: Int) -> Future<[Game], Error>
}

class HomeInteractor: HomeUseCase {
    private let gameRepo: GameRepositoryInterface
    private let publisherRepo: GamePublisherRepositoryInterface
    private let genreRepo: GameGenreRepositoryInterface
    private var cancellableSet: Set<AnyCancellable> = []

    init(gameRepo: GameRepositoryInterface, publisherRepo: GamePublisherRepositoryInterface, genreRepo: GameGenreRepositoryInterface) {
        self.gameRepo = gameRepo
        self.publisherRepo = publisherRepo
        self.genreRepo = genreRepo
    }
}

extension HomeInteractor {
    func getUpcomingRelease(endDate inputEndDate: Date? = nil, page: Int = 0, count: Int = 10) -> AnyPublisher<[Game], Error> {
        return self.gameRepo.getUpcomingRelease(endDate: inputEndDate, page: page, count: count)
    }

    func getPublisherList(page: Int, count: Int) -> AnyPublisher<[GamePublisher], Error> {
        return self.publisherRepo.getPublisherList(page: page, count: count)
    }

    func getGenreList(page: Int, count: Int) -> AnyPublisher<[Genre], Error> {
        return self.genreRepo.getGenreList(page: page, count: count)
    }

    func getGameListByUserFavourites(page: Int, count: Int) -> Future<[Game], Error> {
        Future { promise in
            self.gameRepo
                .getUserFavouriteGameGenre()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: {
                        let genres = $0.isEmpty ? "action" : $0.joined(separator: ",")
                        self.gameRepo
                            .getGameListByGenres(genres: genres, page: page, count: count)
                            .sink(
                                receiveCompletion: { _ in },
                                receiveValue: {
                                    promise(.success($0))
                                }
                            )
                            .store(in: &self.cancellableSet)
                    }
                )
                .store(in: &self.cancellableSet)
        }
    }
}
