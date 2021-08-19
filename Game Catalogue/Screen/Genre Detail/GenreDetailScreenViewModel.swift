//
//  GenreDetailScreenViewModel.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import Combine

class GenreDetailScreenViewModel: ObservableObject {
    @Published var publisherDetail: PublisherModel?
    @Published var gameList: [GameShort] = []
}
