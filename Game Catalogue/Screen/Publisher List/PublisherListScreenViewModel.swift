//
//  PublisherListScreenViewModel.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import Foundation
import Combine

class PublisherListScreenViewModel: ObservableObject {
    @Published var gamePublisher: [PublisherModel] = []
    @Published var navigateToPublisherDetail: Bool = false
    var selectedPublisher: PublisherModel?

    private var isLoadingMoreData: Bool = false

    init() {
        loadMorePublisherIfNeeded(nil)
    }
    
    public func onItemPressed(_ item: PublisherModel) {
        self.selectedPublisher = item
        self.navigateToPublisherDetail = true
    }

    public func loadMorePublisherIfNeeded(_ item: PublisherModel?) {
        if isLoadingMoreData { return }
        guard let item = item else {
            loadMore()
            return
        }

        let tresholdIdx = gamePublisher.index(gamePublisher.endIndex, offsetBy: -3)
        if gamePublisher.firstIndex(where: { $0.ids == item.ids }) == tresholdIdx {
            loadMore()
        }
    }

    private func loadMore() {
        isLoadingMoreData = true
        let publishers = (0...25).map { _ in
            PublisherModel(
                ids: UUID.init().uuidString,
                label: "Publisher",
                imgUrl: "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg"
            )
        }
        self.gamePublisher.append(contentsOf: publishers)
        isLoadingMoreData = false
    }
}

struct PublisherModel: Hashable {
    let ids: String, label: String, imgUrl: String
}
