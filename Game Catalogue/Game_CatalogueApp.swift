//
//  Game_CatalogueApp.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 11/08/21.
//

import SwiftUI

@main
struct GameCatalogueApp: App {
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
                HomeScreen()
                    .navigationBarTitle("Games catalogue", displayMode: .large)
            }
            .tag(Tab.home)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            NavigationView {
                FavouritesScreen()
                    .navigationBarTitle("Favourite Games", displayMode: .large)
            }
            .tag(Tab.favourite)
            .tabItem {
                Image(systemName: "heart")
                Text("Favourites")
            }

            NavigationView {
                ProfileScreen()
                    .navigationBarTitle("My Profile", displayMode: .inline)
            }
            .tag(Tab.profile)
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        
    }
}

enum Tab {
    case home
    case favourite
    case profile
}
