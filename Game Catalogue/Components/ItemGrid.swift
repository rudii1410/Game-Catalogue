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
import SDWebImageSwiftUI

struct ItemGrid: View {
    private static let ColumnCount = 3
    private static let Spacing = 15
    private let cardWidth = (UIScreen.main.bounds.width - CGFloat(ItemGrid.ColumnCount * ItemGrid.Spacing))
        / CGFloat(ItemGrid.ColumnCount)
    private let columns = [GridItem](repeating: GridItem(.flexible()), count: ItemGrid.ColumnCount)

    var sectionTitle: String = ""
    var data: [ItemGridData] = []
    var onSeeAllPressed: (() -> Void)?
    var onItemPressed: (String) -> Void

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(sectionTitle)
                    .asSectionTitle()
                if self.onSeeAllPressed != nil {
                    Button("See all") {
                        self.onSeeAllPressed?()
                    }
                }
            }
            .padding(.horizontal, 12)

            LazyVGrid(columns: columns) {
                ForEach(0..<data.count, id: \.self) { idx in
                    VStack(spacing: 0) {
                        WebImage(url: URL(string: self.data[idx].imageUrl))
                            .defaultPlaceholder()
                            .resizable()
                            .clipped()
                            .frame(width: cardWidth, height: cardWidth)
                            .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                        Text(data[idx].title)
                            .font(.system(size: 14))
                            .lineLimit(2)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 6)
                    }
                    .frame(width: cardWidth)
                    .asCard()
                    .onTapGesture {
                        self.onItemPressed(self.data[idx].id)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

struct ItemGridData {
    let id, imageUrl, title: String
}
