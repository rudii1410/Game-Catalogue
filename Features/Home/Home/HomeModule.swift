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

public class HomeModule: Module, HomeProviderInterface {
    private let container: ServiceContainer

    public required init(container: ServiceContainer) {
        self.container = container
    }

    public func load() {
        self.container.register(ProfileRepositoryInterface.self) { resolver in
            return ProfileRepository(userDef: UserDefaults.standard)
        }

        self.container.register(HomeUseCase.self) { resolver in
            return HomeInteractor(
                gameRepo: resolver.get(),
                publisherRepo: resolver.get(),
                genreRepo: resolver.get()
            )
        }
        self.container.register(FavouriteUseCase.self) { resolver in
            return FavouriteInteractor(gameRepo: resolver.get())
        }
        self.container.register(ProfileUseCase.self) { resolver in
            return ProfileInteractor(profileRepo: resolver.get())
        }
    }

    public func getHomeScreenView() -> AnyView {
        return AnyView(
            HomeScreen(
                model: .init(interactor: self.container.get())
            )
        )
    }

    public func getFavouriteScreenView() -> AnyView {
        return AnyView(
            FavouritesScreen(
                model: .init(interactor: self.container.get())
            )
        )
    }

    public func getProfileScreenView() -> AnyView {
        return AnyView(
            ProfileScreen(model: .init(interactor: self.container.get()))
        )
    }
}
