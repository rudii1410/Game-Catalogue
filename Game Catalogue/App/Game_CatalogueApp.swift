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

import SwiftUI
import Core
import Common

import Home

@main
struct GameCatalogueApp: App {
    private let container: ServiceContainer
    init() {
        self.container = ServiceContainer()

        initDIContainer(container: container)
        initTempDiContainer(container: container)
        loadFeatureModule(container: container)
    }

    private func initDIContainer(container: ServiceContainer) {
        container.register(CoreDataWrapperInterface.self) { _ in
            return CoreDataWrapper()
        }

        container.register(LocalDataSourceInterface.self) { resolver in
            return LocalDataSource(database: resolver.get())
        }
        container.register(RemoteDataSourceInterface.self) { _ in
            return RemoteDataSource()
        }

        container.register(GameRepositoryInterface.self) { resolver in
            return GameRepository(local: resolver.get(), remote: resolver.get(), database: resolver.get())
        }
        container.register(GamePublisherRepositoryInterface.self) { resolver in
            return GamePublisherRepository(remote: resolver.get())
        }
        container.register(GameGenreRepositoryInterface.self) { resolver in
            return GameGenreRepository(remote: resolver.get())
        }
    }

    private func initTempDiContainer(container: ServiceContainer) {
        container.register(ProfileRepository.self) { _ in
            return ProfileRepository(userDef: UserDefaults.standard)
        }
        container.register(FavouriteInteractor.self) { resolver in
            return FavouriteInteractor(gameRepo: resolver.get())
        }
        container.register(ProfileInteractor.self) { resolver in
            return ProfileInteractor(profileRepo: resolver.get())
        }
    }

    private func loadFeatureModule(container: ServiceContainer) {
        let moduleLoader = ModuleLoader()
        moduleLoader.registerModule(module: HomeModule.self, provider: HomeProviderInterface.self) { _ in
            return HomeModule(container: container)
        }

        moduleLoader.loadAllModules()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(container: self.container)
        }
    }
}

struct ContentView: View {
    @State private var currentTab: Tab = .home
    let container: ServiceContainer

    let homeProvider: HomeProviderInterface = Navigator.instance.getProvider(HomeProviderInterface.self)
    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView {
                homeProvider.getHomeScreenView()
                    .navigationBarTitle("Games catalogue", displayMode: .large)
            }
            .tag(Tab.home)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            NavigationView {
                FavouritesScreen(model: .init(interactor: container.get()))
                    .navigationBarTitle("Favourite Games", displayMode: .large)
            }
            .tag(Tab.favourite)
            .tabItem {
                Image(systemName: "heart")
                Text("Favourites")
            }

            NavigationView {
                ProfileScreen(model: .init(interactor: container.get()))
                    .navigationBarTitle("My Profile", displayMode: .inline)
            }
            .tag(Tab.profile)
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

enum Tab {
    case home
    case favourite
    case profile
}
