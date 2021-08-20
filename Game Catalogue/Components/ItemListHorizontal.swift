//
//  ItemList.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 15/08/21.
//

import SwiftUI

struct ItemListHorizontal: View {
    var sectionTitle: String = ""
    var data: [ItemListData] = []
    var onSeeAllPressed: (() -> Void)?

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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    Spacer(minLength: 12)
                    ForEach(0..<data.count, id: \.self) { idx in
                        ItemListChild(idx: idx, data: data[idx])
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
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
    var data: ItemListData

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
            data.onClick(idx)
        }
    }
}

struct ItemListData {
    var imageUrl: String
    var title: String
    var onClick: (Int) -> Void
}
