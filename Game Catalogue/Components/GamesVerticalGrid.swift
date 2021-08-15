//
//  GamesVerticalGrid.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 15/08/21.
//

import SwiftUI

struct GamesVerticalGrid: View {
    private static let ColumnCount = 2
    private static let Spacing = 15
    private static let screenWidth = UIScreen.main.bounds.width
    private let cardWidth = (screenWidth - CGFloat(GamesVerticalGrid.ColumnCount * GamesVerticalGrid.Spacing))
        / CGFloat(GamesVerticalGrid.ColumnCount)
    private let columns = [GridItem](repeating: GridItem(.flexible()), count: GamesVerticalGrid.ColumnCount)

    var title: String
    @Binding var datas: [GamesGridData]
    var loadMore: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .asSectionTitle()
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))

            LazyVGrid(columns: columns) {
                ForEach(0..<datas.count, id: \.self) { idx in
                    VStack(spacing: 0) {
                        AsyncImage(urlStr: self.datas[idx].imgUrl)
                            .frame(width: cardWidth, height: cardWidth)
                            .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                        Text(datas[idx].title)
                            .font(.system(size: 14))
                            .lineLimit(1)
                    }
                    .frame(width: cardWidth)
                    .asCard()
                    .onAppear {
                        loadDataIfNeeded(datas[idx])
                    }
                }
            }
        }
        .onAppear {
            loadDataIfNeeded(nil)
        }
    }
}

extension GamesVerticalGrid {
    private func loadDataIfNeeded(_ item: GamesGridData?) {
        guard let item = item else {
            self.loadMore?()
            return
        }
        
        let tresholdIdx = datas.index(datas.endIndex, offsetBy: -5)
        if datas.firstIndex(where: { $0.id == item.id }) == tresholdIdx {
            self.loadMore?()
        }
    }
}

struct GamesGridData: Hashable {
    let id: String, imgUrl: String, title: String, releaseDate: String, rating: String
}
