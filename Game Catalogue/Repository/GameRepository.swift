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
import Keys

class GameRepository {
    func getUpcomingRelease(
        endDate inputEndDate: Date? = nil,
        count: Int = 10,
        callback: @escaping (Response<RAWGResponse<GameShort>>) -> Void
    ) {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        guard let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) else {
            return // TODO: revisit this later
        }

        var tempEndDate = inputEndDate
        if tempEndDate == nil {
            dateComponent.month = 3
            tempEndDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        }
        guard let endDate = tempEndDate else {
            return // TODO: revisit this later
        }

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let fDates = "\(format.string(from: startDate)),\(format.string(from: endDate))"

        Request("\(Constant.rawgApiUrl)/games")
            .addQuery(key: "key", value: GameCatalogueKeys().rawgApiKey)
            .addQuery(key: "dates", value: fDates)
            .addQuery(key: "ordering", value: "-rating")
            .addQuery(key: "page_size", value: String(count))
            .result(callback)
    }
}
