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
import SDWebImageSwiftUI
import Core
import Common
import DesignSystem

struct PublisherDetailScreen: View {
    @ObservedObject private var model: PublisherDetailScreenViewModel
    @State private var htmlHeight: CGFloat = 50.0
    private var slug: String
    private let gameModuleProvider: GameProviderInterface = Navigator.instance.getProvider(GameProviderInterface.self)

    init(model: PublisherDetailScreenViewModel, slug: String) {
        self.model = model
        self.slug = slug
    }

    var body: some View {
        ScrollView {
            NavigationLink(
                destination: gameModuleProvider.getGameDetailScreen(slug: self.model.selectedGameSlug),
                isActive: self.$model.navigateToGameDetail,
                label: { EmptyView() }
            )
            LazyVStack {
                WebImage(url: URL(string: self.model.imageUrl))
                    .defaultPlaceholder()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .padding(.top, 8)
                    .clipped()

                HTMLView(htmlString: self.model.desc, dynamicHeight: $htmlHeight)
                    .padding(.horizontal, 12)
                    .padding(.top, 6)
                    .frame(height: htmlHeight)

                Divider()
                    .padding(.vertical, 12)

                GamesVerticalGrid(
                    title: "Game from this publisher",
                    games: self.$model.gameList,
                    loadMore: self.model.loadGameList,
                    onItemTap: self.model.onGameTap
                )
                .padding(.bottom, 8)
                LoadingView()
            }
        }
        .onAppear { self.model.loadData(self.slug) }
        .navigationBarTitle(
            self.model.gameTitle,
            displayMode: .large
        )
        .alert(isPresented: self.$model.showErrorNetwork) {
            Alert(
                title: Text("Unable to load the data"),
                message: Text("The connection to the server was lost. Go check your internet connection"),
                dismissButton: .default(
                    Text("Close App"),
                    action: { exit(0) }
                )
            )
        }
    }
}
