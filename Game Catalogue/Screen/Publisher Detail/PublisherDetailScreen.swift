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
import WebKit

struct PublisherDetailScreen: View {
    @ObservedObject private var model = PublisherDetailScreenViewModel()
    @State private var htmlHeight: CGFloat = 50.0
    private var slug: String

    init(slug: String) {
        self.slug = slug
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                LoadableImage(self.model.imageUrl) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .padding(.top, 8)
                        .clipped()
                }

                HTMLView(htmlString: self.model.desc, dynamicHeight: $htmlHeight)
                    .padding(.horizontal, 12)
                    .padding(.top, 6)
                    .frame(height: htmlHeight)

                Divider()
                    .padding(.vertical, 12)

                GamesVerticalGrid(
                    title: "Game from this publisher",
                    datas: self.$model.gameList
                ) {
                    self.model.loadMoreGameIfNeeded()
                }
                .padding(.bottom, 8)
                LoadingView()
            }
        }
        .onAppear { self.model.loadData(self.slug) }
        .navigationBarTitle(
            self.model.gameTitle,
            displayMode: .large
        )
    }
}
