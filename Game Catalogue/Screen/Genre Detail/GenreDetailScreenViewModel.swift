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

class GenreDetailScreenViewModel: ObservableObject {
    @Published var imageUrl = ""
    @Published var desc = ""
    @Published var genreTitle = ""
    @Published var gameList: [GameShort] = []
    @Published var navigateToGameDetail = false
    @Published var showErrorNetwork = false

    var selectedGameSlug = ""
    private var isLoadingMoreData = false
    private var page = 1
    private var slug = ""
    private var cancellableSet: Set<AnyCancellable> = []

    let container: ServiceContainer
    private let genreRepo: GameGenreRepositoryImpl
    private let gameRepo: GameRepositoryImpl

    init(container: ServiceContainer) {
        self.container = container
        self.genreRepo = container.get()
        self.gameRepo = container.get()
    }

    func loadData(_ slug: String) {
        self.slug = slug
        loadGenreDetail()
        loadGameList()
    }

    func onGameTap(_ slug: String) {
        self.selectedGameSlug = slug
        self.navigateToGameDetail = true
    }

    func loadGameList() {
        if isLoadingMoreData { return }

        isLoadingMoreData = true
        gameRepo
            .getGameListByGenres(genres: slug, page: page, count: Constant.maxGameDataLoad)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.gameList.append(contentsOf: response.results)
                    self.page += 1
                    self.isLoadingMoreData = false
                }
            )
            .store(in: &cancellableSet)
    }

    private func loadGenreDetail() {
        genreRepo
            .getGenreDetail(id: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    self.genreTitle = result.name
                    self.imageUrl = result.imageBackground
                    self.desc = result.description ?? ""
                }
            )
            .store(in: &cancellableSet)
    }
}
