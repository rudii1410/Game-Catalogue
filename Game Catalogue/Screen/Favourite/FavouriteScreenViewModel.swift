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

class FavouriteScreenViewModel: ObservableObject {
    @Published var favourites: [Favourite] = []
    @Published var selectedSlug = ""
    @Published var navigateToGameDetail = false

    private var dataOffset = 0
    private var isLoadingMoreData = false
    private var canLoadMoreData = true
    private let gameRepo: GameRepositoryImpl
    private var cancellableSet: Set<AnyCancellable> = []
    let container: ServiceContainer

    init(container: ServiceContainer) {
        self.container = container
        self.gameRepo = container.get()
    }

    func performDelete(index: IndexSet) {
        index.forEach {
            gameRepo
                .removeGameFromFavourites(favourites[$0])
                .sink(receiveCompletion: { _ in }, receiveValue: {})
                .store(in: &cancellableSet)
            favourites.remove(at: $0)
        }
    }

    func onItemTap(slug: String) {
        selectedSlug = slug
        navigateToGameDetail = true
    }

    func reloadData() {
        favourites = []
        dataOffset = 0
        isLoadingMoreData = false
        canLoadMoreData = false
        loadFavouriteIfNeeded(nil)
    }

    func loadFavouriteIfNeeded(_ favourite: Favourite?) {
        if isLoadingMoreData && canLoadMoreData { return }
        guard let item = favourite else {
            loadMore()
            return
        }

        let tresholdIdx = favourites.index(favourites.endIndex, offsetBy: -2)
        if favourites.firstIndex(where: { $0.slug == item.slug }) == tresholdIdx {
            loadMore()
        }
    }

    private func loadMore() {
        isLoadingMoreData = true
        gameRepo
            .fetchFavourites(offset: dataOffset, limit: 10)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    if result.isEmpty {
                        self.canLoadMoreData = false
                        return
                    }
                    self.favourites += result
                    self.dataOffset += 10
                    self.isLoadingMoreData = false
                }
            )
            .store(in: &cancellableSet)
    }
}
