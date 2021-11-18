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
    private let serviceContainer = ServiceContainer()

    init() {
        serviceContainer.register(Database())
        serviceContainer.register(UserDefaults.standard)
        serviceContainer.register(GameRepositoryImpl(database: serviceContainer.get()))
        serviceContainer.register(ProfileRepository(userDef: serviceContainer.get()))
        serviceContainer.register(GamePublisherRepositoryImpl())
        serviceContainer.register(GameGenreRepositoryImpl())
    }

    var body: some Scene {
        WindowGroup {
            ContentView(container: self.serviceContainer)
        }
    }
}

struct ContentView: View {
    @State private var currentTab: Tab = .home
    private let serviceContainer: ServiceContainer

    init(container: ServiceContainer) {
        self.serviceContainer = container
    }

    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView {
                HomeScreen(container: self.serviceContainer)
                    .navigationBarTitle("Games catalogue", displayMode: .large)
            }
            .tag(Tab.home)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            NavigationView {
                FavouritesScreen(container: self.serviceContainer)
                    .navigationBarTitle("Favourite Games", displayMode: .large)
            }
            .tag(Tab.favourite)
            .tabItem {
                Image(systemName: "heart")
                Text("Favourites")
            }

            NavigationView {
                ProfileScreen(container: self.serviceContainer)
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
