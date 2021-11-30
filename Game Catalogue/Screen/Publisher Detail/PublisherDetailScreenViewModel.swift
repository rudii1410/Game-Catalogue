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
import Common

class PublisherDetailScreenViewModel: ObservableObject {
    @Published var imageUrl = ""
    @Published var desc = ""
    @Published var gameTitle = ""
    @Published var gameList: [Game] = []
    @Published var navigateToGameDetail = false
    @Published var showErrorNetwork = false

    var selectedGameSlug = ""
    private var isLoadingMoreData = false
    private var page = 1
    private var slug = ""
    private var cancellableSet: Set<AnyCancellable> = []

    private let publisherDetailUseCase: PublisherDetailUseCase

    init(interactor: PublisherDetailInteractor) {
        self.publisherDetailUseCase = interactor
    }

    func loadData(_ slug: String) {
        self.slug = slug
        loadPublisherDetail()
        loadGameList()
    }

    func onGameTap(_ slug: String) {
        self.selectedGameSlug = slug
        self.navigateToGameDetail = true
    }

    func loadGameList() {
        if self.isLoadingMoreData { return }

        isLoadingMoreData = true
        self.publisherDetailUseCase
            .getGameListByPublisher(publisherId: slug, page: page, count: Constant.maxGameDataLoad)
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

    private func loadPublisherDetail() {
        self.publisherDetailUseCase
            .getPublisherDetail(id: slug)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    self.gameTitle = result.name
                    self.imageUrl = result.imageBackground
                    self.desc = result.description ?? ""
                }
            )
            .store(in: &cancellableSet)
    }
}
