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

import Foundation
import Combine

class PublisherDetailScreenViewModel: ObservableObject {
    @Published var imageUrl = ""
    @Published var desc = ""
    @Published var gameTitle = ""
    @Published var gameList: [GameShort] = []

    private var isLoadingMoreData = false
    private var page = 1
    private var slug = ""

    private let publisherRepo = GamePublisherRepository()
    private let gameRepo = GameRepository()

    func loadData(_ slug: String) {
        self.slug = slug
        loadPublisherDetail()
        loadGameList()
    }

    func loadMoreGameIfNeeded(_ item: GameShort? = nil) {
        if isLoadingMoreData { return }
        guard let item = item else {
            loadGameList()
            return
        }

        let tresholdIdx = gameList.index(gameList.endIndex, offsetBy: -3)
        if gameList.firstIndex(where: { $0.id == item.id }) == tresholdIdx {
            loadGameList()
        }
    }

    private func loadPublisherDetail() {
        publisherRepo.getPublisherDetail(id: slug) { response in
            guard let result = response.response else { return }

            DispatchQueue.main.async {
                self.gameTitle = result.name
                self.imageUrl = result.imageBackground
                self.desc = result.publisherDescription ?? "" // TODO: revised later
            }
        }
    }

    private func loadGameList() {
        isLoadingMoreData = true
        gameRepo.getGameListByPublisher(
            publisherId: slug,
            page: page,
            count: Constant.maxGameDataLoad
        ) { response in
            guard let result = response.response?.results else { return }

            DispatchQueue.main.async {
                self.gameList.append(contentsOf: result)
                self.page += 1
                self.isLoadingMoreData = false
            }
        }
    }
}
