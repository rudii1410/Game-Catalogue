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

import SwiftUI
import Combine

private let defaultImage = UIImage(named: "placeholder") ?? UIImage()

struct LoadableImage<Content>: View where Content: View {
    @ObservedObject private var imageLoader = ImageLoader()
    @State private var image = defaultImage
    private let callback: (Image) -> Content
    private let urlStr: String

    init(
        _ urlStr: String,
        @ViewBuilder callback: @escaping (_ img: Image) -> Content
    ) {
        print("loadable image created")
        self.urlStr = urlStr
        self.callback = callback
    }

    var body: some View {
        self.callback(Image(uiImage: self.image))
            .onReceive(self.imageLoader.didChange) { data in
                self.image = data
            }
            .onAppear {
                self.imageLoader.load(urlStr)
            }
    }
}

private class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<UIImage, Never>()

    private let mainQueue = DispatchQueue.main
    private let imageQueue = DispatchQueue.global(qos: .userInteractive)
    private let maxRetryAttempt = 5
    private var urlCache = URLCache.shared
    private var memImageCache = ImageCache.getImageCache()

    init() {
        print("image loader created")
    }

    func load(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        loadFromMemCache(url: url)
    }

    private func loadFromMemCache(url: URL) {
        guard let fromMemCache = self.memImageCache.get(forKey: url.absoluteString) else {
            self.loadFromUrlCache(url: url)
            return
        }
        print("loading image from mem cache \(String(describing: url.absoluteString))")
        self.didChange.send(fromMemCache)
    }

    private func loadFromUrlCache(url: URL) {
        let request = URLRequest(
            url: url,
            cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad,
            timeoutInterval: 60
        )

        guard let cacheImageData = self.urlCache.cachedResponse(for: request)?.data else {
            self.loadFromUrl(url: url, request: request)
            return
        }
        guard let imageData = UIImage(data: cacheImageData) else {
            self.loadFromUrl(url: url, request: request)
            return
        }

        print("loading image from url cache \(String(describing: url.absoluteString))")
        self.mainQueue.async {
            self.didChange.send(imageData)
        }
    }

    private func loadFromUrl(url: URL, request: URLRequest, retry: Int = 1) {
        if retry == maxRetryAttempt { return }

        print("fetch from url attempt \(retry) \(String(describing: request.url?.absoluteString))")
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data, let response = response else {
                self.loadFromUrl(url: url, request: request, retry: retry + 1)
                return
            }

            guard let imageData = UIImage(data: data) else {
                self.loadFromUrl(url: url, request: request, retry: retry + 1)
                return
            }

            self.mainQueue.async {
                self.didChange.send(imageData)
                self.urlCache.storeCachedResponse(
                    CachedURLResponse(response: response, data: data),
                    for: request
                )
                self.memImageCache.set(
                    forKey: url.absoluteString,
                    image: imageData
                )
            }
        }
        .resume()
    }
}

private class ImageCache {
    var cache = NSCache<NSString, UIImage>()

    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }

    func set(forKey: String, image: UIImage) {
        print("store")
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

private extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
