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

struct GameDetailScreen: View {
    @ObservedObject private var model: GameDetailScreenViewModel
    @State private var htmlHeight: CGFloat = 50.0

    init(model: GameDetailScreenViewModel, slug: String) {
        self.model = model
        self.model.loadGameDetail(slug: slug)
    }

    var body: some View {
        if self.model.isLoading {
            VStack {
                Spacer()
                ProgressView()
                Text("Loading the games you wanted to see!! Please wait!")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        } else {
            renderContent()
                .navigationBarTitle("Game Details", displayMode: .inline)
                .toolbar {
                    ToolbarItem {
                        Image(systemName: model.favouriteData == nil ? "heart" : "heart.fill")
                            .opacity(self.model.imgFadeOut ? 0 : 1)
                            .animation(.easeInOut(duration: 0.3))
                            .onTapGesture {
                                self.model.imgFadeOut.toggle()
                                model.onFavouriteTap()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        self.model.imgFadeOut.toggle()
                                    }
                                }
                            }
                    }
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

    private func renderContent() -> some View {
        return GeometryReader { fullScreen in
            ScrollView {
                VStack {
                    NavigationLink(
                        destination: GameDetailScreen(
                            model: .init(interactor: ServiceContainer.instance.get()),
                            slug: self.model.selectedGameSlug
                        ),
                        isActive: self.$model.navigateToGameDetail,
                        label: { EmptyView() }
                    )
                    renderHeaderSection()
                        .padding(.bottom, 22)
                    renderGameDescSection()
                        .padding(.bottom, 22)
                    renderGameScreenshotSection(fullScreen)
                        .padding(.bottom, 22)
                    renderPlatformAndReleaseDateSection()
                        .padding(.bottom, 22)
                    renderDeveloperAndPublisherSection()
                        .padding(.bottom, 22)
                    GamesVerticalGrid(
                        title: "Game like this",
                        datas: self.$model.gameList,
                        loadMore: self.model.loadGames,
                        onItemTap: self.model.onGameTap
                    )
                    .padding(.bottom, 8)
                    LoadingView()
                    Spacer(minLength: 22)
                }
            }
        }
    }

    private func renderHeaderSection() -> some View {
        return VStack(alignment: .leading) {
            WebImage(url: URL(string: self.model.bannerImage))
                .defaultPlaceholder()
                .resizable()
                .frame(height: 200)
                .aspectRatio(contentMode: .fit)

            Text(self.model.gameTitle)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.init(top: 16, leading: 12, bottom: 8, trailing: 12))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Genres")
                        .foregroundColor(.gray)
                        .bold()
                    Text(self.model.genreStr)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(minWidth: 0, maxWidth: .infinity)
                .overlay(Divider(), alignment: .trailing)

                VStack(alignment: .center, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.yellow)
                            .padding(.horizontal, 0)
                        Text("\(self.model.rating)")
                            .font(.system(size: 28))
                    }
                    Text("\(self.model.ratingCount) reviews")
                        .font(.subheadline)
                }
                .padding(.horizontal, 12)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }

    private func renderGameDescSection() -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("About")
                .font(.title3)
                .bold()
            HTMLView(htmlString: self.model.desc, dynamicHeight: $htmlHeight)
                .frame(height: htmlHeight)
        }
        .padding(.horizontal, 12)
    }

    private func renderGameScreenshotSection(_ screen: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 8) {
            Text("Game Screenshots")
                .font(.title3)
                .bold()
                .padding(.horizontal, 12)
            ImageSlider(
                urls: self.$model.screenshots
            )
            .padding(.horizontal, 12)
            .frame(width: screen.size.width, height: screen.size.width / 2)
        }
    }

    private func renderPlatformAndReleaseDateSection() -> some View {
        return HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Platforms")
                    .foregroundColor(.gray)
                    .bold()
                Text(self.model.platformStr)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .frame(minWidth: 0, maxWidth: .infinity)
            VStack(alignment: .leading, spacing: 4) {
                Text("Release date")
                    .foregroundColor(.gray)
                    .bold()
                Text(self.model.releaseDate)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }

    private func renderDeveloperAndPublisherSection() -> some View {
        return HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Developers")
                    .foregroundColor(.gray)
                    .bold()
                Text(self.model.developers)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .frame(minWidth: 0, maxWidth: .infinity)
            VStack(alignment: .leading, spacing: 4) {
                Text("Publishers")
                    .foregroundColor(.gray)
                    .bold()
                Text(self.model.publisher)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}
