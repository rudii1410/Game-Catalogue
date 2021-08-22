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

struct HomeScreen: View {
    static let imgs = "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg"

    @State private var games: [GamesGridData] = []
    @State private var isLoadingGamesData = false
    @State private var isReachMaxFetch = false
    @State private var fetchCounter = 0
    @State private var headerImgs: [String] = []

    @ObservedObject private var model = HomeScreenViewModel()
    let maxFetch = 3

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                renderImageSlider()
                Divider()
                renderGamePublisher()
                Divider()
                renderGameGenre()
                Divider()
//                renderGameList()

                if isLoadingGamesData {
                    LoadingView()
                }

                if isReachMaxFetch {
                    Text("Whoaa you arrive at the end. Maybe go to the Explore tab to see more??")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Spacer(minLength: 8)
            }
        }
    }
}

extension HomeScreen {
    func renderImageSlider() -> some View {
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
        }.onAppear {
            self.model.fetchUpcomingReleaseGame()
        }
    }
}

extension HomeScreen {
    func renderGamePublisher() -> some View {
        return Group {
            NavigationLink(
                destination: PublisherListScreen(self.model.publisherList),
                isActive: self.$model.navigateToPublisherList,
                label: { EmptyView() }
            )
            NavigationLink(
                destination: PublisherDetailScreen(
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
        }.onAppear {
            self.model.fetchPublisherList()
        }
    }
}

extension HomeScreen {
    func renderGameGenre() -> some View {
        return Group {
            NavigationLink(
                destination: GenreListScreen(self.model.genreList),
                isActive: self.$model.navigateToGenreList,
                label: { EmptyView() }
            )
            NavigationLink(
                destination: GenreDetailScreen(
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
//    func renderGameList() -> some View {
//        return GamesVerticalGrid(
//            title: "You may like these games",
//            datas: [$games]
//        ) {
//            if isReachMaxFetch || isLoadingGamesData { return }
//
//            isLoadingGamesData = true
//            let start = self.games.count
//            let end = start + 10
//            print("\(start) \(end)")
//            var games: [GamesGridData] = []
//            for key in start...end - 1 {
//                let add = key % 3 == 0 ? "asdahs hsgdkaj dajsghdahsdh agsdhgs sdsd" : ""
//                games.append(GamesGridData(identifier: String(key), imgUrl: HomeScreen.imgs, title: "Title games \(add)", releaseDate: "21-01-1990", rating: "5.0"))
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                self.games.append(contentsOf: games)
//                fetchCounter += 1
//                isReachMaxFetch = fetchCounter > maxFetch
//                isLoadingGamesData = false
//            }
//        }
//    }
}
