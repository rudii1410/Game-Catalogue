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
    @Published var showErrorNetwork = false

    var upcomingGames: [GameShort] = []
    var publisherList: [BaseDetail] = []
    var genreList: [BaseDetail] = []
    var selectedPublisherSlug = ""
    var selectedGenreSlug = ""
    var selectedGameSlug = ""
    private var gameListPage = 1
    private var cancellableSet: Set<AnyCancellable> = []

    private let gameRepo = GameRepositoryImpl()
    private let publisherRepo = GamePublisherRepositoryImpl()
    private let genreRepo = GameGenreRepositoryImpl()

    public func onBannerImagePressed(_ idx: Int) {
        self.onGameSelected(self.upcomingGames[idx].slug)
    }

    func fetchUpcomingReleaseGame() {
        print("fetching upcoming release")
        gameRepo
            .getUpcomingRelease()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.upcomingGames = response.results
                    var banner: [String] = []
                    for data in response.results {
                        banner.append(data.backgroundImage)
                    }
                    self.upcomingGamesBanner = banner
                }
            )
            .store(in: &cancellableSet)
    }

    func fetchPublisherList() {
        publisherRepo
            .getPublisherList(page: 1, count: Constant.maxPublisherDataLoad)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.publisherList = response.results
                    var listData: [ItemListHorizontalData] = []
                    for data in response.results {
                        listData.append(
                            ItemListHorizontalData(id: data.slug, imageUrl: data.imageBackground, title: data.name)
                        )
                    }
                    self.gamePublisherList = listData
                }
            )
            .store(in: &cancellableSet)
    }

    func fetchGenreList() {
        genreRepo
            .getGenreList(page: 1, count: Constant.maxGenreDataLoad)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.genreList = response.results
                    let listData = response.results[...5].map { data in
                        ItemGridData(id: data.slug, imageUrl: data.imageBackground, title: data.name)
                    }
                    self.gameGenreList = listData
                }
            )
            .store(in: &cancellableSet)
    }

    func fetchGameList() {
        if self.isLoadingGameData { return }
        self.isLoadingGameData = true

        gameRepo
            .getUserFavouriteGameGenre()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    let genres = result.isEmpty ? "action" : result.joined(separator: ",")

                    self.gameRepo
                        .getGameListByGenres(genres: genres, page: self.gameListPage, count: Constant.maxGameDataLoad)
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { response in
                                self.gameList.append(contentsOf: response.results)
                                self.gameListPage += 1
                                self.isLoadingGameData = false
                            }
                        )
                        .store(in: &self.cancellableSet)
                }
            )
            .store(in: &cancellableSet)
    }

    func onGameSelected(_ slug: String) {
        self.selectedGameSlug = slug
        self.navigateToGameDetail = true
    }
}
