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

protocol GenreListUseCase {
    func getGenreList(page: Int, count: Int) -> AnyPublisher<[Genre], Error>
}

class GenreListInteractor: GenreListUseCase {
    private let genreRepo: GameGenreRepositoryInterface
    init(genreRepo: GameGenreRepository) {
        self.genreRepo = genreRepo
    }
}

extension GenreListInteractor {
    func getGenreList(page: Int, count: Int) -> AnyPublisher<[Genre], Error> {
        return self.genreRepo.getGenreList(page: page, count: count)
    }
}
