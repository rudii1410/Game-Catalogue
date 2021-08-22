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
    @ObservedObject private var imageLoader: ImageLoader
    @State private var image = defaultImage
    private let callback: (Image) -> Content

    init(
        _ urlStr: String,
        @ViewBuilder callback: @escaping (_ img: Image) -> Content
    ) {
        imageLoader = ImageLoader(urlStr: urlStr)
        self.callback = callback
    }

    var body: some View {
        self.callback(Image(uiImage: self.image))
            .onReceive(imageLoader.didChange) { data in
                self.image = data
            }
            .onAppear { imageLoader.load() }
    }
}

private class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<UIImage, Never>()
    var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }
    private var url: URL?

    init(urlStr: String) {
        image = defaultImage
        print(urlStr)
        self.url = URL(string: urlStr)
    }

    func load() {
        guard let url = self.url else {
            print("fail to load url image")
            return
        }
        let cache = URLCache.shared
        let request = URLRequest(
            url: url,
            cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad,
            timeoutInterval: 60
        )
        guard let cacheImageData = cache.cachedResponse(for: request)?.data else {
            URLSession.shared.dataTask(with: url) { data, response, _ in
                guard let data = data, let response = response else { return }
                let cacheData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheData, for: request)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data) ?? defaultImage
                }
            }
            .resume()
            return
        }
        print("loading image from cache \(String(describing: request.url?.absoluteString))")
        self.image = UIImage(data: cacheImageData) ?? defaultImage
    }
}
