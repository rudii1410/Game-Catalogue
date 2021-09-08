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

struct ItemListHorizontal: View {
    var sectionTitle: String = ""
    var data: [ItemListHorizontalData] = []
    var onSeeAllPressed: (() -> Void)?
    var onItemPressed: ((String) -> Void)

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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    Spacer(minLength: 12)
                    ForEach(0..<data.count, id: \.self) { idx in
                        ItemListChild(idx: idx, data: data[idx]) { id in
                            self.onItemPressed(id)
                        }
                        .padding(.horizontal, 12)
                    }
                    Spacer(minLength: 12)
                }
            }
        }
    }
}

private struct ItemListChild: View {
    private static let SIZE: CGFloat = 125

    var idx: Int
    var data: ItemListHorizontalData
    var onPressed: (String) -> Void

    var body: some View {
        VStack {
            LoadableImage(data.imageUrl) { img in
                img.resizable()
                    .clipped()
                    .frame(width: ItemListChild.SIZE, height: ItemListChild.SIZE)
                    .cornerRadius(10, antialiased: true)
            }
            Text(data.title)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .frame(width: ItemListChild.SIZE)
        .onTapGesture {
            self.onPressed(data.id)
        }
    }
}

struct ItemListHorizontalData {
    var id: String
    var imageUrl: String
    var title: String
}
