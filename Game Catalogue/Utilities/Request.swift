//
//  Request.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 18/08/21.
//

import Foundation

// MARK: - RequestMethod
enum RequestMethod: String {
    case GET
    case POST
}

// MARK: - RequestError
enum RequestError: Error {
    case initializeUrlError(String)
    case serverError(String)
    case parsingError(String)
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
            requestCallback(Response<T>(error: RequestError.initializeUrlError("Error initializing url")))
            return
        }

        var request = URLRequest(url: url)
        for (key, value) in self.header {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = self.method

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                requestCallback(Response<T>(error: RequestError.serverError(error?.localizedDescription ?? "Error")))
                return
            }

            do {
                guard let data = data else {
                    requestCallback(Response<T>(error: RequestError.serverError("null response")))
                    return
                }
                let object = try JSONDecoder().decode(T.self, from: data)
                requestCallback(Response(success: object))
            } catch {
                requestCallback(Response(error: RequestError.parsingError("null response")))
                return
            }
        }.resume()
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
