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
import Combine
import Core

public protocol RemoteDataSourceInterface {
    func getUpcomingRelease(endDate inputEndDate: Date?, page: Int, count: Int) -> AnyPublisher<RawgListResponse<RawgGameShort>, Error>
    func getGameListByPublisher(publisherId: String, page: Int, count: Int) -> AnyPublisher<RawgListResponse<RawgGameShort>, Error>
    func getGameListByGenres(genres: String, page: Int, count: Int) -> AnyPublisher<RawgListResponse<RawgGameShort>, Error>
    func getGameDetail(id: String) -> AnyPublisher<RawgGameDetail, Error>
    func getGameScreenShots(id: String) -> AnyPublisher<RawgListResponse<RawgScreenshot>, Error>
    func getPublisherList(page: Int, count: Int) -> AnyPublisher<RawgListResponse<RawgBaseDetail>, Error>
    func getPublisherDetail(id: String) -> AnyPublisher<RawgBaseDetail, Error>
    func getGenreList(page: Int, count: Int) -> AnyPublisher<RawgListResponse<RawgBaseDetail>, Error>
    func getGenreDetail(id: String) -> AnyPublisher<RawgBaseDetail, Error>
}

public final class RemoteDataSource: RemoteDataSourceInterface {
    private let rawgApiKey = GameCatalogueKeys().rawgApiKey
    private let rawgApiUrl = "https://api.rawg.io/api"

    public init() {}
}

extension RemoteDataSource {
    public func getUpcomingRelease(
        endDate inputEndDate: Date? = nil,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<RawgListResponse<RawgGameShort>, Error> {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        guard let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) else {
            return Fail<RawgListResponse<RawgGameShort>, Error>(
                error: GenericError.error("invalid start date")
            ).eraseToAnyPublisher()
        }

        var tempEndDate = inputEndDate
        if tempEndDate == nil {
            dateComponent.month = 3
            tempEndDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        }
        guard let endDate = tempEndDate else {
            return Fail<RawgListResponse<RawgGameShort>, Error>(
                error: GenericError.error("invalid end date")
            ).eraseToAnyPublisher()
        }

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let fDates = "\(format.string(from: startDate)),\(format.string(from: endDate))"

        return Request("\(rawgApiUrl)/games")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "dates", value: fDates)
            .addQuery(key: "ordering", value: "-rating")
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    public func getGameListByPublisher(
        publisherId: String,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<RawgListResponse<RawgGameShort>, Error> {
        return Request("\(rawgApiUrl)/games")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "publishers", value: publisherId)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    public func getGameListByGenres(
        genres: String,
        page: Int = 1,
        count: Int = 10
    ) -> AnyPublisher<RawgListResponse<RawgGameShort>, Error> {
        return Request("\(rawgApiUrl)/games")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "genres", value: genres)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    public func getGameDetail(id: String) -> AnyPublisher<RawgGameDetail, Error> {
        return Request("\(rawgApiUrl)/games/\(id)")
            .addQuery(key: "key", value: rawgApiKey)
            .resultPublisher()
    }

    public func getGameScreenShots(id: String) -> AnyPublisher<RawgListResponse<RawgScreenshot>, Error> {
        return Request("\(rawgApiUrl)/games/\(id)/screenshots")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "page_size", value: "10")
            .resultPublisher()
    }

    public func getPublisherList(page: Int, count: Int) -> AnyPublisher<RawgListResponse<RawgBaseDetail>, Error> {
        return Request("\(rawgApiUrl)/publishers")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    public func getPublisherDetail(id: String) -> AnyPublisher<RawgBaseDetail, Error> {
        return Request("\(rawgApiUrl)/publishers/\(id)")
            .addQuery(key: "key", value: rawgApiKey)
            .resultPublisher()
    }

    public func getGenreList(page: Int, count: Int) -> AnyPublisher<RawgListResponse<RawgBaseDetail>, Error> {
        return Request("\(rawgApiUrl)/genres")
            .addQuery(key: "key", value: rawgApiKey)
            .addQuery(key: "page", value: String(page))
            .addQuery(key: "page_size", value: String(count))
            .resultPublisher()
    }

    public func getGenreDetail(id: String) -> AnyPublisher<RawgBaseDetail, Error> {
        return Request("\(rawgApiUrl)/genres/\(id)")
            .addQuery(key: "key", value: rawgApiKey)
            .resultPublisher()
    }
}
