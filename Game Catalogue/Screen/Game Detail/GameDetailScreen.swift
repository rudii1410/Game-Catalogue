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

    var body: some View {
        ScrollView {
            ImageSlider(
                urls: self.$model.imageUrls
            )
            LazyVStack {
                Picker("", selection: self.$model.selectedTab) {
                    Text("About").tag(0)
                    Text("Info").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())

                switch self.model.selectedTab {
                case 0: AboutTab()
                case 1: InfoTab()
                default: AboutTab()
                }
            }
            .padding(.horizontal, 12)
        }
    }
}
