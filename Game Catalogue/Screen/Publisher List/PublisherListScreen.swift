//
//  PublisherListScreen.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import SwiftUI

private let columnCount = 2

struct PublisherListScreen: View {
    private let gridLayout = [GridItem](repeating: GridItem(.flexible()), count: columnCount)

    @ObservedObject private var model = PublisherListScreenViewModel()

    var body: some View {
        ScrollView {
            NavigationLink(
                destination: PublisherDetailScreen(
                    slug: "slug"
                ),
                isActive: self.$model.navigateToPublisherDetail,
                label: { EmptyView() }
            )
            LazyVGrid(columns: gridLayout) {
                ForEach(self.model.gamePublisher, id: \.ids) { data in
                    ImageCardWithText(
                        data.imgUrl,
                        label: data.label
                    ) { self.model.onItemPressed(data) }
                    .frame(height: 150)
                    .onAppear {
                        self.model.loadMorePublisherIfNeeded(data)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
        }
        .navigationBarTitle("Publisher List")
    }
}
