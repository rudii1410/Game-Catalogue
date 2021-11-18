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
import Keys

protocol GamePublisherRepository {
    func getPublisherList(page: Int, count: Int) -> AnyPublisher<ListResponse<BaseDetail>, Error>
    func getPublisherDetail(id: String) -> AnyPublisher<BaseDetail, Error>
}

class GamePublisherRepositoryImpl: GamePublisherRepository {
    private let rawgApiKey = GameCatalogueKeys().rawgApiKey

    func getPublisherList(page: Int, count: Int) -> AnyPublisher<ListResponse<BaseDetail>, Error> {
        return Request("\(Constant.rawgApiUrl)/publishers")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    func getPublisherDetail(id: String) -> AnyPublisher<BaseDetail, Error> {
        return Request("\(Constant.rawgApiUrl)/publishers/\(id)")
            .addQuery(key: "key", value: rawgApiKey)
            .resultPublisher()
    }
}
