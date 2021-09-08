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

class PublisherListScreenViewModel: ObservableObject {
    @Published var gamePublisher: [BaseDetail] = []
    @Published var navigateToPublisherDetail = false
    @Published var showErrorNetwork = false
    var selectedPublisher: BaseDetail?

    private var isLoadingMoreData = false
    private var page = 2

    private let publisherRepo = GamePublisherRepository()

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
        publisherRepo.getPublisherList(page: page, count: Constant.maxPublisherDataLoad) { response in
            guard let result = response.response?.results else {
                if response.error?.type == RequestError.NetworkError {
                    self.showErrorNetwork = true
                }
                return
            }

            DispatchQueue.main.async {
                self.gamePublisher.append(contentsOf: result)
                self.page += 1
                self.isLoadingMoreData = false
            }
        }
    }
}

struct PublisherModel: Hashable {
    let ids: String, label: String, imgUrl: String
}
