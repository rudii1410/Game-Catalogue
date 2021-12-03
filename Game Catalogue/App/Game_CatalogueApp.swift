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
import CoreData
import Core
import Common
import Home
import Game
import Genre

@main
struct GameCatalogueApp: App {
    private let container: ServiceContainer
    init() {
        self.container = ServiceContainer()

        initDIContainer(container: container)
        loadFeatureModule(container: container)
    }

    private func initDIContainer(container: ServiceContainer) {
        container.register(CoreDataWrapperInterface.self) { _ in
            let messageKitBundle = Bundle(identifier: "dev.rudiyanto.Game-Catalogue.Common")
            guard let modelURL = messageKitBundle?.url(forResource: "Game Catalogue", withExtension: "momd") else {
                preconditionFailure("Fail to load database model")
            }
            guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                preconditionFailure("Fail to load database model")
            }
            return CoreDataWrapper("Game Catalogue", managedModel: managedObjectModel)
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

    private func loadFeatureModule(container: ServiceContainer) {
        let moduleLoader = ModuleLoader()
        moduleLoader.registerModule(module: HomeModule.self, provider: HomeProviderInterface.self) { _ in
            return HomeModule(container: container)
        }
        moduleLoader.registerModule(module: GameModule.self, provider: GameProviderInterface.self) { _ in
            return GameModule(container: container)
        }
        moduleLoader.registerModule(module: GenreModule.self, provider: GenreProviderInterface.self) { _ in
            return GenreModule(container: container)
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
                homeProvider.getFavouriteScreenView()
                    .navigationBarTitle("Favourite Games", displayMode: .large)
            }
            .tag(Tab.favourite)
            .tabItem {
                Image(systemName: "heart")
                Text("Favourites")
            }

            NavigationView {
                homeProvider.getProfileScreenView()
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
