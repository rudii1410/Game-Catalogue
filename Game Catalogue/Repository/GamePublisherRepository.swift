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

import Keys

class GamePublisherRepository {
    func getPublisherList(
        page: Int,
        count: Int,
        callback: @escaping (Response<ListResponse<BaseDetail>>) -> Void
    ) {
        Request("\(Constant.rawgApiUrl)/publishers")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .result(callback)
    }

    func getPublisherDetail(id: String, callback: @escaping (Response<BaseDetail>) -> Void) {
        Request("\(Constant.rawgApiUrl)/publishers/\(id)")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .result(callback)
    }
}
