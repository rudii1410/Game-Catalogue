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

    var selectedSlug = ""
    private var isLoadingMoreData = false
    private var page = 2
    private let genreRepo = GameGenreRepository()

    public func onItemPressed(_ genre: Genre) {
        selectedSlug = genre.slug
        navigateToGenreDetail = true
    }

    public func loadMoreGenreIfNeeded(_ genre: Genre?) {
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
        genreRepo.getGenreList(page: page, count: Constant.maxGenreDataLoad) { response in
            guard let result = response.response?.results else { return }

            DispatchQueue.main.async {
                self.genreList.append(contentsOf: result)
                self.page += 1
                self.isLoadingMoreData = false
            }
        }
    }
}
