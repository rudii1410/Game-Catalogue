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
import Common

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
    @Published var gameList: [Game] = []
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
    private let gameDetailUseCase: GameDetailUseCase

    init(interactor: GameDetailUseCase) {
        self.gameDetailUseCase = interactor
    }

    func onGameTap(_ slug: String) {
        self.selectedGameSlug = slug
        self.navigateToGameDetail = true
    }

    func onFavouriteTap() {
        guard let favData = favouriteData else {
            let convertedDate = self.releaseDate.toDate(format: "MMM d, y")
            let favourite = Favourite(
                createdAt: Date(),
                image: self.bannerImage,
                name: self.gameTitle,
                rating: Double(self.rating) ?? 0,
                releaseDate: convertedDate,
                slug: self.currentgameSlug,
                genres: self.currentGameGenreId
            )

            self.gameDetailUseCase
                .addGameToFavourites(favourite)
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    self.favouriteData = favourite
                })
                .store(in: &cancellableSet)

            return
        }

        self.gameDetailUseCase
            .removeGameFromFavourites(favData.slug)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellableSet)
        favouriteData = nil
    }

    func loadGames() {
        if isLoadingMoreData || genreSlugStr.isEmpty { return }

        isLoadingMoreData = true
        self.gameDetailUseCase
            .getGameListByGenres(genres: self.genreSlugStr, page: self.page, count: 10)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.gameList.append(contentsOf: response)
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

        self.gameDetailUseCase
            .getFavouriteBySlug(slug: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    self.favouriteData = result
                }
            )
            .store(in: &cancellableSet)

        self.gameDetailUseCase
            .getGameDetail(id: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    let platformStr = self.joinArrayString(result.platforms?.map { $0.platform?.name ?? "" })

                    self.currentGameGenreId = self.joinArrayString(result.genres?.map { String($0.id) }, ",")
                    self.bannerImage = result.imageBackground
                    self.gameTitle = result.name
                    self.genreStr = self.joinArrayString(result.genres?.map { $0.name })
                    self.rating = String(result.rating ?? 0)
                    self.ratingCount = String(result.ratingsCount ?? 0)
                    self.desc = result.description ?? ""
                    self.platformStr = platformStr
                    self.releaseDate = self.reformatDate(date: result.released)
                    self.developers = self.joinArrayString(result.developers?.map { $0.name })
                    self.publisher = self.joinArrayString(result.publishers?.map { $0.name })
                    self.genreSlugStr = self.joinArrayString(result.genres?.map { $0.slug })
                    self.isLoadingData = false

                    self.updateLoadingState()
                    self.loadGames()
                }
            )
            .store(in: &cancellableSet)

        self.gameDetailUseCase
            .getGameScreenShots(id: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {response in
                    self.screenshots = response.map { $0.image }
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
