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
            TabView {
                HomeScreen()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                FavouritesScreen()
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Favourites")
                    }
                ProfileScreen()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
        }
    }
}
