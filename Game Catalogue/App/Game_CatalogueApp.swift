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

@main
struct GameCatalogueApp: App {
    init() {
        ServiceContainer.instance.register(Database.self) { _ in
            return Database()
        }
        ServiceContainer.instance.register(LocalDataSource.self) { service in
            return LocalDataSource(database: service.get())
        }
        ServiceContainer.instance.register(RemoteDataSource.self) { _ in
            return RemoteDataSource()
        }

        ServiceContainer.instance.register(GameRepository.self) { service in
            return GameRepository(local: service.get(), remote: service.get(), database: service.get())
        }
        ServiceContainer.instance.register(GamePublisherRepository.self) { service in
            return GamePublisherRepository(remote: service.get())
        }
        ServiceContainer.instance.register(GameGenreRepository.self) { service in
            return GameGenreRepository(remote: service.get())
        }
        ServiceContainer.instance.register(ProfileRepository.self) { _ in
            return ProfileRepository(userDef: UserDefaults.standard)
        }

        ServiceContainer.instance.register(HomeInteractor.self) { service in
            return HomeInteractor(gameRepo: service.get(), publisherRepo: service.get(), genreRepo: service.get())
        }
        ServiceContainer.instance.register(FavouriteInteractor.self) { service in
            return FavouriteInteractor(gameRepo: service.get())
        }
        ServiceContainer.instance.register(ProfileInteractor.self) { service in
            return ProfileInteractor(profileRepo: service.get())
        }
        ServiceContainer.instance.register(PublisherListInteractor.self) { service in
            return PublisherListInteractor(publisher: service.get())
        }
        ServiceContainer.instance.register(PublisherDetailInteractor.self) { service in
            return PublisherDetailInteractor(gameRepo: service.get(), publisherRepo: service.get())
        }
        ServiceContainer.instance.register(GenreDetailInteractor.self) { service in
            return GenreDetailInteractor(gameRepo: service.get(), genreRepo: service.get())
        }
        ServiceContainer.instance.register(GenreListInteractor.self) { service in
            return GenreListInteractor(genreRepo: service.get())
        }
        ServiceContainer.instance.register(GameDetailInteractor.self) { service in
            return GameDetailInteractor(gameRepo: service.get())
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var currentTab: Tab = .home

    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView {
                HomeScreen(model: .init(interactor: ServiceContainer.instance.get()))
                    .navigationBarTitle("Games catalogue", displayMode: .large)
            }
            .tag(Tab.home)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            NavigationView {
                FavouritesScreen(model: .init(interactor: ServiceContainer.instance.get()))
                    .navigationBarTitle("Favourite Games", displayMode: .large)
            }
            .tag(Tab.favourite)
            .tabItem {
                Image(systemName: "heart")
                Text("Favourites")
            }

            NavigationView {
                ProfileScreen(model: .init(interactor: ServiceContainer.instance.get()))
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
