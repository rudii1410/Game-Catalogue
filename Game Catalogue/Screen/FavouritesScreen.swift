//
//  FavouritesScreen.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 14/08/21.
//

import SwiftUI

struct FavouritesScreen: View {
    var datas = [GamesGridData](
        repeating: GamesGridData(identifier: UUID().uuidString, imgUrl: HomeScreen.imgs, title: "Title games", releaseDate: "21-01-1990", rating: "5.0"),
        count: 100
    )
    @State var searchText: String = ""

    var body: some View {
        VStack(spacing: 12) {
            SearchBar(searchText: $searchText)
                .padding(.horizontal, 12)
                .padding(.top, 12)
            List(
                datas.filter {
                    searchText.isEmpty || $0.title.localizedStandardContains(searchText)
                },
                id: \.self
            ) { data in
                HStack(spacing: 12) {
                    LoadableImage("https://statik.tempo.co/data/2019/09/11/id_871476/871476_720.jpg") { image in
                        image.resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(data.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .padding(.vertical, 1)
                        Text("Release on: \(data.releaseDate)")
                            .font(.subheadline)
                            .padding(.vertical, 1)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                                .padding(.horizontal, 0)
                            Text(data.rating)
                                .font(.caption)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                }
                .onTapGesture {
                    onItemTap()
                }
            }
            .listStyle(PlainListStyle())
        }
    }

    private func onItemTap() {
        print("tapped")
    }
}
