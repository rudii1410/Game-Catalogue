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

struct FavouritesScreen: View {
    var datas = [GamesGridData](
        repeating: GamesGridData(identifier: UUID().uuidString, imgUrl: "", title: "Title games", releaseDate: "21-01-1990", rating: "5.0"),
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
