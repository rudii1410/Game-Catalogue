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

public class GameModule: Module, GameProviderInterface {
    private let container: ServiceContainer

    public required init(container: ServiceContainer) {
        self.container = container
    }

    public func load() {
        self.container.register(GameDetailUseCase.self) { resolver in
            return GameDetailInteractor(gameRepo: resolver.get())
        }
    }

    public func getGameDetailScreen(slug: String) -> AnyView {
        return AnyView(
            GameDetailScreen(
                model: .init(interactor: self.container.get()),
                slug: slug
            )
        )
    }
}
