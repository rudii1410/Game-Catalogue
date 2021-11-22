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
        let database = Database()
        let gameRepo = GameRepository(
            local: LocalDataSource.instance(database),
            remote: RemoteDataSource.instance,
            database: database
        )
        let publisherRepo = GamePublisherRepository(remote: RemoteDataSource.instance)
        let genreRepo = GameGenreRepository(remote: RemoteDataSource.instance)
        let profileRepo = ProfileRepository(userDef: UserDefaults.standard)

        ServiceContainer.instance.register(
            HomeInteractor(
                gameRepo: gameRepo,
                publisherRepo: publisherRepo,
                genreRepo: genreRepo
            )
        )
        ServiceContainer.instance.register(FavouriteInteractor(gameRepo: gameRepo))
        ServiceContainer.instance.register(ProfileInteractor(profileRepo: profileRepo))
        ServiceContainer.instance.register(PublisherListInteractor(publisher: publisherRepo))
        ServiceContainer.instance.register(
            PublisherDetailInteractor(gameRepo: gameRepo, publisherRepo: publisherRepo)
        )
        ServiceContainer.instance.register(
            GenreDetailInteractor(gameRepo: gameRepo, genreRepo: genreRepo)
        )
        ServiceContainer.instance.register(GenreListInteractor(genreRepo: genreRepo))
        ServiceContainer.instance.register(GameDetailInteractor(gameRepo: gameRepo))
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
