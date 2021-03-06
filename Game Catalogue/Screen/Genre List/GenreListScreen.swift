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

private let columnCount = 2
struct GenreListScreen: View {
    private let gridLayout = [GridItem](repeating: GridItem(.flexible()), count: columnCount)

    @ObservedObject private var model: GenreListScreenViewModel

    init(model: GenreListScreenViewModel, _ genreList: [Genre]) {
        self.model = model
        self.model.genreList = genreList
    }

    var body: some View {
        ScrollView {
            NavigationLink(
                destination: GenreDetailScreen(
                    model: .init(interactor: ServiceContainer.instance.get()),
                    slug: self.model.selectedSlug
                ),
                isActive: self.$model.navigateToGenreDetail,
                label: { EmptyView() }
            )
            LazyVGrid(columns: gridLayout) {
                ForEach(self.model.genreList, id: \.id) { data in
                    ImageCardWithText(
                        data.imageBackground,
                        label: data.name
                    ) { self.model.onItemPressed(data) }
                    .frame(height: 150)
                    .onAppear {
                        self.model.loadMoreGenreIfNeeded(data)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
        }
        .navigationBarTitle("Publisher List")
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
