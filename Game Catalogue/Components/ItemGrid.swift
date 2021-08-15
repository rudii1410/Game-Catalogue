//
//  ItemListGrid.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 15/08/21.
//

import SwiftUI

struct ItemGrid: View {
    private static let ColumnCount = 3
    private static let Spacing = 15
    private let cardWidth = (UIScreen.main.bounds.width - CGFloat(ItemGrid.ColumnCount * ItemGrid.Spacing))
        / CGFloat(ItemGrid.ColumnCount)
    private let columns = [GridItem](repeating: GridItem(.flexible()), count: ItemGrid.ColumnCount)

    var sectionTitle: String = ""
    var data: [ItemListData] = []
    var onSeeAllPressed: (() -> Void)?

    init(
        sectionTitle: String,
        data: [ItemListData],
        onSeeAllPressed: (() -> Void)?
    ) {
        self.sectionTitle = sectionTitle
        self.onSeeAllPressed = onSeeAllPressed
        self.data = data
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(sectionTitle)
                    .asSectionTitle()
                if self.onSeeAllPressed != nil {
                    Button("See all") {
                        self.onSeeAllPressed!()
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))

            LazyVGrid(columns: columns) {
                ForEach(0..<data.count, id: \.self) { idx in
                    VStack(spacing: 0) {
                        AsyncImage(urlStr: self.data[idx].imageUrl)
                            .frame(width: cardWidth, height: cardWidth)
                            .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                        Text(data[idx].title)
                            .font(.system(size: 14))
                            .lineLimit(1)
                    }
                    .frame(width: cardWidth)
                    .asCard()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
        }
    }
}
