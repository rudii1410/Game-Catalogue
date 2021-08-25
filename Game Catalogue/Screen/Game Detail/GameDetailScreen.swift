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

struct GameDetailScreen: View {
    @ObservedObject private var model = GameDetailScreenViewModel()
    @State private var htmlHeight: CGFloat = 50.0

    init(slug: String) {
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
                .navigationBarTitle(self.model.gameTitle, displayMode: .large)
        }
    }

    private func renderContent() -> some View {
        return Group {
            ScrollView {
                VStack {
                    renderHeaderSection()
                        .padding(.bottom, 22)
                    renderGameDescSection()
                        .padding(.bottom, 22)
                    renderGameScreenshotSection()
                        .padding(.bottom, 22)
                    renderPlatformAndReleaseDateSection()
                        .padding(.bottom, 22)
                    renderDeveloperAndPublisherSection()
                        .padding(.bottom, 22)
                    GamesVerticalGrid(
                        title: "Game like this",
                        datas: self.$model.gameList
                    ) {
                        self.model.loadGames()
                    }
                    .padding(.bottom, 8)
                    LoadingView()
                    Spacer(minLength: 22)
                }
            }
        }
    }

    private func renderHeaderSection() -> some View {
        return VStack {
            LoadableImage(self.model.bannerImage) { image in
                image.resizable()
                    .frame(height: 200)
                    .aspectRatio(contentMode: .fit)
            }

            Spacer(minLength: 18)

            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Genres")
                        .foregroundColor(.gray)
                        .bold()
                    Text(self.model.genreStr)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
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

    private func renderGameScreenshotSection() -> some View {
        return VStack(alignment: .leading, spacing: 8) {
            Text("Game Screenshots")
                .font(.title3)
                .bold()
                .padding(.horizontal, 12)
            ImageSlider(
                urls: self.$model.screenshots
            )
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
