//
//  PublisherDetailScreen.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//
//  swiftlint:disable line_length

import SwiftUI

struct PublisherDetailScreen: View {
    @ObservedObject private var model = PublisherDetailScreenViewModel()
    @State private var games: [GamesGridData] = []
    @State private var isLoadingGamesData = false
    @State private var isReachMaxFetch: Bool = false
    @State private var fetchCounter = 0
    let slug: String

    var body: some View {
        ScrollView {
            LazyVStack {
                LoadableImage("https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg") { image in
                    image.resizable()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text("At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.")
                    .padding(.horizontal, 12)
                    .padding(.top, 6)
                    .font(.system(size: 14))

                Divider()
                    .padding(.vertical, 12)

                GamesVerticalGrid(
                    title: "You may like these games",
                    datas: $games
                ) {
                    if isReachMaxFetch || isLoadingGamesData { return }

                    isLoadingGamesData = true
                    let start = self.games.count
                    let end = start + 5
                    print("\(start) \(end)")
                    var games: [GamesGridData] = []
                    for key in start...end-1 {
                        games.append(GamesGridData(identifier: String(key), imgUrl: HomeScreen.imgs, title: "Title games", releaseDate: "21-01-1990", rating: "5.0"))
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.games.append(contentsOf: games)
                        fetchCounter += 1
                        isReachMaxFetch = fetchCounter > 20
                        isLoadingGamesData = false
                    }
                }
                .padding(.bottom, 8)
                LoadingView()
            }
        }
        .navigationBarTitle(
            self.model.publisherDetail?.label ?? "Game publisher",
            displayMode: .large
        )
    }
}
