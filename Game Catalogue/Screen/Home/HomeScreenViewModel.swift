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

import Combine
import Foundation
import Keys

class HomeScreenViewModel: ObservableObject {
    @Published var navigateToPublisherList = false
    @Published var navigateToPublisherDetail = false
    @Published var navigateToGenreList = false
    @Published var navigateToGenreDetail = false
    @Published var navigateToGameDetail = false
    @Published var upcomingGamesBanner: [String] = []
    @Published var gamePublisherList: [ItemListHorizontalData] = []
    @Published var gameGenreList: [ItemGridData] = []
    @Published var isLoadingGameData = false
    @Published var gameList: [GameShort] = []

    var upcomingGames: [GameShort] = []
    var publisherList: [Publisher] = []
    var genreList: [Genre] = []
    var selectedPublisherSlug = ""
    var selectedGenreSlug = ""
    var selectedGameSlug = ""
    private var gameListPage = 1

    private let gameRepo = GameRepository()
    private let publisherRepo = GamePublisherRepository()
    private let genreRepo = GameGenreRepository()

    public func onBannerImagePressed(_ idx: Int) {
        self.onGameSelected(self.upcomingGames[idx].slug)
    }

    func fetchUpcomingReleaseGame() {
        gameRepo.getUpcomingRelease { response in
            guard let result = response.response?.results else { return }

            self.upcomingGames = result
            var banner: [String] = []
            for data in result {
                banner.append(data.backgroundImage)
            }
            DispatchQueue.main.async {
                self.upcomingGamesBanner = banner
            }
        }
    }

    func fetchPublisherList() {
        publisherRepo.getPublisherList(page: 1, count: Constant.maxPublisherDataLoad) { response in
            guard let result = response.response?.results else { return }

            self.publisherList = result
            var listData: [ItemListHorizontalData] = []
            for data in result {
                listData.append(
                    ItemListHorizontalData(id: data.slug, imageUrl: data.imageBackground, title: data.name)
                )
            }
            DispatchQueue.main.async {
                self.gamePublisherList = listData
            }
        }
    }

    func fetchGenreList() {
        genreRepo.getGenreList(page: 1, count: Constant.maxGenreDataLoad) { response in
            guard let result = response.response?.results else { return }

            self.genreList = result
            let listData = result[...5].map { data in
                ItemGridData(id: data.slug, imageUrl: data.imageBackground, title: data.name)
            }
            DispatchQueue.main.async {
                self.gameGenreList = listData
            }
        }
    }

    func fetchGameList() {
        if self.isLoadingGameData { return }
        self.isLoadingGameData = true

        gameRepo.getGameListByGenres(
            genres: "action",
            page: self.gameListPage,
            count: Constant.maxGameDataLoad
        ) { response in
            guard let result = response.response?.results else { return }

            DispatchQueue.main.async {
                self.gameList.append(contentsOf: result)
                self.gameListPage += 1
                self.isLoadingGameData = false
            }
        }
    }

    func onGameSelected(_ slug: String) {
        self.selectedGameSlug = slug
        self.navigateToGameDetail = true
    }
}
