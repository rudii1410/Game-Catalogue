//
//  GameDetailViewModel.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import Combine

class GameDetailScreenViewModel: ObservableObject {
    @Published var imageUrls: [String] = []
    @Published var selectedTab: Int = 0
}
