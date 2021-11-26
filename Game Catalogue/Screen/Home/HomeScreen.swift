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
import Core

struct HomeScreen: View {
    @ObservedObject var model: HomeScreenViewModel

    init(model: HomeScreenViewModel) {
        self.model = model
        self.model.fetchUpcomingReleaseGame()
        self.model.fetchPublisherList()
    }

    var body: some View {
        GeometryReader { fullScreen in
            NavigationLink(
                destination: GameDetailScreen(
                    model: .init(interactor: ServiceContainer.instance.get()),
                    slug: self.model.selectedGameSlug
                ),
                isActive: self.$model.navigateToGameDetail,
                label: { EmptyView() }
            )
            ScrollView {
                renderImageSlider(fullScreen)
                Divider()
                    .padding(.vertical, 20)
                renderGamePublisher()
                Divider()
                    .padding(.vertical, 20)
                renderGameGenre()
                Divider()
                    .padding(.vertical, 20)
                renderGameList()

                if self.model.isLoadingGameData {
                    LoadingView()
                }

                Spacer(minLength: 8)
            }
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
}

extension HomeScreen {
    func renderImageSlider(_ screen: GeometryProxy) -> some View {
        return VStack(spacing: 8) {
            Text("Upcoming Release")
                .asSectionTitle()
                .padding(.horizontal, 12)
                .padding(.top, 16)
            ImageSlider(
                urls: self.$model.upcomingGamesBanner
            ) { idx in
                model.onBannerImagePressed(idx)
            }
            .padding(.horizontal, 12)
            .frame(width: screen.size.width, height: screen.size.width * (2 / 3))
        }
        .padding(.bottom, 4)
    }
}

extension HomeScreen {
    func renderGamePublisher() -> some View {
        return Group {
            NavigationLink(
                destination: PublisherListScreen(
                    model: .init(interactor: ServiceContainer.instance.get()),
                    self.model.publisherList
                ),
                isActive: self.$model.navigateToPublisherList,
                label: { EmptyView() }
            )
            NavigationLink(
                destination: PublisherDetailScreen(
                    model: .init(interactor: ServiceContainer.instance.get()),
                    slug: self.model.selectedPublisherSlug
                ),
                isActive: self.$model.navigateToPublisherDetail,
                label: { EmptyView() }
            )
            ItemListHorizontal(
                sectionTitle: "Game Publisher",
                data: self.model.gamePublisherList,
                onSeeAllPressed: { self.model.navigateToPublisherList = true },
                onItemPressed: { id in
                    self.model.selectedPublisherSlug = id
                    self.model.navigateToPublisherDetail = true
                }
            )
        }
    }
}

extension HomeScreen {
    func renderGameGenre() -> some View {
        return Group {
            NavigationLink(
                destination: GenreListScreen(
                    model: .init(interactor: ServiceContainer.instance.get()),
                    self.model.genreList
                ),
                isActive: self.$model.navigateToGenreList,
                label: { EmptyView() }
            )
            NavigationLink(
                destination: GenreDetailScreen(
                    model: .init(interactor: ServiceContainer.instance.get()),
                    slug: self.model.selectedGenreSlug
                ),
                isActive: self.$model.navigateToGenreDetail,
                label: { EmptyView() }
            )
            ItemGrid(
                sectionTitle: "Popular Genres",
                data: self.model.gameGenreList,
                onSeeAllPressed: {
                    self.model.navigateToGenreList = true
                },
                onItemPressed: { id in
                    self.model.selectedGenreSlug = id
                    self.model.navigateToGenreDetail = true
                }
            )
        }.onAppear {
            self.model.fetchGenreList()
        }
    }
}

extension HomeScreen {
    func renderGameList() -> some View {
        return GamesVerticalGrid(
            title: "You may like these games",
            datas: self.$model.gameList,
            loadMore: self.model.fetchGameList,
            onItemTap: self.model.onGameSelected
        )
        .onAppear {
            self.model.fetchGameList()
        }
    }
}
