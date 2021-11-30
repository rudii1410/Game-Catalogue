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
import SDWebImageSwiftUI
import Core
import Common

struct FavouritesScreen: View {
    @ObservedObject private var model: FavouriteScreenViewModel
    @State var searchText: String = ""

    init(model: FavouriteScreenViewModel) {
        self.model = model
    }

    var body: some View {
        VStack(spacing: 12) {
            NavigationLink(
                destination: GameDetailScreen(
                    model: .init(interactor: ServiceContainer.instance.get()),
                    slug: self.model.selectedSlug
                ),
                isActive: self.$model.navigateToGameDetail,
                label: { EmptyView() }
            )
            SearchBar(searchText: $searchText)
                .padding(.horizontal, 12)
                .padding(.top, 12)
            List {
                ForEach(
                    model.favourites.filter {
                        searchText.isEmpty || $0.name.localizedStandardContains(searchText)
                    },
                    id: \.self
                ) { data in
                    renderItemList(data: data)
                        .onTapGesture {
                            model.onItemTap(slug: data.slug)
                        }
                        .onAppear {
                            model.loadFavouriteIfNeeded(data)
                        }
                }
                .onDelete { indexSet in
                    self.model.performDelete(index: indexSet)
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            model.reloadData()
        }
    }

    private func renderItemList(data: Favourite) -> some View {
        HStack(spacing: 12) {
            WebImage(url: URL(string: data.image))
                .defaultPlaceholder()
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 2) {
                Text(data.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.vertical, 1)
                Text("Release on: \(data.getReleaseDate())")
                    .font(.subheadline)
                    .padding(.vertical, 1)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 0)
                    Text(String(data.rating))
                        .font(.caption)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
        }
    }
}
