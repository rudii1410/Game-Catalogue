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

protocol GameDetailUseCase {
    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error>
    func removeGameFromFavourites(_ slug: String) -> AnyPublisher<Void, Error>
    func getGameListByGenres(genres: String, page: Int, count: Int) -> AnyPublisher<[Game], Error>
    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error>
    func getGameDetail(id: String) -> AnyPublisher<Game, Error>
    func getGameScreenShots(id: String) -> AnyPublisher<[Screenshot], Error>
}

class GameDetailInteractor: GameDetailUseCase {
    private let gameRepo: GameRepositoryInterface
    init(gameRepo: GameRepository) {
        self.gameRepo = gameRepo
    }
}

extension GameDetailInteractor {
    func addGameToFavourites(_ favourite: Favourite) -> AnyPublisher<Void, Error> {
        return self.gameRepo.addGameToFavourites(favourite)
    }

    func removeGameFromFavourites(_ slug: String) -> AnyPublisher<Void, Error> {
        return self.gameRepo.removeGameFromFavourites(slug)
    }

    func getGameListByGenres(genres: String, page: Int, count: Int) -> AnyPublisher<[Game], Error> {
        return self.gameRepo.getGameListByGenres(genres: genres, page: page, count: count)
    }

    func getFavouriteBySlug(slug: String) -> AnyPublisher<Favourite, Error> {
        return self.gameRepo.getFavouriteBySlug(slug: slug)
    }

    func getGameDetail(id: String) -> AnyPublisher<Game, Error> {
        return self.gameRepo.getGameDetail(id: id)
    }

    func getGameScreenShots(id: String) -> AnyPublisher<[Screenshot], Error> {
        return self.gameRepo.getGameScreenShots(id: id)
    }
}
