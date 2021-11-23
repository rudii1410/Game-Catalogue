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

class GenreListScreenViewModel: ObservableObject {
    @Published var navigateToGenreDetail = false
    @Published var genreList: [Genre] = []
    @Published var showErrorNetwork = false

    var selectedSlug = ""
    private var isLoadingMoreData = false
    private var page = 2
    private var cancellableSet: Set<AnyCancellable> = []
    private let genreListUsecase: GenreListUseCase

    init(interactor: GenreListInteractor) {
        self.genreListUsecase = interactor
    }

    public func onItemPressed(_ genre: BaseDetail) {
        selectedSlug = genre.slug
        navigateToGenreDetail = true
    }

    public func loadMoreGenreIfNeeded(_ genre: BaseDetail?) {
        if isLoadingMoreData { return }
        guard let item = genre else {
            loadMore()
            return
        }

        let tresholdIdx = genreList.index(genreList.endIndex, offsetBy: -3)
        if genreList.firstIndex(where: { $0.id == item.id }) == tresholdIdx {
            loadMore()
        }
    }

    private func loadMore() {
        isLoadingMoreData = true
        self.genreListUsecase
            .getGenreList(page: page, count: Constant.maxGenreDataLoad)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    self.genreList.append(contentsOf: response)
                    self.page += 1
                    self.isLoadingMoreData = false
                }
            )
            .store(in: &cancellableSet)
    }
}
