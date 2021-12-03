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

import Core
import Common
import SwiftUI

public class GenreModule: Module, GenreProviderInterface {
    private let container: ServiceContainer

    public required init(container: ServiceContainer) {
        self.container = container
    }

    public func load() {
        self.container.register(GenreListUseCase.self) { resolver in
            return GenreListInteractor(genreRepo: resolver.get())
        }
        self.container.register(GenreDetailUseCase.self) { resolver in
            return GenreDetailInteractor(gameRepo: resolver.get(), genreRepo: resolver.get())
        }
    }

    public func getGenreListScreenView(_ genreList: [Genre]) -> AnyView {
        return AnyView(
            GenreListScreen(
                model: .init(interactor: self.container.get()),
                genreList
            )
        )
    }

    public func getGenreDetailScreenView(_ slug: String) -> AnyView {
        return AnyView(
            GenreDetailScreen(
                model: .init(interactor: self.container.get()),
                slug: slug
            )
        )
    }
}
