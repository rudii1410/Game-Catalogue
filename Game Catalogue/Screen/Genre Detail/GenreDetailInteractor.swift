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

protocol GenreDetailUseCase {
    func getGameListByGenres(genres: String, page: Int, count: Int) -> AnyPublisher<[Game], Error>
    func getGenreDetail(id: String) -> AnyPublisher<Genre, Error>
}

class GenreDetailInteractor: GenreDetailUseCase {
    private let genreRepo: GameGenreRepositoryInterface
    private let gameRepo: GameRepositoryInterface
    init(gameRepo: GameRepository, genreRepo: GameGenreRepository) {
        self.gameRepo = gameRepo
        self.genreRepo = genreRepo
    }
}

extension GenreDetailInteractor {
    func getGameListByGenres(genres: String, page: Int, count: Int) -> AnyPublisher<[Game], Error> {
        return self.gameRepo.getGameListByGenres(genres: genres, page: page, count: count)
    }

    func getGenreDetail(id: String) -> AnyPublisher<Genre, Error> {
        return self.genreRepo.getGenreDetail(id: id)
    }
}
