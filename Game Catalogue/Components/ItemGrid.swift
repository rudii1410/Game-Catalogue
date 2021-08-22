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
                        LoadableImage(self.data[idx].imageUrl) { image in
                            image.resizable()
                                .clipped()
                                .frame(width: cardWidth, height: cardWidth)
                                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                        }
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
