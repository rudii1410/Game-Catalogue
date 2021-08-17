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
    private let gridLayout = [GridItem](repeating: GridItem(.flexible()), count: GamesVerticalGrid.ColumnCount)

    var title: String
    @Binding var datas: [GamesGridData]
    var loadMore: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .asSectionTitle()
                .padding(.horizontal, 12)

            LazyVGrid(columns: gridLayout) {
                ForEach(0..<datas.count, id: \.self) { idx in
                    VStack(alignment: .leading, spacing: 0) {
                        AsyncImage(urlStr: self.datas[idx].imgUrl)
                            .frame(width: cardWidth, height: cardWidth)
                            .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(datas[idx].title)
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .padding(.vertical, 2)
                            Text("Release: \(datas[idx].releaseDate)")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 0)
                                Text(datas[idx].rating)
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    }
                    .frame(width: cardWidth)
                    .asCard()
                    .onAppear {
                        loadDataIfNeeded(datas[idx])
                    }
                }
            }
            .padding(.horizontal, 12)
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
        if datas.firstIndex(where: { $0.identifier == item.identifier }) == tresholdIdx {
            self.loadMore?()
        }
    }
}

struct GamesGridData: Hashable {
    let identifier: String, imgUrl: String, title: String, releaseDate: String, rating: String
}
