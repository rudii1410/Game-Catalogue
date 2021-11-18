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

class GameDetailScreenViewModel: ObservableObject {
    @Published var bannerImage: String = ""
    @Published var gameTitle: String = "Game title"
    @Published var genreStr: String = ""
    @Published var rating: String = "0"
    @Published var ratingCount: String = "0"
    @Published var desc: String = "<p></p>"
    @Published var screenshots: [String] = ["", "", ""]
    @Published var platformStr: String = ""
    @Published var releaseDate: String = ""
    @Published var developers: String = ""
    @Published var publisher: String = ""
    @Published var gameList: [GameShort] = []
    @Published var isLoading = true
    @Published var navigateToGameDetail = false
    @Published var showErrorNetwork = false
    @Published var favouriteData: Favourite?
    @Published var imgFadeOut = false

    var selectedGameSlug = ""

    private var currentgameSlug = ""
    private var currentGameGenreId = ""
    private var page = 1
    private var isLoadingMoreData = false
    private let mainQueue: DispatchQueue = .main
    private var genreSlugStr = ""
    private var isLoadingData = true
    private var isLoadingScreenshot = true
    private var cancellableSet: Set<AnyCancellable> = []
    let container: ServiceContainer
    private let gameRepo: GameRepositoryImpl

    init(container: ServiceContainer) {
        self.container = container
        self.gameRepo = container.get()
    }

    func onGameTap(_ slug: String) {
        self.selectedGameSlug = slug
        self.navigateToGameDetail = true
    }

    func onFavouriteTap() {
        let database: Database = self.container.get()
        guard let favData = favouriteData else {
            let convertedDate = self.releaseDate.toDate(format: "MMM d, y")
            let favourite = Favourite(context: database.bgContext)
            favourite.slug = self.currentgameSlug
            favourite.name = self.gameTitle
            favourite.image = self.bannerImage
            favourite.rating = Double(self.rating) ?? 0
            favourite.releaseDate = convertedDate
            favourite.genres = self.currentGameGenreId
            favourite.createdAt = Date()

            gameRepo
                .addGameToFavourites(favourite)
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    self.favouriteData = favourite
                })
                .store(in: &cancellableSet)

            return
        }

        gameRepo
            .removeGameFromFavourites(favData)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellableSet)
        favouriteData = nil
    }

    func loadGames() {
        if isLoadingMoreData || genreSlugStr.isEmpty { return }

        isLoadingMoreData = true
        gameRepo
            .getGameListByGenres(genres: self.genreSlugStr, page: self.page, count: Constant.maxGameDataLoad)
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

    func loadGameDetail(slug: String) {
        self.isLoading = true
        self.isLoadingData = true
        self.isLoadingScreenshot = true
        self.currentgameSlug = slug

        gameRepo
            .getFavouriteBySlug(slug: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    self.favouriteData = result
                }
            )
            .store(in: &cancellableSet)

        gameRepo
            .getGameDetail(id: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    self.currentGameGenreId     = self.joinArrayString(result.genres?.map { String($0.id) }, ",")
                    self.bannerImage            = result.backgroundImage
                    self.gameTitle              = result.name
                    self.genreStr               = self.joinArrayString(result.genres?.map { $0.name })
                    self.rating                 = String(result.rating ?? 0)
                    self.ratingCount            = String(result.ratingsCount ?? 0)
                    self.desc                   = result.description
                    self.platformStr            = self.joinArrayString(result.platforms?.map { $0.platform.name })
                    self.releaseDate            = self.reformatDate(date: result.released)
                    self.developers             = self.joinArrayString(result.developers?.map { $0.name })
                    self.publisher              = self.joinArrayString(result.publishers?.map { $0.name })
                    self.genreSlugStr           = self.joinArrayString(result.genres?.map { $0.slug })
                    self.isLoadingData          = false

                    self.updateLoadingState()
                    self.loadGames()
                }
            )
            .store(in: &cancellableSet)

        gameRepo
            .getGameScreenShots(id: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {response in
                    self.screenshots = response.results.map { $0.image }
                    self.isLoadingScreenshot = false
                    self.updateLoadingState()
                }
            )
            .store(in: &cancellableSet)
    }

    private func updateLoadingState() {
        self.isLoading = self.isLoadingData || self.isLoadingScreenshot
    }

    private func reformatDate(date: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let convertedDate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "MMM d, y"
        return dateFormatter.string(from: convertedDate)
    }

    private func joinArrayString(_ arr: [String]?, _ separator: String = ", ") -> String {
        return arr?.joined(separator: ", ") ?? ""
    }
}
