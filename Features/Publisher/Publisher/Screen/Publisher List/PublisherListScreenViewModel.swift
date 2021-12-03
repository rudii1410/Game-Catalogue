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

class PublisherListScreenViewModel: ObservableObject {
    @Published var gamePublisher: [BaseDetail] = []
    @Published var navigateToPublisherDetail = false
    @Published var showErrorNetwork = false
    var selectedPublisher: BaseDetail?

    private var isLoadingMoreData = false
    private var page = 2
    private var cancellableSet: Set<AnyCancellable> = []
    private let publisherListUsecase: PublisherListUseCase

    init(interactor: PublisherListUseCase) {
        self.publisherListUsecase = interactor
    }

    public func onItemPressed(_ item: BaseDetail) {
        self.selectedPublisher = item
        self.navigateToPublisherDetail = true
    }

    public func loadMorePublisherIfNeeded(_ item: BaseDetail?) {
        if isLoadingMoreData { return }
        guard let item = item else {
            loadMore()
            return
        }

        let tresholdIdx = gamePublisher.index(gamePublisher.endIndex, offsetBy: -3)
        if gamePublisher.firstIndex(where: { $0.id == item.id }) == tresholdIdx {
            loadMore()
        }
    }

    private func loadMore() {
        isLoadingMoreData = true
        self.publisherListUsecase
            .getPublisherList(page: page, count: 10)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.gamePublisher.append(contentsOf: response)
                    self.page += 1
                    self.isLoadingMoreData = false
                }
            )
            .store(in: &cancellableSet)
    }
}

struct PublisherModel: Hashable {
    let ids: String, label: String, imgUrl: String
}
