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
import SwiftUI

// MARK: - RequestMethod
enum RequestMethod: String {
    case GET
    case POST
}

// MARK: - RequestError
struct RequestError {
    static let NetworkError = 0
    static let URLInitializationError = 1
    static let ServerError = 2

    let type: Int
    let message: String

    init(_ type: Int, message: String? = nil) {
        self.type = type
        self.message = message ?? ""
    }
}


// MARK: - Generic Response
class Response<T: Codable> {
    let isSuccess: Bool
    let error: RequestError?
    let response: T?

    init(error: RequestError? = nil, success: T? = nil) {
        self.error = error
        self.response = success
        self.isSuccess = error == nil && success != nil
    }
}

// MARK: - Request
class Request {
    private var urlStr: String
    private var method: String
    private var query: [String: String] = [:]
    private var header: [String: String] = [:]
    private var body: Any = {}

    init(_ url: String, method: RequestMethod = .GET) {
        self.urlStr = url
        self.method = method.rawValue

        self.header["Content-Type"] = "application/json"
    }

    public func addQuery(key: String, value: String) -> Request {
        self.query[key] = value
        return self
    }

    public func addHeader(key: String, value: String) -> Request {
        self.header[key] = value
        return self
    }

    public func result<T: Codable>(_ requestCallback: @escaping (Response<T>) -> Void) {
        guard let url = constructUrl() else {
            requestCallback(Response<T>(
                error: RequestError(RequestError.URLInitializationError, message: "Error initializing url")
            ))
            return
        }

        var request = URLRequest(url: url)
        for (key, value) in self.header {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = self.method

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                var responseError = RequestError(RequestError.ServerError, message: error?.localizedDescription)
                if error is URLError {
                    if let urlErr = error as? URLError, urlErr.code == URLError.Code.notConnectedToInternet {
                        responseError = RequestError(RequestError.NetworkError, message: error?.localizedDescription)
                    }
                }

                requestCallback(Response<T>(error: responseError))
                return
            }

            do {
                guard let data = data else {
                    requestCallback(
                        Response<T>(error: RequestError(RequestError.ServerError, message: "response null"))
                    )
                    return
                }
                let object = try JSONDecoder().decode(T.self, from: data)
                requestCallback(Response(success: object))
            } catch {
                requestCallback(
                    Response<T>(error: RequestError(RequestError.ServerError, message: "response null"))
                )
                return
            }
        }
        .resume()
    }

    private func constructUrl() -> URL? {
        var queryItems: [URLQueryItem] = []
        for (key, value) in self.query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        guard var rawUrl = URLComponents(string: self.urlStr) else { return nil }
        rawUrl.queryItems = queryItems

        return rawUrl.url?.absoluteURL
    }
}
