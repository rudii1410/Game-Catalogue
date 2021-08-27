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

struct GamesVerticalGrid: View {
    private static let ColumnCount = 2
    private static let Spacing = 15
    private static let screenWidth = UIScreen.main.bounds.width
    private let cardWidth = (screenWidth - CGFloat(GamesVerticalGrid.ColumnCount * GamesVerticalGrid.Spacing))
        / CGFloat(GamesVerticalGrid.ColumnCount)
    private let gridLayout = [GridItem](repeating: GridItem(.flexible()), count: GamesVerticalGrid.ColumnCount)

    var title: String
    @Binding var datas: [GameShort]
    var loadMore: (() -> Void)?
    var onItemTap: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .asSectionTitle()
                .padding(.horizontal, 12)

            LazyVGrid(columns: gridLayout) {
                ForEach(0..<datas.count, id: \.self) { idx in
                    renderBody(game: self.datas[idx])
                        .frame(width: cardWidth)
                        .asCard()
                        .onAppear {
                            loadDataIfNeeded(self.datas[idx])
                        }
                        .onTapGesture {
                            self.onItemTap?(self.datas[idx].slug)
                        }
                }
            }
            .padding(.horizontal, 12)
        }
        .onAppear {
            loadDataIfNeeded(nil)
        }
    }

    private func renderBody(game: GameShort) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            LoadableImage(game.backgroundImage) { image in
                image.resizable()
                    .clipped()
                    .frame(width: cardWidth, height: cardWidth)
                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(game.name)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.vertical, 2)
                Text("Release: \(game.getFormattedString(format: "MMM d, y"))")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 0)
                    Text(String(game.rating ?? 0))
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        }
    }
}

extension GamesVerticalGrid {
    private func loadDataIfNeeded(_ item: GameShort?) {
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
    let identifier: String, imgUrl: String, title: String, releaseDate: String, rating: String
}
