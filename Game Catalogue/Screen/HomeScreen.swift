//
//  HomeScreen.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 13/08/21.
//

import SwiftUI

struct HomeScreen: View {
    static let imgs = "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg"

    @State private var test = 0
    @State private var games: [GamesGridData] = []
    @State private var isLoadingGamesData = false
    @State private var fetchCounter = 0
    @State private var headerImgs: [String] = []
    @State private var isReachMaxFetch: Bool = false

    let dummyItemlistData = ItemListData(
        imageUrl: "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg",
        title: "title adasda asdas das asdaasdasd",
        onClick: { idx in
            print(idx)
        }
    )
    let maxFetch = 3

    init() {
        let start = self.games.count
        let end = start + 10
        for key in start...end-1 {
            let add = key % 3 == 0 ? "asdahs hsgdkaj dajsghdahsdh agsdhgs sdsd" : ""
            games.append(GamesGridData(identifier: String(key), imgUrl: HomeScreen.imgs, title: "Title games \(add)", releaseDate: "21-01-1990", rating: "5.0"))
        }
        self.games.append(contentsOf: games)
        fetchCounter += 1
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    renderImageSlider()
                    Divider()
                    renderGamePublisher()
                    Divider()
                    renderGameGenre()
                    Divider()
                    renderGameList()

                    if isLoadingGamesData {
                        HStack(alignment: .center, spacing: 6) {
                            Spacer()
                            ProgressView()
                            Text("Fetching more data for you, hang tight!")
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                            Spacer()
                        }
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
                .navigationBarTitle("Games catalogue", displayMode: .large)
            }
        }
    }
}

extension HomeScreen {
    func renderImageSlider() -> some View {
        return VStack(spacing: 8) {
            Text("Upcoming Release")
                .asSectionTitle()
                .padding(EdgeInsets(top: 16, leading: 12, bottom: 0, trailing: 12))
            ImageSlider(
                urls: self.$headerImgs
            ) { idx in
                test = idx
            }
            Spacer()
        }.onAppear {
            self.headerImgs = [
                "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg",
                "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg",
                "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg",
                "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg",
                "https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg"
            ]
        }
    }
}

extension HomeScreen {
    func renderGamePublisher() -> some View {
        return ItemListHorizontal(
            sectionTitle: "Game Publisher",
            data: [ItemListData](repeating: dummyItemlistData, count: 6),
            onSeeAllPressed: seeAllGamePublisher
        )
    }
    
    private func seeAllGamePublisher() {
        
    }
}

extension HomeScreen {
    func renderGameGenre() -> some View {
        return ItemGrid(
            sectionTitle: "Popular Genres",
            data: [ItemListData](repeating: dummyItemlistData, count: 6),
            onSeeAllPressed: {
                print("see all")
            }
        )
    }
}

extension HomeScreen {
    func renderGameList() -> some View {
        return GamesVerticalGrid(
            title: "You may like these games",
            datas: $games
        ) {
            if isReachMaxFetch || isLoadingGamesData { return }

            isLoadingGamesData = true
            let start = self.games.count
            let end = start + 10
            print("\(start) \(end)")
            var games: [GamesGridData] = []
            for key in start...end-1 {
                let add = key % 3 == 0 ? "asdahs hsgdkaj dajsghdahsdh agsdhgs sdsd" : ""
                games.append(GamesGridData(identifier: String(key), imgUrl: HomeScreen.imgs, title: "Title games \(add)", releaseDate: "21-01-1990", rating: "5.0"))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.games.append(contentsOf: games)
                fetchCounter += 1
                isReachMaxFetch = fetchCounter > maxFetch
                isLoadingGamesData = false
            }
        }
    }
}
