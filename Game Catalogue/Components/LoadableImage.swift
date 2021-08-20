//
//  LoadableImage.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import SwiftUI
import Combine

struct LoadableImage<Content>: View where Content: View {
    @ObservedObject private var imageLoader: ImageLoader
    @State private var image: UIImage = UIImage()
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
    private let defaultImage = UIImage() // TODO: placeholer image
    private var url: URL?

    init(urlStr: String) {
        image = defaultImage
        self.url = URL(string: urlStr)
    }

    func load() {
        guard let url = self.url else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? self.defaultImage
            }
        }.resume()
    }
}
