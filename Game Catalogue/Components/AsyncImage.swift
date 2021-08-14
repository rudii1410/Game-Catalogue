//
//  AsyncImage.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 14/08/21.
//

import SwiftUI
import Combine

struct AsyncImage: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()

    init(urlStr: String) {
        imageLoader = ImageLoader(urlStr: urlStr)
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .onReceive(imageLoader.didChange) { data in
                self.image = data
            }
            .cornerRadius(10)
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<UIImage, Never>()
    var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }
    private let defaultImage = UIImage() // TODO: placeholer image

    init(urlStr: String) {
        image = defaultImage

        guard let url = URL(string: urlStr) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? self.defaultImage
            }
        }.resume()
    }
}
