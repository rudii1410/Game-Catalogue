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

class GameRepository {
    func getUpcomingRelease(
        endDate inputEndDate: Date? = nil,
        page: Int = 1,
        count: Int = 10,
        callback: @escaping (Response<RAWGResponse<GameShort>>) -> Void
    ) {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        guard let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) else {
            return
        }

        var tempEndDate = inputEndDate
        if tempEndDate == nil {
            dateComponent.month = 3
            tempEndDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        }
        guard let endDate = tempEndDate else {
            return
        }

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let fDates = "\(format.string(from: startDate)),\(format.string(from: endDate))"

        Request("\(Constant.rawgApiUrl)/games")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .addQuery(key: "dates", value: fDates)
            .addQuery(key: "ordering", value: "-rating")
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .result(callback)
    }

    func getGameListByPublisher(
        publisherId: String,
        page: Int = 1,
        count: Int = 10,
        callback: @escaping (Response<RAWGResponse<GameShort>>) -> Void
    ) {
        Request("\(Constant.rawgApiUrl)/games")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .addQuery(key: "publishers", value: publisherId)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .result(callback)
    }

    func getGameListByGenres(
        genres: String,
        page: Int = 1,
        count: Int = 10,
        callback: @escaping (Response<RAWGResponse<GameShort>>) -> Void
    ) {
        Request("\(Constant.rawgApiUrl)/games")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .addQuery(key: "genres", value: genres)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .result(callback)
    }

    func getGameDetail(id: String, callback: @escaping (Response<GameDetail>) -> Void) {
        Request("\(Constant.rawgApiUrl)/games/\(id)")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .result(callback)
    }

    func getGameScreenShots(
        id: String,
        callback: @escaping (Response<RAWGResponse<Screenshot>>) -> Void
    ) {
        Request("\(Constant.rawgApiUrl)/games/\(id)/screenshots")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .addQuery(key: "page_size", value: "10")
            .result(callback)
    }
}
