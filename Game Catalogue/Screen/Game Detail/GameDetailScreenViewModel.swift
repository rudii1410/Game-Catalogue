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

    var selectedGameSlug = ""

    private let gameRepo = GameRepository()
    private var page = 1
    private var isLoadingMoreData = false
    private let mainQueue: DispatchQueue = .main
    private var genreSlugStr = ""
    private var isLoadingData = true
    private var isLoadingScreenshot = true

    func onGameTap(_ slug: String) {
        self.selectedGameSlug = slug
        self.navigateToGameDetail = true
    }

    func loadGames() {
        if isLoadingMoreData || genreSlugStr.isEmpty { return }

        isLoadingMoreData = true
        gameRepo.getGameListByGenres(
            genres: self.genreSlugStr,
            page: self.page,
            count: Constant.maxGameDataLoad
        ) { response in
            guard let result = response.response?.results else { return }

            self.mainQueue.async {
                self.gameList.append(contentsOf: result)
                self.page += 1
                self.isLoadingMoreData = false
            }
        }
    }

    func loadGameDetail(slug: String) {
        self.isLoading = true
        self.isLoadingData = true
        self.isLoadingScreenshot = true

        gameRepo.getGameDetail(id: slug) { response in
            guard let result = response.response else {
                if response.error?.type == RequestError.NetworkError {
                    self.showErrorNetwork = true
                }
                return
            }

            let genreStr = result.genres?.map { $0.name }.joined(separator: ", ") ?? ""
            let platformStr = result.platforms?.map { $0.platform.name }.joined(separator: ", ") ?? ""
            let developers = result.developers?.map { $0.name }.joined(separator: ", ") ?? ""
            let publishers = result.publishers?.map { $0.name }.joined(separator: ", ") ?? ""
            self.mainQueue.async {
                self.bannerImage = result.backgroundImage
                self.gameTitle = result.name
                self.genreStr = genreStr
                self.rating = String(result.rating ?? 0)
                self.ratingCount = String(result.ratingsCount ?? 0)
                self.desc = result.description
                self.platformStr = platformStr
                self.releaseDate = self.reformatDate(date: result.released)
                self.developers = developers
                self.publisher = publishers
                self.isLoadingData = false
                self.updateLoadingState()
            }

            self.genreSlugStr = result.genres?.map { $0.slug }.joined(separator: ",") ?? ""
            self.loadGames()
        }
        gameRepo.getGameScreenShots(id: slug) { response in
            guard let result = response.response?.results else { return }
            let screenshots = result.map { $0.image }
            self.mainQueue.async {
                self.screenshots = screenshots
                self.isLoadingScreenshot = false
                self.updateLoadingState()
            }
        }
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
}
